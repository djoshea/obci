classdef PrairieControl < handle
    % @djoshea 2015

    properties
        saveRoot = 'F:\DataRoot';
        
        chDisplay = 2;
    end
    
    properties(SetAccess=protected)
        pl % PrairieLink ActiveX Server
        
        sockRecv % pnet socket handle
        sockSend
        
        dateStr;

        isImaging = 0;
        
        cycleCount = 0;
        
        scopeInfo % stores MicroscopeStateBus struct
        
        liveDisplayActive = false; % whether averaging is updating the image window
        
        
        liveDisplaySystem
    end
    
    properties
        dataStore = 'rig1';
        subject = 'Xavier';
        protocol = 'Exploratory';
        saveTag = 1;
        trialId = 0;
        siteNum = 1;
        mode = 'exploratory';
    end
    
    properties % for GUI
        hfig
        handles
        hLiveImage
        axLiveImage
        
        liveDisplayUpdateRate = NaN;
        liveDisplayAverageFrames = 64;
    end
    
    properties(Constant)
        guiTag = 'PrairieControlGui';
    end
    
    methods(Static)
        function inst = getInstance()
            inst = PrairieControl();
        end 
    end
    
    methods % UDP utils, send microscope bus, receive commands
        function pc = PrairieControl()
            try
                fromBase = evalin('base', 'PrairieControlInstance');
                if isvalid(fromBase) && isa(fromBase, 'PrairieControl')
                    pc = fromBase;
                    return
                end
            catch
            end
                
            % connect to prairie link
            % thanks to http://undocumentedmatlab.com/blog/fixing-matlabs-actxserver
            % try to reuse an existing COM server instance if possible
            PrairieControl.print('Connecting to PrairieLink\n');
            try
                pc.pl = actxGetRunningServer('PrairieLink.Application');
                % no crash so probably succeeded to connect to a running server
            catch
                % didn't work - continue normally to start the COM server and connect to it
                pc.pl = actxserver('PrairieLink.Application');
            end
            pc.pl.Connect();
            
            assignin('base', 'PrairieControlInstance', pc);
            
            % listen on udp
            PrairieControl.print('Connecting to UDP receive\n');
            pc.sockRecv = pnet('udpsocket', 10001, 'broadcast');   
            if pc.sockRecv == -1
                error('Error connecting to UDP port');
            end
            
            % send on udp (needs to be separate socket to continue
            % receiving, not sure why)
            PrairieControl.print('Connecting to UDP send\n');
            pc.sockSend = pnet('udpsocket', 10000, 'broadcast');
            pnet(pc.sockSend, 'udpconnect', '192.168.20.255', 10002);
            
            createMicroscopeBuses();
            
