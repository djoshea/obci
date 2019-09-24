classdef (Sealed) CenterOutReachControl < handle
    
    methods(Static)
        function h = getInstance()
            % return singleton instance
            persistent hInstance;
            if isempty(hInstance) || ~isvalid(hInstance)
                hInstance = CenterOutReachControl();
            end     
            h = hInstance;
        end
    end
   
    properties(SetAccess=protected)
        taskName
        taskVersion
    end
    
    properties(SetAccess=protected) % path info
        rootDir
        rootXpcDir 
        taskDir
        workDir
    end
    
    properties(SetAccess=protected)
        hp = CenterOutReachConditionHyperparameters;
    end
    
    properties(Dependent)
        rigConfig
        taskControl
        param
        dataLoggerInfo
        nextTrialId
    end
    
    properties(Dependent, SetAccess=protected)
        conditions
        conditionRepeats
    end
    
    properties(Dependent)
        TunableRigConfig
        TunableTaskControl
        TunableParam
        TunableConditions
        TunableConditionRepeats
        TunableDataLoggerInfo
        TunableNextTrialId
    end
    
    % singleton design pattern
    methods(Access=private)
        function c = CenterOutReachControl()
            c.init();
        end
    end

    methods % Auto retrieve structs from TunableParameters
        function v = get.rigConfig(c)
            v = c.TunableRigConfig.value;
        end
        
        function set.rigConfig(c, v)
            c.TunableRigConfig.setValue(v);
        end
        
        function v = get.taskControl(c)
            v = c.TunableTaskControl.value;
        end
        
        function set.taskControl(c, v)
            c.TunableTaskControl.setValue(v);
        end
        
        function v = get.param(c)
            v = c.TunableParam.value;
        end
        
        function set.param(c, v)
            c.TunableParam.setValue(v);
        end
        
        function v = get.dataLoggerInfo(c)
            v = c.TunableDataLoggerInfo.value;
        end
        
        function set.dataLoggerInfo(c, v)
            c.TunableDataLoggerInfo.setValue(v);
        end
        
        function v = get.nextTrialId(c)
            v = c.TunableNextTrialId.value;
        end
        
        function set.nextTrialId(c, v)
            c.TunableNextTrialId.setValue(v);
        end
        
        function v = get.conditions(c)
            v = c.TunableConditions.value;
        end
        
        function set.conditions(c, v)
            c.TunableConditions.setValue(v);
        end
        
        function v = get.conditionRepeats(c)
            v = c.TunableConditionRepeats.value;
        end
        
        function set.conditionRepeats(c, v)
            c.TunableConditionRepeats.setValue(v);
        end
    end
    
    methods % Get Tunable parameter objects from base workspace automatically
        function v = get.TunableRigConfig(c)
            v = evalin('base', 'TunableRigConfig');
        end
        
        function v = get.TunableTaskControl(c)
            v = evalin('base', 'TunableTaskControl');
        end
        
        function v = get.TunableParam(c)
            v = evalin('base', 'TunableParam');
        end
        
        function v = get.TunableConditions(c)
            v = evalin('base', 'TunableConditions');
        end
        
        function v = get.TunableConditionRepeats(c)
            v = evalin('base', 'TunableConditionRepeats');
        end
        
        function v = get.TunableDataLoggerInfo(c)
            v = evalin('base', 'TunableDataLoggerInfo');
        end
        
        function v = get.TunableNextTrialId(c)
            v = evalin('base', 'TunableNextTrialId');
        end
    end
    
    % Basic Model control
    methods
        function init(c)
            % set up internal path settings
            home =char(java.lang.System.getProperty('user.home'));
            c.rootDir = fullfile(home, '\code\rig1');
            c.rootXpcDir = fullfile(c.rootDir, 'xpc');
            [c.taskName, c.taskVersion] = getTaskInfoFromPath();
            c.taskDir = fullfile(c.rootDir, 'tasks', c.taskName, ['v' num2str(c.taskVersion)]);
            c.workDir = fullfile(home, 'Work.rig1', c.taskName, ['v' num2str(c.taskVersion)]);     
            
            % addpath important directories
            c.setPath();
            
            % call task initialize
            %initialize();
            
            % assign values to internally stored parameter buses
            try
                c.resetAll();
            catch exc
                disp(exc.message());
            end 
        end
        
        function setPath(c)
%             % sets paths appropriately for this task
%             
%             % set path relative to home directory            
%             addpath(genpath(fullfile(c.rootDir, 'xpc\utils')));
%             addpath(genpath(fullfile(c.rootDir, 'xpc\xpc')));
% 
%             %closeAllSystems(); % avoid shadowing issues
% 
%             % remove everything underneath xpc/people/djoshea
% %             warning('off', 'MATLAB:rmpath:DirNotFound');
% %             rmpath(genpath(c.rootXpcDir));
%             addpath(c.rootXpcDir);
% 
%             % add in just the requested version of the task
%             addpath(genpath(c.taskDir));
%             addpath(genpath(fullfile(c.rootXpcDir, 'lib')));
%             addpath(genpath(fullfile(c.rootDir, 'dataLogger')));
% 
%             if ~exist(c.workDir, 'dir')
%                 mkdir(c.workDir);
%             end
        end
        
        function open(c)
            open('CenterOutReach');
        end
        
        function build(c)
            slbuild('CenterOutReach');
        end
        
        function download(c)
            tg = slrt;
            old = pwd;
            % cd to build directory where .dlm is found
            buildDir = Simulink.fileGenControl('get', 'CodeGenFolder');
            cd(buildDir);
            tg.load(c.taskName);
            cd(old);
        end
        
        function start(c)
            % start model after downloading all params
            c.pauseTask();
            c.startModel();
        end
        
        function startModel(c)
            tg = slrt;
            tg.start();
        end
        
        function stop(c)
            tg = slrt;
            tg.stop();
        end
        
        function runTask(c)
            c.TunableTaskControl.toggleFieldOn('runTask');
            c.endTimeout();
        end
        
        function pauseTask(c)
            c.TunableTaskControl.toggleFieldOff('runTask');
        end
        
        function saveData(c)
            c.TunableTaskControl.toggleFieldOn('saveData');
            %c.TunableTaskControl.toggleFieldOn('saveNeuralData');
        end
        
        function noSaveData(c)
            c.TunableTaskControl.toggleFieldOff('saveData');
        end                                 
        
        function giveFreeJuice(c)
            c.TunableTaskControl.activatePulseField('giveFreeJuice');
        end
        
        function setJuice(c, timeMs)
            c.param.timeJuice = timeMs;
        end
      
        function resetImageDecoder(c)
            c.TunableParam.activatePulseField('resetImageDecoder'); 
        end
        
        function noSaveNeuralData(c)
            c.TunableTaskControl.toggleFieldOff('saveNeuralData');
        end
        
        function incrementSaveTag(c)
            c.dataLoggerInfo.saveTag = c.dataLoggerInfo.saveTag + 1;
