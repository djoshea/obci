function varargout = launchGUI
% This file was inspired by code by Phil Goddard (phil@goddardconsulting.ca)

modelName = 'taskGUIModel';
[taskName, taskVersion] = getTaskInfoFromPath(mfilename('fullpath'));
crc = CenterOutReachControl.getInstance();

% Do some simple error checking on the input
if ~localValidateInputs(modelName)
    estr = sprintf('The model %s.mdl cannot be found.',modelName);
    errordlg(estr,'Model not found error','modal');
    return;
end

% Create the UI if one does not already exist.
% Bring the UI to the front if one does already exist.
hf = findall(0,'Tag',mfilename);
if ~isempty(hf), delete(hf); hf = []; end;
if isempty(hf)
    % Create a UI
    hf = localCreateUI(modelName, taskName, taskVersion);
else
    % Bring it to the front
    figure(hf);
end

% populate the output if required
if nargout > 0
    varargout{1} = hf;
end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to create the user interface
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function hf = localCreateUI(modelName, taskName, taskVersion)

    % Open a new figure hfig and remove the toolbar and menus
    hf = figure('Tag', mfilename, ...
    'Name', sprintf('%s Control v%d', taskName, taskVersion), ...
    'MenuBar', 'none', ...
    'Toolbar', 'none', ...
    'NumberTitle', 'off', ...
    'IntegerHandle', 'off', ...
    'HandleVisibility','callback',...
    'CloseRequestFcn',@localCloseRequestFcn,...
    'Visible','off', ...
    'Position', [200 200 1200 700], ...
    'Units', 'normalized'); % left bottom width height

    set(hf, 'DefaultUicontrolFontSize', 10);
    set(hf, 'DefaultUicontrolFontName', 'Segoe UI');
    set(hf, 'DefaultAxesFontName', 'Segoe UI');

    vColumns = uix.HBoxFlex('Parent', hf, 'Spacing', 3);

    % Model control
    vLeft = uix.VBox('Parent', vColumns);

        p = uix.BoxPanel( 'Parent', vLeft, 'Title', 'Model Control');
            vbox = uix.VBox( 'Parent', p);
                bp = uix.HBox('Parent', vbox);
                    % set( vbox, 'ButtonSize', [180 35], 'Spacing', 5 );
                    uicontrol( 'Parent', bp, ...
                        'String', 'Download', 'Callback', @modelDownloadPressed);
                    uicontrol( 'Parent', bp, ...
                        'String', 'Start', 'Callback', @modelStartPressed);
                    uicontrol( 'Parent', bp, ...
                        'String', 'Stop', 'Callback', @modelStopPressed);
                    
        p = uix.BoxPanel( 'Parent', vLeft, 'Title', 'Monkey Settings');
            vbox = uix.VBox( 'Parent', p);
                bp = uix.HBox('Parent', vbox);
                    % set( vbox, 'ButtonSize', [180 35], 'Spacing', 5 );
                    uicontrol( 'Parent', bp, ...
                        'String', 'Xavier', 'Callback', @setXavierTraining);
                bp = uix.HBox('Parent', vbox);
                    uicontrol( 'Parent', bp, ...
                        'String', 'Test', 'Callback', @setTesting);
                    
                bp = uix.HBox('Parent', vbox);
                    uicontrol( 'Parent', bp, ...
                        'String', 'Decode Test', 'Callback', @setImageDecodeTesting);

        p = uix.BoxPanel( 'Parent', vLeft, 'Title', 'Monitoring Control');
            vbox = uix.VBox( 'Parent', p);
                bp = uix.HBox('Parent', vbox);
                    uicontrol( 'Parent', bp, 'Tag', 'startpb', ...
                        'String', 'Start', 'Callback', @localStartPressed);
                    uicontrol( 'Parent', bp, 'Tag', 'stoppb', 'Enable', 'off', ...
                        'String', 'Stop', 'Callback', @localStopPressed);

        p = uix.BoxPanel('Parent', vLeft, 'Title', 'Task Control');
            vbox = uix.VBox( 'Parent', p);
            bp = uix.HBox('Parent', vbox);
                uicontrol( 'Parent', bp, ...
                    'String', 'Run Task', 'Callback', @runTask);
                uicontrol( 'Parent', bp, ...
                    'String', 'Pause Task', 'Callback', @pauseTask);

        p = uix.BoxPanel( 'Parent', vLeft, 'Title', 'Task Manual');
            vbox = uix.VBox( 'Parent', p);
                bp = uix.HBox('Parent', vbox);
                    % set( vbox, 'ButtonSize', [180 35], 'Spacing', 5 );
                    uicontrol( 'Parent', bp, ...
                        'String', 'Give Juice', 'Callback', @giveFreeJuice);
                    uicontrol( 'Parent', bp, ...
                        'String', 'Set Juice', 'Callback', @(varargin) setJuiceInteractive);
   
        p = uix.BoxPanel( 'Parent', vLeft, 'Title', 'Purgatory Info');
            vbox = uix.VBox( 'Parent', p);

            bp = uix.HBox('Parent', vbox);
            uicontrol( 'Parent', bp, ...
                'String', 'Auto Timeout', 'Callback', @autoTimeoutActive);
            uicontrol( 'Parent', bp, ...
                'String', 'No Timeouts', 'Callback', @noAutoTimeout);

            bp = uix.HBox('Parent', vbox);
            uicontrol('Parent', bp, ...
                'Style', 'text', 'String', 'No Starts:');
            uicontrol('Parent', bp, 'Tag', 'txtNoStartsConsecutive', ...
                'Style', 'text', 'String', '');
            
            bp = uix.HBox('Parent', vbox);
            uicontrol('Parent', bp, ...
                'Style', 'text', 'String', 'Timeout Remaining:');
            uicontrol('Parent', bp, 'Tag', 'txtTimePurgatory', ...
                'Style', 'text', 'String', '');

            uicontrol('Parent', vbox, ...
                'String', 'End Timeout', 'Callback', @endTimeout);
            
            
        p = uix.BoxPanel( 'Parent', vLeft, 'Title', 'Image Decoder');
            vbox = uix. VBox( 'Parent', p);
                bp = uix.HBox('Parent', vbox);
                    % set( vbox, 'ButtonSize', [180 35], 'Spacing', 5 );
                    uicontrol( 'Parent', bp, ...
                        'String', 'Reset Decoder', 'Callback', @resetImageDecoder);
                bp = uix.HBox('Parent', vbox);
                    % set( vbox, 'ButtonSize', [180 35], 'Spacing', 5 );
                    uicontrol( 'Parent', bp, ...
                        'String', 'Set decode cond.', 'Callback', @(varargin) setDecodeConditions);
                bp = uix.HBox('Parent', vbox);
                    % set( vbox, 'ButtonSize', [180 35], 'Spacing', 5 );
                    uicontrol( 'Parent', bp, ...
                        'String', 'Set training', 'Callback', @(varargin) setTraining);
                bp = uix.HBox('Parent', vbox);
                    % set( vbox, 'ButtonSize', [180 35], 'Spacing', 5 );
                    uicontrol( 'Parent', bp, ...
                        'String', 'Set decode', 'Callback', @(varargin) setDecode);
                    
                bp = uix.HBox('Parent', vbox);
                    uicontrol('Parent', bp, ...
                        'Style', 'text', 'String', 'Classifier Mode:');
                    uicontrol('Parent', bp, 'Tag', 'txtClassifierMode', ...
                        'Style', 'text', 'String', '');

                bp = uix.HBox('Parent', vbox);
                    uicontrol('Parent', bp, ...
                        'Style', 'text', 'String', 'Decode Cond.: ');
                    uicontrol('Parent', bp, 'Tag', 'txtDecodeCond', ...
                        'Style', 'text', 'String', '');
                
                
                  
                    
                    
    vLeft.Heights = [80 80 60 100 60 150 150];
   
    % Middle Column
    
    vCol = uix.VBox('Parent', vColumns);
    vbox = uix.VBox('Parent', vCol, 'BackgroundColor', 'w');
    
    p =  uix.BoxPanel( 'Parent', vbox, 'Title', 'Hand Position XY', 'BackgroundColor', 'w');
    axes( 'Parent', p, ...
        'Tag', 'axHandXY', ...
        'Color', 'w', ...
        'ActivePositionProperty', 'OuterPosition');
    p =  uix.BoxPanel( 'Parent', vbox, 'Title', 'Hand Position ZY', 'BackgroundColor', 'w');
    axes( 'Parent', p, ...
        'Tag', 'axHandZY', ...
        'Color', 'w', ...
        'ActivePositionProperty', 'OuterPosition');
    
    vbox.Heights = [350 350];
    
    %%%%
    % Right column
    %%%%
    
    vRight = uix.VBox('Parent', vColumns);
    
    p = uix.BoxPanel( 'Parent', vRight, 'Title', 'Monitoring Log');
    uicontrol('Parent', p, ...
        'Tag', 'textLog', ...
        'Style', 'listbox', ...
        'Max', 2, ...
        'FontName', 'Source Code Pro', ...
        'HorizontalAlignment', 'left', ...
        'Enable', 'on', ...
        'BackgroundColor', 'w');
    
    vColumns.Widths = [250 400 -1];
    
    % Load the simulink model
    ad = localLoadModel(modelName);

    % Create the handles structure
    ad.handles = guihandles(hf);
    % Save the application data
    guidata(hf,ad);

    % Position the UI in the centre of the screen
    movegui(hf,'center')
    % Make the UI visible
    set(hf,'Visible','on');
    
    initDataUpdate();
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to ensure that the model actually exists
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function modelExists = localValidateInputs(modelName)