%             pc.sockRecv = udp('192.168.20.2', 10000, 'LocalPort', 10001);
%             pc.sockRecv.Terminator = char(0);
%             pc.sockRecv.BytesAvailableFcnCount = 1;
%             pc.sockRecv.BytesAvailableFcnMode = 'byte';
%             pc.sockRecv.BytesAvailableFcn = @pc.udpReceiveCallback;
%             fopen(pc.sockRecv);
%             readasync(pc.sockRecv);
        end
    end
    
    methods
        function delete(pc)
            if ~isempty(pc.pl)
                PrairieControl.print('Disconnecting PrairieLink\n');
                try
                    pc.pl.Disconnect();
                catch
                end
            end
            
            if ~isempty(pc.sockRecv)
                PrairieControl.print('Disconnecting UDP\n');
                try
                    fclose(pc.sockRecv);
                catch
                end
            end
            
            if ~isempty(pc.sockSend)
                PrairieControl.print('Disconnecting UDP\n');
                try
                    fclose(pc.sockSend);
                catch
                end
            end
        end

        
        function udpFlush(pc)
            str = 'tmp';
            while ~isempty(str)
                str = pc.udpReceive();
            end
        end
        
        function str = udpReceive(pc, varargin)
            size = pnet(pc.sockRecv, 'readpacket', 65535, 'noblock');
            if size > 0
                str = char(pnet(pc.sockRecv,'read', 'noblock'));
            else
                str = '';
            end
            if ~isempty(str)
                %PrairieControl.print('Received commands %s\n', str);
            end 
        end
        
        function udpSend(pc, str)
            pnet(pc.sockSend, 'write', uint8(str), 'network');
            pnet(pc.sockSend, 'writepacket');
        end
        
        function sendMicroscopeStateBus(pc)
            info = initializeBus_MicroscopeStateBus();
            update = pc.queryMicroscopeState();
            info = setstructfields(info, update);
            str = serializeBus_MicroscopeStateBus(info);
            pc.udpSend(str);
        end
        
        function success = sendPrairieCommand(pc, str)
            fprintf('PrairieLink: %s ', str);
            result = pc.pl.SendScriptCommands(str);
            success = result == 1;
            if ~success
                warning('PrairieLink command %s did not succeed', str);
            else
                fprintf(' [success]\n');
            end
            
        end
        
        function success = sendPrairieCommandViaShell(pc, str) %#ok<INUSL>
            fprintf('PrairieLink: %s', str);
            status = system(['"C:\Program Files\Prairie\Prairie View\Prairie View".exe ' str ' ']);
            success = status == 0;
            if ~success
                warning('PrairieLink command %s did not succeed', str);
            else
                fprintf(' [success]\n');
            end
        end
        
        function commands = parseUdpCommands(~, str)
            % commands is struct with field .name and .args which is a
            % struct. commands look like
            % 'NextTrial trialId=31, protocol=Protocol; NextCommand...'
            
            iC = 1;
            while ~isempty(str)
                [tok, rem] = strtok(str, ';');
                tok = strtrim(tok);
                str = strtrim(rem(2:end));
                
                command = regexp(tok, '(\w+)', 'tokens', 'once');
                if isempty(command)
                    break;
                end
                command = command{1};
                argsStr = strtrim(tok(numel(command)+1:end));
                argTok = regexp(argsStr, '(\w+)=?(\w+)?', 'tokens');
                
                commands(iC).command = strtrim(command); %#ok<AGROW>
                commands(iC).args = struct(); %#ok<AGROW>
                for iA = 1:numel(argTok)
                    argName = matlab.lang.makeValidName(strtrim(argTok{iA}{1}));
                    argVal = strtrim(argTok{iA}{2});
                    if isempty(argVal)
                        % argument without value is just a boolean flag
                        argVal = true;
                    elseif strcmp(argVal, 'false')
                        argVal = false;
                    else
                        num = str2double(argVal);
                        if ~isnan(num)
                            argVal = num;
                        end
                    end
                        
                    commands(iC).args.(argName) = argVal;
                end
                iC = iC + 1;
            end
        end
        
        function processUdpCommands(pc, cmds)
            for iC = 1:numel(cmds)
                cmd = cmds(iC);
                args = cmd.args;
                switch cmd.command
                    case 'NextTrial'
                        if isfield(args, 'dataStore')
                            pc.dataStore = args.dataStore;
                        end
                        if isfield(args, 'subject')
                            pc.subject = args.subject;
                        end
                        if isfield(args, 'protocol')
                            pc.protocol = args.protocol;
                        end
                        if isfield(args, 'trialID')
                            pc.trialId = args.trialID;
                        else
                            pc.trialId = pc.trialId + 1;
                        end
                        