%             c.resetStats();
        end
        
        function setSaveTag(c, st)
            c.dataLoggerInfo.saveTag = st;
%             c.resetStats();
        end
        
        function resetConditionBlock(c)
            c.TunableTaskControl.activatePulseField('resetConditionBlock');
        end
        
        function endTimeout(c)
            c.TunableTaskControl.activatePulseField('endTimeoutNow');
        end
        
        function resetStats(c)
            c.TunableTaskControl.activatePulseField('resetStats');
        end
        
        function autoTimeoutActive(c)
            c.TunableTaskControl.toggleFieldOn('autoTimeoutActive');
        end
        
        function noAutoTimeout(c)
            c.TunableTaskControl.toggleFieldOff('autoTimeoutActive');
        end
        
        function setNextTrialId(c, id)
            assert(id > 0);
            c.nextTrialId = id;
        end
        
        function ledsOn(c)
            c.TunableRigConfig.toggleFieldOn('mOEGLedsActive');
        end
        
        function ledsOff(c)
            c.TunableRigConfig.toggleFieldOff('mOEGLedsActive');
        end
        
        function isosbesticMode(c)
            c.TunableRigConfig.toggleFieldOn('mOEGAlternateLeds');
        end
        
        function cw470Mode(c)
            c.TunableRigConfig.toggleFieldOff('mOEGAlternateLeds');
        end
        
        function setDecodeConditions(c, classArray)
            c.param.conditionsToDecode = classArray;
        end
        
%         function setClass2(c, conditionId)
%             c.param.class2conditionId = conditionId;
%         end
%         
    end
    
    % parameter update methods
    methods
        function resetAll(c)
            c.rigConfig = initializeBus_RigConfigBus();
            c.taskControl = initializeBus_TaskControlBus();
            c.param = initializeBus_ParamBus();
            [c.conditions, c.conditionRepeats] = buildConditions();
            c.dataLoggerInfo = initializeBus_DataLoggerInfoBus();
        end
            
%         function setDataLoggerScopes(c)
%             d = c.dataLoggerInfo;
%             d.subject = 'Scopes';
%             d.dataStore = 'rig1';
%             d.protocol = 'CenterOutReach';
%             d.protocolVersion = c.taskVersion;
%             c.dataLoggerInfo = d;
%         end
%         
%         function setScopes(c)
%             c.setDataLoggerScopes();
%             setTaskForScopes(c);
%         end
%         
%         function setDataLoggerWatkins(c)
%             d = c.dataLoggerInfo;
%             d.subject = 'Watkins';
%             d.dataStore = 'rig1';
%             d.protocol = 'CenterOutReach';
%             d.protocolVersion = c.taskVersion;
%             c.dataLoggerInfo = d;
%         end
%         
%         function setWatkins(c)
%             c.setDataLoggerWatkins();
%             setTaskForWatkins(c);
%         end
%         
        function setDataLoggerTest(c)
            d = c.dataLoggerInfo;
            d.subject = 'TestSubject';
            d.dataStore = 'test';
            d.protocol = 'CenterOutReach';
            d.protocolVersion = c.taskVersion;
            c.dataLoggerInfo = d;
        end
        
        function setDataLoggerXavier(c)
            d = c.dataLoggerInfo;
            d.subject = 'Xavier';
            d.dataStore = 'rig1';
            d.protocol = 'CenterOutReach';
            d.protocolVersion = c.taskVersion;
            c.dataLoggerInfo = d;
        end
        
        function setXavierTraining(c)
            c.setDataLoggerXavier();
            setTaskForXavierTraining(c);
        end
        
        function setTesting(c)
            setTaskForXavierTraining(c);
            c.setDataLoggerTest();            
        end
        
        function setImageDecodeTesting(c)
            setTaskForImageDecodeTesting(c);
            c.setDataLoggerTest();
        end
            
        function setClassifierTraining(c)
            c.param.imageDecoderTraining = true;
        end
        
        function setClassifierDecode(c)
            c.param.imageDecoderTraining = false;
        end
%         function writeNote(c, noteType)
%             
%         end
        
        function setConditionHyperparameters(c, hp)
            assert(isa(hp, 'CenterOutReachConditionHyperparameters'));
            c.hp = hp;
            c.updateConditions;
        end
        
        function summarizeConditions(c)
            summarizeConditions(c.conditions, c.conditionRepeats);
        end
        
        function updateConditions(c)
            [c.conditions, c.conditionRepeats] = buildConditions(c.hp);
        end
    end
end