num = exist(modelName,'file');
if num == 4
    modelExists = true;
else
    modelExists = false;
end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Callback Function for Start button
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function localStartPressed(hObject,eventdata)

localStopPressed(hObject, eventdata);

% get the application data
ad = getGuiData();

% Load the model if required (it may have been closed manually).
if ~modelIsLoaded(ad.modelName)
    load_system(ad.modelName);
end

% toggle the buttons
% Turn off the Start button
set(ad.handles.startpb,'Enable','off');
% Turn on the Stop button
set(ad.handles.stoppb,'Enable','on');

% set the stop time to inf
set_param(ad.modelName,'StopTime','inf');
% set the simulation mode to normal
set_param(ad.modelName,'SimulationMode','normal');

% update the diagram
set_param(ad.modelName, 'SimulationCommand', 'update');

% Set a listener on the Gain block in the model's StartFcn
set_param(ad.modelName,'StartFcn','localAddEventListener');
% start the model
set_param(ad.modelName,'SimulationCommand','start');

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Callback Function for Stop button
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function localStopPressed(hObject,eventdata)

% get the application data
ad = getGuiData();

% stop the model
set_param(ad.modelName,'SimulationCommand','stop');

% toggle the buttons
% Turn on the Start button
set(ad.handles.startpb,'Enable','on');
% Turn off the Stop button
set(ad.handles.stoppb,'Enable','off');