%                        if ~pc.isImaging
                             pc.setFileLocationTask();
 %                       end
                        
                    case 'StartImaging'
                        if ~pc.isImaging
                            pc.isImaging = true;
                            %pc.startTseries();
                        end 
                        pc.sendMicroscopeStateBus();
                        
                    case 'StopImaging'
                        if pc.isImaging
                            %warning('Ignoring StopImaging command\n');
                            %pc.stopImaging();
                        end
                        
                    otherwise
                        warning('Unknown UDP command %s', cmd.command);
                end
            end
        end
        
        function run(pc)
            PrairieControl.print('Waiting for UDP commands...\n');
            pc.udpFlush();
            while(true)
                str = pc.udpReceive();
                if ~isempty(str)
                    commands = pc.parseUdpCommands(str);
                    pc.processUdpCommands(commands);
                end
            end
        end
        
        function receiveAndProcessUdpCommands(pc)
            str = pc.udpReceive();
            while ~isempty(str)
                commands = pc.parseUdpCommands(str);
                pc.processUdpCommands(commands);
                str = pc.udpReceive();
            end
        end
    end
    
    methods % 2P imaging and file locations
        function incrementSiteNum(pc)
            pc.setSiteNum(pc.siteNum+1);
        end

        function setSiteNum(pc, siteNum)
            pc.siteNum = siteNum;
            pc.updateFileLocation();
        end

        function updateFileLocation(pc)
            if strcmp(pc.mode, 'task')
                pc.setFileLocationTask();
            else
                pc.setFileLocationExploratory();
            end
            pc.sendMicroscopeStateBus();
        end
        
        function setFileLocationTask(pc)
            pc.dateStr = datestr(now, 'yyyy-mm-dd');
            dateStrNoHyphen = datestr(now, 'yyyymmdd');
            
            folder = fullfile(pc.saveRoot, pc.dataStore, pc.subject, pc.dateStr, '2P', pc.protocol, sprintf('site%03d', pc.siteNum));
            PrairieControl.mkdirRecursive(folder);
            
            cmd = sprintf('-SetSavePath %s', folder);
            pc.sendPrairieCommand(cmd);
               
            file = sprintf('SingleImage_%s', dateStrNoHyphen);
            assert(~any(isspace(file)), 'File cannot have spaces');
            cmd = sprintf('-SetFileName Singlescan %s', file);
            pc.sendPrairieCommand(cmd);
            
            timeStr = datestr(now, 'YYYYmmdd.HHMMSS.FFF');
            file = sprintf('Tseries_%s_%s_%s_time%s%s', dateStrNoHyphen, pc.subject, pc.protocol, timeStr);
            assert(~any(isspace(file)), 'File cannot have spaces');
            cmd = sprintf('-SetFileName Tseries %s', file);
            pc.sendPrairieCommand(cmd);
            