% Remove the listener on the Gain block in the model's StartFcn
localRemoveEventListener;

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Callback Function for deleting the UI
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function localCloseRequestFcn(hObject,eventdata) 

try
    % get the application data
    ad = guidata(hObject);

    % Can only close the UI if the model has been stopped
    % Can only stop the model is it hasn't already been unloaded (perhaps
    % manually).
    if modelIsLoaded(ad.modelName)
        switch get_param(ad.modelName,'SimulationStatus');
            case 'stopped'
            otherwise
                localStopPressed(hObject);
        end
    end
catch
end

% destroy the window
delete(gcbo);

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Callback Function for adding an event listener to the gain block
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function localAddEventListener() %#ok<DEFNU>

% get the application data
ad = getGuiData();

% Add the listener(s)
% For this example all events call into the same function
ad.eventHandle = cell(1,length(ad.viewing));
for idx = 1:length(ad.viewing)
    ad.eventHandle{idx} = ...
        add_exec_event_listener(ad.viewing(idx).blockName,...
        ad.viewing(idx).blockEvent, ad.viewing(idx).blockFcn);
end

% store the changed app data
updateGuiData(ad);

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Callback Function for executing the event listener on the gain block
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function localEventListener(block, eventdata)

% get the application data
hf = findall(0,'tag',mfilename);
ad = guidata(hf);