%             cmd = '-SetFileIteration Tseries 1';
%             pc.sendPrairieCommand(cmd);
            
            file = sprintf('Zseries_%s', dateStrNoHyphen);
            assert(~any(isspace(file)), 'File cannot have spaces');
            cmd = sprintf('-SetFileName Zseries %s', file);
            pc.sendPrairieCommand(cmd);
            
            pc.mode = 'task';
            
            if pc.hasGui
                pc.updateGuiTaskInfo();
            end
        end
        
        function setFileLocationExploratory(pc)
            pc.dateStr = datestr(now, 'yyyy-mm-dd');
            dateStrNoHyphen = datestr(now, 'yyyymmdd');
            folder = fullfile(pc.saveRoot, pc.dataStore, pc.subject, pc.dateStr, '2P', 'Exploratory', sprintf('site%03d', pc.siteNum));
            PrairieControl.mkdirRecursive(folder);
            
            assert(~any(isspace(folder)), 'Folder cannot have spaces');
            cmd = sprintf('-SetSavePath %s', folder);
            pc.sendPrairieCommand(cmd);
            
            file = sprintf('SingleImage_%s', dateStrNoHyphen);
            assert(~any(isspace(file)), 'File cannot have spaces');
            cmd = sprintf('-SetFileName Singlescan %s', file);
            pc.sendPrairieCommand(cmd);
            
            file = sprintf('Tseries_%s', dateStrNoHyphen);
            assert(~any(isspace(file)), 'File cannot have spaces');
            cmd = sprintf('-SetFileName Tseries %s', file);
            pc.sendPrairieCommand(cmd);
            
            file = sprintf('Zseries_%s', dateStrNoHyphen);
            assert(~any(isspace(file)), 'File cannot have spaces');
            cmd = sprintf('-SetFileName Zseries %s', file);
            pc.sendPrairieCommand(cmd);
            
            pc.mode = 'exploratory';
            
            if pc.hasGui
                pc.updateGuiTaskInfo();
            end
        end
        
        function [leaf, base, counter] = queryImageFileName(pc)
            pre = pc.pl.GetState('directory', 'Tseries');
            counter = str2double(pc.pl.GetState('fileIteration', 'Tseries'));
            leaf = sprintf('%s-%03d', pre, counter);
            if nargout > 1
                base = pc.pl.GetState('directory', 'Base');
            end
        end
        
        function info = queryMicroscopeState(pc)
            [info.saveLeaf, info.saveBase] = pc.queryImageFileName();
            info.objective = pc.pl.GetState('objectiveLens');
            info.objectiveMag = str2double(pc.pl.GetState('objectiveLensMag'));
            info.objectiveNA = str2double(pc.pl.GetState('objectiveLensNA'));
            info.orbitalPitch = str2double(pc.pl.GetState('objectiveLensPitchAngle'));
            info.orbitalYaw = str2double(pc.pl.GetState('objectiveLensYawAngle'));
            info.scopeX = pc.pl.GetMotorPosition('x');
            info.scopeY = pc.pl.GetMotorPosition('y');
            info.scopeZ = pc.pl.GetMotorPosition('z');
            info.pmtGainGaAsP1 = str2double(pc.pl.GetState('pmtGain', 'PMT orb red')); % these names must match the names in the gui as set in the config
            info.pmtGainGaAsP2 = str2double(pc.pl.GetState('pmtGain', 'PMT orb grn'));
            info.pmtGainLightGuide = str2double(pc.pl.GetState('pmtGain', 'PMT LG'));
            info.pockels = str2double(pc.pl.GetState('laserPower', 'Pockels1'));
            info.pixelSizeX = str2double(pc.pl.GetState('micronsPerPixel', 'XAxis'));
            info.pixelSizeY = str2double(pc.pl.GetState('micronsPerPixel', 'YAxis'));
            info.dwellTime = str2double(pc.pl.GetState('dwellTime'));
            info.pixelsX = str2double(pc.pl.GetState('pixelsPerLine'));
            info.pixelsY = str2double(pc.pl.GetState('linesPerFrame'));
            info.frameRate = str2double(pc.pl.GetState('frameRate'));
            
            galvoModeStr = pc.pl.GetState('activeMode');
            switch lower(galvoModeStr)
                case 'galvo'
                    info.galvoMode = GalvoMode.Galvo;
                case 'spiral'
                    info.galvoMode = GalvoMode.Spiral;
                case 'resonant galvo'
                    info.galvoMode = GalvoMode.Resonant;
                otherwise
                    warning('Unknown galvo mode %s', galvoModeStr);
                    info.galvoMode = GalvoMode.Galvo;
            end
                    
            info.laserPockels = str2double(pc.pl.GetState('laserPower', 'Pockels')); % requires this field to be labeled Pockels in bruker config
            info.laserWavelength = str2double(pc.pl.GetState('laserWavelength', 'Excitation 1')); % requires this field to be labeled
            
            pc.scopeInfo = info;
            
            pc.updateGuiScopeInfo();
        end
        
        function startTseries(pc)
            pc.isImaging = true;
            pc.sendPrairieCommandViaShell('-ts');
        end
        
        function liveScan(pc)
            pc.isImaging = true;
            pc.sendPrairieCommandViaShell('-lv');
        end
        
        function stopImaging(pc)
            pc.isImaging = false;
            pc.sendPrairieCommandViaShell('-stop');
        end
    end

    % Gui
    methods
       % Create the UI if one does not already exist.
       function launchGui(pc)
            % Bring the UI to the front if one does already exist.
            hf = findall(0,'Tag',pc.guiTag);
            if ~isempty(hf), delete(hf); hf = []; end;
            if isempty(hf)
                % Create a UI
                hf = pc.createGui();
            else
                % Bring it to the front
                figure(hf);
            end
            
            pc.hfig = hf;
       end   
       
       function tf = hasGui(pc)
           tf = ~isempty(pc.hfig) && isvalid(pc.hfig);
       end
    end
    
    % Live image display
    methods
        function sz = getImageMatrixSize(pc)
            if isempty(pc.scopeInfo)
                pc.queryMicroscopeState();
            end
            sz = [pc.scopeInfo.pixelsY, pc.scopeInfo.pixelsX];
        end
        
        function img = getImage(pc)
            if isempty(pc.scopeInfo)
                pc.queryMicroscopeState();
            end
            ch = pc.chDisplay;
            x = pc.scopeInfo.pixelsX;
            y = pc.scopeInfo.pixelsY;
            img = pc.pl.GetImage_2(ch, y, x); % dimensions follow matrix conventions here
        end
        
        function updateImage(pc, img)
            if pc.hasGui
                 img = mat2gray(img);
                 x = (0:pc.scopeInfo.pixelsX-1) * pc.scopeInfo.pixelSizeX;
                 y = (0:pc.scopeInfo.pixelsY-1) * pc.scopeInfo.pixelSizeY;
                 set(pc.axLiveImage, 'XLim', [0 max(x)], 'YLim', [0 max(y)]);
                 set(pc.axLiveImage, 'DataAspectRatio', [1 1 1]);
                 set(pc.hLiveImage, 'CData', img, 'XData', x, 'YData', y);
            end
        end
        
        function setLiveDisplayAverageFrames(pc, n)
            assert(isnumeric(n) && isscalar(n) && n > 0);
            pc.liveDisplayAverageFrames = n;
        end
        
        function startLiveDisplay(pc)
            % For this example all events call into the same function
            if ~isempty(pc.simulinkEventListener) && isvalid(pcsimulinkEventListener)
                delete(pc.simulinkEventListener);
            end
            pc.simulinkEventListener = add_exec_event_listener('LiveDisplay/GetImage',...
                    'PostOutputs', @localEventListener);
                
            function localEventListener(block, eventdata)
                sTime = block.CurrentTime;
                avgImage = block.OutputPort(1).Data;
                
            end
        end