sTime = block.CurrentTime;
rawData = block.OutputPort(1).Data;
% invalid = block.OutputPort(2).Data;

try
    [toHostBus, valid] = deserializeBusForMatlab_ToHostBus(rawData);
    invalid = ~valid;
catch
%     warning('Error deserializing ToHostBus');
    invalid = true;
end

if invalid
    logError('Received invalid data from target');
else
    processDataUpdate(toHostBus);
end
%drawnow;

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Callback Function for removing the event listener from the gain block
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function localRemoveEventListener

% get the application data
ad = getGuiData();

% delete the listener(s)
if isfield(ad, 'eventHandle')
    for idx = 1:length(ad.eventHandle)
        if ishandle(ad.eventHandle{idx})
            delete(ad.eventHandle{idx});
        end
    end
    % remove this field from the app data structure
    ad = rmfield(ad,'eventHandle');
end
   
%save the changes
updateGuiData(ad);

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to check that model is still loaded
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function modelLoaded = modelIsLoaded(modelName)
try
    modelLoaded = ...
        ~isempty(find_system('Type','block_diagram','Name',modelName));
catch ME %#ok
    % Return false if the model can't be found
    modelLoaded = false;
end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to load model and get certain of its parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ad = localLoadModel(modelName)

% Load the simulink model
if ~modelIsLoaded(modelName)
    load_system(modelName);
end

ad.modelName = modelName;

% list the listeners that need to be added
ad.viewing(1).blockName = sprintf('%s/Raw From Target',ad.modelName);
ad.viewing(1).blockHandle = get_param(ad.viewing(1).blockName,'Handle');
ad.viewing(1).blockEvent = 'PostOutputs';
ad.viewing(1).blockFcn = @localEventListener;

end

function modelStopPressed(hObject,eventdata)  %#ok<*INUSD>
    log('Stopping model on target');
    crc = CenterOutReachControl.getInstance();
    crc.stop();
end

function modelStartPressed(hObject,eventdata) 
    log('Starting model on target');
    crc = CenterOutReachControl.getInstance();
    crc.start();
end

function modelDownloadPressed(hObject,eventdata) 
    log('Downloading model to target');
    crc = CenterOutReachControl.getInstance();
    crc.download();
end

function runTask(hObject,eventdata) 
    log('Run task');
    crc = CenterOutReachControl.getInstance();
    crc.runTask();
end

function pauseTask(hObject,eventdata) 
    log('Pause task');
    crc = CenterOutReachControl.getInstance();
    crc.pauseTask();
end

function autoTimeoutActive(hObject,eventdata) 
    log('Auto timeouts active');
    crc = CenterOutReachControl.getInstance();
    crc.autoTimeoutActive();
end

function endTimeout(hObject,eventdata) 
    log('Ending current timeout');
    crc = CenterOutReachControl.getInstance();
    crc.endTimeout();
end

function noAutoTimeout(hObject,eventdata)
    log('Disabling auto timeouts');
    crc = CenterOutReachControl.getInstance();
    crc.noAutoTimeout();
end