% invalid = block.OutputPort(2).Data;

% old version with timers
%         function startLiveDisplay(pc)
%             if isempty(pc.scopeInfo)
%                 pc.queryMicroscopeState();
%             end
%             pc.liveDisplayActive = true; 
%             
%             pc.liveDisplaySystem = ImageRunningAverageSystem();
%             pc.liveDisplaySystem.nFrames = pc.liveDisplayAverageFrames;
%                 
%             timerRecv = timer;
%             timerRecv.TimerFcn = @timerFnRecv;
%             delta = 1 / pc.scopeInfo.frameRate;
%             timerRecv.Period = round(delta, 3);
%             timerRecv.ExecutionMode = 'fixedRate';
%             timerRecv.StartDelay = 0.5;
%             start(timerRecv);
%             
% %             while pc.liveDisplayActive
% %                 avg = pc.liveDisplaySystem.computeAverageImage();
% %                 pc.updateImage(avg);
% %                 pc.liveDisplayUpdateRate = 1 / timerRecv.InstantPeriod;
% %                 pc.updateGuiLiveDisplayInfo();
% %                 
% %                 pause(0.2);
% %             end
%             
%             timerUpdate = timer;
%             timerUpdate.TimerFcn = @timerFnUpdate;
%             timerUpdate.Period = 0.5;
%             timerUpdate.ExecutionMode = 'fixedSpacing';
%             timerUpdate.StartDelay = 0.5;
%             start(timerUpdate);
%    
%             function timerFnRecv(tobj, event)
%                 if ~pc.liveDisplayActive
%                     disp('Stopping Receive');
%                     stop(tobj);
%                     if isvalid(tobj)
%                         delete(tobj);
%                     end
%                     return;
%                 end
%                 
%                 if pc.liveDisplaySystem.nFrames ~= pc.liveDisplayAverageFrames
%                     pc.liveDisplaySystem.nFrames = pc.liveDisplayAverageFrames;
%                 end
%                 image = pc.getImage();
%                 pc.liveDisplaySystem.step(image);
%                 pause(0.001);
%             end
%             
%             function timerFnUpdate(tobj, event)
%                 if ~pc.liveDisplayActive
%                     disp('Stopping update');
%                     stop(tobj);
%                     if isvalid(tobj)
%                         delete(tobj);
%                     end
%                     return;
%                 end
%                 tic;
%                 avg = pc.liveDisplaySystem.computeAverageImage();
%                 pc.updateImage(avg);
% %                 pc.liveDisplayUpdateRate = 1 / timerRecv.InstantPeriod;
% %                 pc.updateGuiLiveDisplayInfo();
%                 toc
%                 drawnow;
%                 pause(0.1);
%             end
%         end
%         
%         function stopLiveDisplay(pc)
%             pc.liveDisplayActive = false;
%         end 
        
        function updateGuiLiveDisplayInfo(pc)
            if pc.hasGui
                pc.handles.tblScopeInfo.Data = {...
                    'Update Rate (Hz)', sprintf('%.2f', pc.liveDisplayUpdateRate); ...
                    'Frames averaged', pc.liveDisplayAverageFrames};
            end
        end
        
        
    end
    
    
    
    % internal Gui
    methods(Access=protected)
        function hf = createGui(pc)
            % Open a new figure hfig and remove the toolbar and menus
            hf = figure('Tag', pc.guiTag, ...
            'Name', sprintf('Prairie Control'), ...
            'MenuBar', 'none', ...
            'Toolbar', 'none', ...
            'NumberTitle', 'off', ...
            'IntegerHandle', 'off', ...
            'HandleVisibility','callback',...
            'Visible','off', ...
            'Resize', 'off', ...
            'Position', [200 200 1050 750], ...
            'Units', 'normalized'); % left bottom width height

            set(hf, 'DefaultUicontrolFontSize', 10);
            set(hf, 'DefaultUicontrolFontName', 'Segoe UI');
            set(hf, 'DefaultAxesFontName', 'Segoe UI');

            vColumns = uix.HBoxFlex('Parent', hf, 'Spacing', 3);

            %%%%
            % Right column
            %%%%

            vRight = uix.VBox('Parent', vColumns);
                p = uix.BoxPanel( 'Parent', vRight, 'Title', 'Running Average', 'BackgroundColor', 'k');
                    bp = uix.HBox('Parent', p);
                    uicontrol( 'Parent', bp, 'BackgroundColor', 'k', 'ForeGroundColor', 'w', ...
                        'String', 'Start', 'Callback', @(varargin) pc.startLiveDisplay);
                    uicontrol( 'Parent', bp, 'BackgroundColor', 'k', 'ForeGroundColor', 'w', ...
                        'String', 'Stop', 'Callback', @(varargin) pc.stopLiveDisplay);
                    
                p = uix.BoxPanel( 'Parent', vRight, 'Title', '2P Image', 'BackgroundColor', 'k');
                
                ax = axes('Parent', p, 'tag', 'axLiveImage', 'Position', [0 0 1 1]);
                colormap(ax, gray);
                pc.hLiveImage = image(zeros(512, 512), 'CDataMapping', 'scaled', 'Parent', ax);
                ax.XTick = [];
                ax.YTick = [];
                ax.CLim = [0 1];
                ax.LooseInset = [0 0 0 0];
                ax.DataAspectRatio = [1 1 1];
                ax.Color = 'k';
                ax.Visible = 'off';
                ax.Color
                pc.axLiveImage = ax;
                
            vRight.Heights = [50 -1];
                
            %%%%
            % Left column
            %%%%

            vLeft = uix.VBox('Parent', vColumns);
                vbox = uix.VBox( 'Parent', vLeft);
                    bp = uix.HBox('Parent', vbox);