function giveFreeJuice(hObject,eventdata) 
    log('Giving drop of juice');
    crc = CenterOutReachControl.getInstance();
    crc.giveFreeJuice();
end

% EMT 2017-07-05
function resetImageDecoder(hObject,eventdata) 
    log('Reseting Image Decoder');
    crc = CenterOutReachControl.getInstance();
    crc.resetImageDecoder();
end



function hf = getFigure()
    hf = findall(0,'tag',mfilename);
end

function ad = getGuiData()
    hf = findall(0,'tag',mfilename);
    ad = guidata(hf);
end

function updateGuiData(ad)
    hf = getFigure();
    guidata(hf, ad);
end
    
function logError(varargin)
    timeString = datestr(now, 'HH:MM:YY.FFF');
    fstr = sprintf(varargin{:});
    str = [timeString ' : ' 'ERROR : ' fstr];
    addStringToLogBox(str);
end
    
function log(varargin)
    timeString = datestr(now, 'HH:MM:YY.FFF');
    fstr = sprintf(varargin{:});
    str = [timeString ' : ' fstr];
    addStringToLogBox(str);
end

function addStringToLogBox(str)
    ad = getGuiData();
    ad.handles.textLog.String = cat(1, ad.handles.textLog.String, {str});
    ad.handles.textLog.Value = numel(ad.handles.textLog.String);
    %drawnow;
    %pause(0.001);
end

function initDataUpdate()
    ad = getGuiData();
    
    ad.handBuffer = TimeseriesBuffer('signalNames', {'x', 'y', 'z'});
    
    % setup XY axis
    ax = ad.handles.axHandXY;
    ad.plotXY.handTrace = plot(NaN, NaN, 'Parent', ax, 'Color', 'k');
    hold(ax, 'on');
    ad.plotXY.handCurrent = plot(NaN, NaN, 'Parent', ax, 'MarkerFaceColor', 'k', 'MarkerEdgeColor', 'none', 'Marker', 'o', 'MarkerSize', 10);
    ad.plotXY.centerPatch = patch(NaN, NaN, [1 0 0], 'EdgeColor', 'none', 'Parent', ax, 'FaceAlpha', 0.4);
    ad.plotXY.targetPatch = patch(NaN, NaN, [0 0 1], 'EdgeColor', 'none', 'Parent', ax, 'FaceAlpha', 0.4);
    
    ad.plotXY.centerHoldPatch = patch(NaN, NaN, [0 0 0], 'FaceColor', 'none', 'EdgeColor', 'r', 'LineWidth', 2, 'Parent', ax, 'FaceAlpha', 0.8);
    ad.plotXY.targetHoldPatch = patch(NaN, NaN, [0 0 0], 'FaceColor', 'none', 'EdgeColor', 'r', 'LineWidth', 2, 'Parent', ax, 'FaceAlpha', 0.8);
    
    xlabel(ax, 'handX (mm)');
    ylabel(ax, 'handY (mm)');
    
    hold(ax, 'off');
    axis(ax, 'equal');
    xlim(ax, [-200 200]);
    ylim(ax, [-200 100]);
    set(ax,'LooseInset',get(ax,'TightInset'))
    box(ax, 'off');
    ax.XLimMode = 'manual';
    ax.YLimMode = 'manual';
    
    % setup Z Y axis
    ax = ad.handles.axHandZY;
    ad.plotZY.handTrace = plot(NaN, NaN, 'Parent', ax, 'Color', 'k');
    hold(ax, 'on');
    ad.plotZY.handCurrent = plot(NaN, NaN, 'Parent', ax, 'MarkerFaceColor', 'k', 'MarkerEdgeColor', 'none', 'Marker', 'o', 'MarkerSize', 10);
    ad.plotZY.targetPatch = patch(NaN, NaN,  [0 0 1], 'EdgeColor', 'none', 'Parent', ax, 'FaceAlpha', 0.4);
    ad.plotZY.centerPatch = patch(NaN, NaN, [1 0 0], 'EdgeColor', 'none', 'Parent', ax, 'FaceAlpha', 0.4);
    
    xlabel(ax, 'handZ (mm)');
    ylabel(ax, 'handY (mm)');
    
    hold(ax, 'off');
    axis(ax, 'equal');
    set(ax,'LooseInset',get(ax,'TightInset'))
    xlim(ax, [0 100]);
    ylim(ax, [-200 100]);
    box(ax, 'off');
    ax.XLimMode = 'manual';
    ax.YLimMode = 'manual';
    
    updateGuiData(ad);
end

function processDataUpdate(data)
    ad = getGuiData();
    
    newTrial = false;
    
    if isfield(ad, 'lastData')
        if ad.lastData.trialId ~= data.trialId
            newTrial = true;
            
            % log last trial's outcome
            if ad.lastData.trialData.success
                log('Success');
            else
                log('Failure: %s', char(ad.lastData.trialData.failureCode));
%                 log('Consecutive no starts: %d', data.trialData.consecutiveNoStarts);
            end
            
            log('Trial %d', data.trialId);
        end
        
        % check for new events
        if newTrial
            ad.handBuffer.clear();
            ad.lastData.taskEventBuffer = [];
            
            theta = linspace(0, 2*pi, 100);
            set(ad.plotXY.targetPatch, ...
                'XData', data.condition.targetSize/2 * cos(theta) + data.condition.targetX, ...
                'YData', data.condition.targetSize/2 * sin(theta) + data.condition.targetY);
            
            set(ad.plotXY.centerPatch, ...
                'XData', data.param.centerSize/2 * cos(theta) + data.condition.centerX, ...
                'YData', data.param.centerSize/2 * sin(theta) + data.condition.centerY);
            
            set(ad.plotZY.targetPatch, ...
                'XData', [0 0 data.rigConfig.polarisThreshTouchingZ, data.rigConfig.polarisThreshTouchingZ], ...
                'YData', data.condition.targetY + data.condition.targetSize/2 * [-1 1 1 -1]);
            
            set(ad.plotZY.centerPatch, ...
                'XData', [0 0 data.rigConfig.polarisThreshTouchingZ, data.rigConfig.polarisThreshTouchingZ], ...
                'YData', data.condition.centerY + data.param.centerSize/2 * [-1 1 1 -1]);
        end
        if numel(ad.lastData.taskEventBuffer) < numel(data.taskEventBuffer)
%             for i = numel(ad.lastData.taskEventBuffer)+1:numel(data.taskEventBuffer)
%                 log('TaskEvent : %d ms - %s', data.taskEventTimes(i), char(data.taskEventBuffer(i)));
%             end
        end
        
        time = data.clock;
        
        % buffer the hand signals
        if data.hand.handSeen
            handVec = [data.hand.handX; data.hand.handY; data.hand.handZ];
        else
            handVec = nan(3,1);
        end
        ad.handBuffer.addSample(time, handVec);
        
        % update the hand plot
        ad.plotXY.handTrace.XData = ad.handBuffer.getTimeseriesForSignal('x');
        ad.plotXY.handTrace.YData = ad.handBuffer.getTimeseriesForSignal('y');
        
        ad.plotXY.handCurrent.XData = handVec(1);
        ad.plotXY.handCurrent.YData = handVec(2);