%                             uicontrol( 'Parent', bp, 'Style', 'text', ...
%                                 'String', 'Task Info', 'Tag', 'txtTaskInfo'); 

                        vbox2 = uix.VBox( 'Parent', bp);
                            p = uix.BoxPanel( 'Parent', vbox2, 'Title', 'Scope Info');
                            ht = uitable(p, 'Tag', 'tblScopeInfo');
                            ht.ColumnName = [];
                            ht.RowName = [];
                            ht.ColumnEditable = false;
                            ht.ColumnWidth = {130 170};
                            ht.ColumnFormat = {'char', 'char'};
                            
                            p = uix.BoxPanel( 'Parent', vbox2, 'Title', 'Live Display Info');
                            ht = uitable(p, 'Tag', 'tblLiveDisplayInfo');
                            ht.ColumnName = [];
                            ht.RowName = [];
                            ht.ColumnEditable = false;
                            ht.ColumnWidth = {130 170};
                            ht.ColumnFormat = {'char', 'char'};
                            
                            vbox2.Heights = [250 -1];

                        p = uix.BoxPanel( 'Parent', bp, 'Title', 'Process Task Info');
                        ht = uitable(p, 'Tag', 'tblTaskInfo');
                        ht.ColumnName = [];
                        ht.RowName = [];
                        ht.ColumnEditable = false;
                        ht.ColumnWidth = {80 100};
                        ht.ColumnFormat = {'char', 'char'};

                        bp.Widths = [200 320];

                    bp = uix.HBox('Parent', vbox);
                        uicontrol( 'Parent', bp, ...
                            'String', 'Set Xavier Exploratory', 'Callback', @(varargin) pc.setTaskInfoXavierExploratory);
                    bp = uix.HBox('Parent', vbox);
                        uicontrol( 'Parent', bp, ...
                            'String', 'Set Xavier CenterOutReach', 'Callback', @(varargin) pc.setTaskInfoXavierCenterOutReach);
                    bp = uix.HBox('Parent', vbox);
                        uicontrol( 'Parent', bp, ...
                            'String', 'Receive Task Info from SLRT', 'Callback', @(varargin) pc.receiveAndProcessUdpCommands);     
                    bp = uix.HBox('Parent', vbox);
                        uicontrol( 'Parent', bp, ...
                            'String', 'New Site', 'Callback', @(varargin) pc.incrementSiteNum);
                        uicontrol( 'Parent', bp, ...
                            'String', 'Set Site Num', 'Callback', @(varargin) pc.setSiteNumInteractive);
                vbox.Heights = [420 30 30 30 30];

                p = uix.BoxPanel( 'Parent', vLeft, 'Title', 'Live Imaging');
                    vbox = uix.VBox( 'Parent', p);
                        bp = uix.HBox('Parent', vbox);
                            uicontrol( 'Parent', bp, ...
                                'String', 'Start Live', 'Callback', @(varargin) pc.liveScan);
                            uicontrol( 'Parent', bp, ...
                                'String', 'Stop Imaging', 'Callback', @(varargin) pc.stopImaging);
                            
                p = uix.BoxPanel( 'Parent', vLeft, 'Title', 'T-Series Imaging');
                    vbox = uix.VBox( 'Parent', p);
                        bp = uix.HBox('Parent', vbox);
                            uicontrol( 'Parent', bp, ...
                                'String', 'Start T-series', 'Callback', @(varargin) pc.startTseries);
                            uicontrol( 'Parent', bp, ...
                                'String', 'Stop Imaging', 'Callback', @(varargin) pc.stopImaging);

                p = uix.BoxPanel( 'Parent', vLeft, 'Title', 'Monitoring Log');
                uicontrol('Parent', p, ...
                    'Tag', 'textLog', ...
                    'Style', 'listbox', ...
                    'Max', 2, ...
                    'FontName', 'Source Code Pro', ...
                    'HorizontalAlignment', 'left', ...
                    'Enable', 'on', ...
                    'BackgroundColor', 'w');

            vLeft.Heights = [550 50 50 100];
            
            %%%
            vColumns.Widths = [520 520];

            % Create the handles structure
            pc.handles = guihandles(hf);
            
            % Position the UI in the centre of the screen
            movegui(hf,'center')
            % Make the UI visible
            set(hf,'Visible','on');
            
            pc.axLiveImage.Visible = 'off';
        end

        function logError(pc, varargin)
            if ~pc.hasGui, return, end
            timeString = datestr(now, 'HH:MM:YY.FFF');
            fstr = sprintf(varargin{:});
            str = [timeString ' : ' 'ERROR : ' fstr];
            pc.addStringToLogBox(str);
        end

        function log(pc, varargin)
        if ~pc.hasGui, return, end
            timeString = datestr(now, 'HH:MM:YY.FFF');
            fstr = sprintf(varargin{:});
            str = [timeString ' : ' fstr];
            pc.addStringToLogBox(str);
        end

        function addStringToLogBox(pc, str)
            if ~pc.hasGui, return, end
            pc.handles.textLog.String = cat(1, pc.handles.textLog.String, {str});
            pc.handles.textLog.Value = numel(pc.handles.textLog.String);
        end
                
        function setTaskInfoXavierExploratory(pc) 
            pc.subject = 'Xavier';
            pc.dateStr = datestr(now, 'yyyy-mm-dd');
            pc.protocol = 'Exploratory';
            pc.dataStore = 'rig1';