%         
%         data.trialData.holdXCenter = 0;
%         data.trialData.holdYCenter = 0;
%         data.trialData.holdXTarget = 50;
%         data.trialData.holdYTarget = 50;
%         data.param.centerHoldWindowSize = 20;
%         data.param.targetHoldWindowSize = 20;
%         
        sz = data.param.centerHoldWindowSize;
        xc = data.trialData.holdXCenter;
        yc = data.trialData.holdYCenter;
        ad.plotXY.centerHoldPatch.XData = [xc-sz/2, xc-sz/2, xc+sz/2, xc+sz/2];
        ad.plotXY.centerHoldPatch.YData = [yc-sz/2, yc+sz/2, yc+sz/2, yc-sz/2];
        
        sz = data.param.targetHoldWindowSize;
        xc = data.trialData.holdXTarget; 
        yc = data.trialData.holdYTarget;
        ad.plotXY.targetHoldPatch.XData = [xc-sz/2, xc-sz/2, xc+sz/2, xc+sz/2];
        ad.plotXY.targetHoldPatch.YData = [yc-sz/2, yc+sz/2, yc+sz/2, yc-sz/2];
        
        ad.plotZY.handTrace.XData = ad.handBuffer.getTimeseriesForSignal('z');
        ad.plotZY.handTrace.YData = ad.handBuffer.getTimeseriesForSignal('y');
        
        ad.plotZY.handCurrent.XData = handVec(3);
        ad.plotZY.handCurrent.YData = handVec(2);
    end
    
    ad.handles.txtTimePurgatory.String = sprintf('%d ms', data.trialData.purgatoryTimeRemaining);
    ad.handles.txtNoStartsConsecutive.String = sprintf('%d trials', data.trialData.consecutiveNoStarts);

    ad.handles.txtClassifierMode.String = sprintf('%d ms', data.trialData.purgatoryTimeRemaining);
    ad.handles.txtDecodeConditions.String = sprintf('%d trials', data.trialData.consecutiveNoStarts);
    
    ad.lastData = data;
    updateGuiData(ad);
end
    


function ledsOn(hObject,eventdata) 
    log('LEDs On');
    crc = CenterOutReachControl.getInstance();
    crc.ledsOn();
end

function ledsOff(hObject,eventdata) 
    log('LEDs Off');
    crc = CenterOutReachControl.getInstance();
    crc.ledsOff();
end

function isosbestic(hObject,eventdata) 
    log('Alternating 470/405 nm');
    crc = CenterOutReachControl.getInstance();
    crc.isosbesticMode();
end

function cw470(hObject,eventdata) 
    log('Continuous 470 nm');
    crc = CenterOutReachControl.getInstance();
    crc.cw470Mode();
end

function setXavierTraining(hObject,eventdata) 
    log('Setting task for Xavier Training; Saving Data');
    crc = CenterOutReachControl.getInstance();
    crc.setXavierTraining();
    crc.saveData();
end

function setTesting(hObject,eventdata) 
    log('Setting task for testing');
    crc = CenterOutReachControl.getInstance();
    crc.setTesting();
    crc.saveData();
end

function setImageDecodeTesting(hObject,eventdata) 
    log('Setting task for image decoder testing');
    crc = CenterOutReachControl.getInstance();
    crc.setImageDecodeTesting();
    crc.saveData();
end

function setJuiceInteractive()
    str = inputdlg('Enter juice time (ms)',...
             'Juice Time', [1 40]);
    if ~isempty(str)
        num = str2double(str{:}); 
        crc = CenterOutReachControl.getInstance();
        crc.setJuice(num);
    end
end

function setDecodeConditions()
    str = inputdlg('Enter Condition num of Class 1',...
             'Set Class 1', [1 40]);
    if ~isempty(str)
        classArray = logical(str2num(str{:})); 
        crc = CenterOutReachControl.getInstance();
        crc.setDecodeConditions(classArray);
    end
end

function setTraining()
    crc = CenterOutReachControl.getInstance();
    crc.setClassifierTraining();
end

function setDecode()
    crc = CenterOutReachControl.getInstance();    
    crc.setClassifierDecode();
end

% function setClass2Interactive()
%     str = inputdlg('Enter Condition num of Class 2',...
%              'Set Class 2', [1 40]);
%     if ~isempty(str)
%         num = str2double(str{:}); 
%         crc = CenterOutReachControl.getInstance();
%         crc.setClass2(num);
%     end
% end