%             pc.setFileLocationTask();
            pc.setFileLocationExploratory();
            pc.sendMicroscopeStateBus();
        end

        function setTaskInfoXavierCenterOutReach(pc) 
            pc.subject = 'Xavier';
            pc.dateStr = datestr(now, 'yyyy-mm-dd');
            pc.protocol = 'CenterOutReach';
            pc.dataStore = 'rig1';
            pc.setFileLocationTask();
            pc.sendMicroscopeStateBus();
        end

        function updateGuiTaskInfo(pc)
            if pc.hasGui
                pc.handles.tblTaskInfo.Data = {'Subject', pc.subject; ...
                    'Date', pc.dateStr; ...
                    'Task', pc.protocol; ...
                    'Data Store', pc.dataStore; ...
                    'Site Number', pc.siteNum};
            end
        end
        
        function updateGuiScopeInfo(pc)
            if pc.hasGui
                info = pc.scopeInfo;
                pc.handles.tblScopeInfo.Data = {...
                    'Objective', sprintf('%s %.2f NA', info.objective, info.objectiveNA); ...
                    'Image Size (pixels)', sprintf('%d x %d', info.pixelsX, info.pixelsY); ...
                    'Field of View (um)', sprintf('%.0f x %0.0f', info.pixelsX * info.pixelSizeX, info.pixelsX * info.pixelSizeX); ... 
                    'Galvo Mode', char(info.galvoMode); ...
                    'Frame Rate (Hz)', info.frameRate; ...
                    'Orbital (deg)', sprintf('%.1f Pitch, %.1f Yaw', info.orbitalPitch, info.orbitalYaw); ...
                    'Scope Location (um)', sprintf('X = %.0f, Y = %0.f, Z = %0.f', info.scopeX, info.scopeY, info.scopeZ); ...
                    'Laser Wavelength (nm)', info.laserWavelength; ...
                    'Dwell Time (us)', info.dwellTime; ...
                    'Red GaAsP PMT', info.pmtGainGaAsP1; ...
                    'Green GaAsP PMT', info.pmtGainGaAsP2; ...
                    'Pockels Voltage', info.pockels ...
                    };
            end
        end

        function setSiteNumInteractive(pc)
            str = inputdlg('Enter site number',...
                     'mOEG Site Number', [1 40]);
            if ~isempty(str)
                num = str2double(str{:}); 
                pc.setSiteNum(num);
            end
        end

    end

    methods(Static)
        function print(varargin)
            fprintf('PrairieControl: ');
            fprintf(varargin{:});
        end
            
        function mkdirRecursive(dirPath)
            % like mkdir -p : creates intermediate directories as required
            if exist(dirPath, 'dir')
                if nargin >= 2 && cdTo
                    cd(dirPath);
                end
                return;
            else
                parent = fileparts(dirPath);
                if ~isempty(parent)
                    PrairieControl.mkdirRecursive(parent);
                end
                mkdir(dirPath);
            end
        end
    end
end