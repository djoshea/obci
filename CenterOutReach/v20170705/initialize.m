function initialize(forceReinitialize)

%% Set Path for current task version 

home =char(java.lang.System.getProperty('user.home'));
root = fullfile(home, '\code\rig1');
addpath(genpath(fullfile(root, 'xpc')));

%closeAllSystems(); % avoid shadowing issues

% remove everything underneath ROOT/tasks
tasksDir = fullfile(root, 'tasks');
warning('off', 'MATLAB:rmpath:DirNotFound');
rmpath(genpath(tasksDir));

[taskName, taskVersion] = getTaskInfoFromPath(mfilename('fullpath'));

% add current task
addpath(genpath(fullfile(root, 'tasks', taskName, sprintf('v%d',taskVersion))));

% add back just tasks folder but not recursively
addpath(fullfile(root, 'tasks'));

%% Turn off annoying warnings

warning('off', 'xPCTarget:sampleTime:sampleTimeInvariance'); % blocks that do not handle sample time changes at runtime

%% Load Config Reference

cfg = load('CenterOutReachConfigSet.mat');
assignin('base', 'CenterOutReachConfigSet', cfg.Configuration);

%% Check if already initialized
if nargin < 1
    forceReinitialize = false;
end

initializedFlagName = sprintf('initialized_%s_v%d', taskName, taskVersion);
if ~forceReinitialize
    done = evalin('base', sprintf('exist(''%s'', ''var'')', initializedFlagName));
    if done, return, end
end

%% Set Build directory and code gen directory

this = fileparts(mfilename('fullpath'));
codePath = fullfile(this, 'generatedCode');
BusSerialize.setGeneratedCodePath(codePath);

home = char(java.lang.System.getProperty('user.home'));
buildFolder = fullfile(home, 'Work.rig1', 'ChannelReach', ['v' num2str(taskVersion)]);
if ~exist(buildFolder, 'dir'), mkdir(buildFolder); end

try
    Simulink.fileGenControl('set', 'CacheFolder', buildFolder, 'CodeGenFolder', buildFolder)
catch
    warning('Unable to set CacheFolder and CodeGenFolder');
end

modelName = taskName;
try
    args = {'TLCOptions','-axPCMaxOverloads=99999 -axPCOverLoadLen=99999 -axPCStartupFlag=5'};
    cfigRef = getActiveConfigSet(modelName);
    if isempty(cfigRef)
        set_param(modelName,args{:});
    else
        cfig = evalin('base', cfigRef);
        set_param(cfig, args{:});
    end
catch
    warning('Unable to set TLCOptions');
end

%% Create ToHost signal

ToHost = Simulink.Signal;
ToHost.CoderInfo.StorageClass = 'ExportedGlobal';
ToHost.DimensionsMode = 'Variable';
ToHost.DataType = 'uint8';
assignin('base', 'ToHost', ToHost);

%% Initialize Rig Input

fprintf('Initializing %s v%d...\n', taskName, taskVersion);
initializeRigIO();

RigInfo = evalin('base', 'RigInfo');
RigInfo.outputSizes.maxEventsPerTick = 10;
RigInfo.outputSizes.maxEventsPerTrial = 50;
assignin('base', 'RigInfo', RigInfo);

%% Initialize Data Logger Control Bus
% be sure to author code for DataLoggerControlBus below!
BusSerialize.createDataLoggerControlBuses();

%% Define enumerations

states = ...
{   'TaskPaused', ...
    'StartTask', ...
    'GetNewTrialParams', ...
    'InitTrial', ...
    'WaitCenterAcquire', ...
    'WaitCenterSettle', ...
    'WaitCenterHold', ...
    'DelayPeriod', ...
    'GoCueZeroDelay', ...
    'GoCueNonZeroDelay', ...
    'WaitMoveOnset', ...
    'WaitTargetAcquire', ...
    'WaitTargetSettle', ...
    'WaitTargetHold', ...
    'Success', ...
    'ReachEnd', ...
    'ITI', ...
    'FailureCenterAcquire', ...
    'FailureCenterHold', ...
    'FailureDelayMove', ...
    'FailureRTTooFast', ...
    'FailureRTTooSlow', ...
    'FailureTargetAcquire', ...
    'FailureTargetHold', ...
    'FailureLowPeakVelocity', ...
    'FailureHandNotSeen', ...
    'TaskPurgatory', ...
};
BusSerialize.defineEnum('TaskState', states, 'description', ...
    'List of internal states of the task stateflow');
clear states;

events = ...
{   
    'CenterOnset', ...
    'CenterAcquired', ...
    'CenterUnacquired', ...
    'CenterSettled', ...
    'CenterHeld', ...
    'TargetOnsetCommand', ...
    'GoCueCommand', ...
    'GoCue', ...
    'TargetOnset', ...
    'MoveOnsetOnline', ...
    'MoveOnsetThresh', ...
    'TargetAcquired', ...
    'TargetUnacquired', ...
    'TargetSettled', ...
    'TargetHeld', ...
    'ReachEnd' ...
    'Success', ...
    'FailureToAcquireCenter', ...
    'FailureBrokeCenterHold', ...
    'FailureBrokeCenterHoldDelay', ...
    'FailureRTTooFast', ...
    'FailureRTTooSlow', ...
    'FailureToAcquireTarget', ...
    'FailureBrokeTargetHold', ...
    'FailureLowPeakVelocity', ...
    'FailureHandNotSeen', ...
    'DecodeComplete'
};
BusSerialize.defineEnum('TaskEvent', events);
clear events;

displayCommands = ...
{   'TaskPaused', ...
    'StartTask', ...
    'InitTrial', ...
    'CenterOnset', ...
    'CenterAcquired', ...
    'CenterSettled', ...
    'CenterHeld', ...
    'DelayPeriodStart', ...
    'GoCueZeroDelay', ...
    'GoCueNonZeroDelay', ...
    'MoveOnset', ...
    'ImageDecodeTestObject', ...
    'ImageDecodeTestObjectHide', ...
    'DecodeSuccess', ...
    'DecodeFail', ...
    'TargetAcquired', ...
    'TargetSettled', ...
    'TargetHeld', ...
    'Success', ...
    'FailureCenterFlyAway', ...
    'FailureTargetFlyAway', ...
    'ITI', ...
    'CenterUnacquired', ...
    'TargetUnacquired' ...
    'FailureHitObstacle', ...
    'HitObstacle', ...
    'ReleasedObstacle', ...
    'ObstacleOnset', ...
    'TargetShift', ...
    'TaskTimeout', ...
};
BusSerialize.defineEnum('DisplayCommand', displayCommands);
clear displayCommands

scopeCommands = ...
{   'NextTrial', ...
    'StartImagingOnTrigger', ...
    'StartTrialImaging', ...
    'EndTrialImaging', ...
    'StopImaging', ...
};
BusSerialize.defineEnum('ScopeCommand', scopeCommands);
clear scopeCommands

enumList = {'DisplayCommand', 'TaskEvent', 'TaskState', 'ScopeCommand'};
BusSerialize.updateCodeForEnums(enumList);

%% Build ConditionBus

initializeConditions();

%% Define Tunable Task Buses

import BusSerialize.SignalSpec;

% timing settings
P.timeImagingStartBeforeTargetOnset = SignalSpec.Param(uint32(100), 'ms');
P.timeCenterAcquire = SignalSpec.Param(uint32(5000), 'ms');
P.timeCenterSettle = SignalSpec.Param(uint32(200), 'ms');
P.timeCenterHold = SignalSpec.Param(uint32(50), 'ms');

P.rtMin = SignalSpec.Param(uint32(150), 'ms');
P.rtMax = SignalSpec.Param(uint32(600), 'ms');

P.timeTargetAcquire = SignalSpec.Param(uint32(800), 'ms');
P.timeTargetSettle = SignalSpec.Param(uint32(200), 'ms'); 
P.timeTargetHold = SignalSpec.Param(uint32(300), 'ms');

P.timeJuice = SignalSpec.Param(uint32(150), 'ms');
P.timeJuiceCenter = SignalSpec.Param(uint32(0), 'ms');
P.timeJuiceDecodeSuccess = SignalSpec.Param(uint32(250), 'ms');

P.timeRewardFeedback = SignalSpec.Param(uint32(200), 'ms');
P.timeFailureFeedback = SignalSpec.Param(uint32(1000), 'ms');

P.itiSuccess = SignalSpec.Param(uint32(100), 'ms');
P.itiFailure = SignalSpec.Param(uint32(100), 'ms');

P.repeatUntilSuccess = SignalSpec.ParamBoolean(false);
P.delayVibrateSigma = SignalSpec.Param(0.3, 'mm');
P.purgatoryTime = SignalSpec.Param(uint32(90*1000), 'ms');
P.purgatoryConsecutiveNoStarts = SignalSpec.Param(uint16(5), '');

% positional settings
P.centerSize = SignalSpec.Param(30, 'mm'); % size displayed on screen
P.centerHoldWindowSize = SignalSpec.Param(30, 'mm');
P.targetHoldWindowSize = SignalSpec.Param(20, 'mm');

P.acceptanceWindowPadding = SignalSpec.Param(5, 'mm'); % extra padding added to size of target and center to define the acceptance region

% for MoveOnsetThresh
P.distanceTowardsTargetThresh = SignalSpec.Param(0);
P.velocityTowardsTargetThresh = SignalSpec.Param(150);

% for peak velocity detection
P.threshAcceleration = SignalSpec.Param(300, 'mm/sec^2'); % threshold acceleration before deceleration is possible
P.decelerationThreshRatio = SignalSpec.Param(0.9); % fraction of peak acceleration to fall under to be considered deceleration (should be < 1)
P.reaccelerationThreshDelta = SignalSpec.Param(600, 'mm/sec^2'); % fraction of post peak minimum acceleration to be considered reacceleration (should be > 1)
P.minPeakVelocityTowardsTarget = SignalSpec.Param(450, 'mm/sec');

P.targetHoldJuiceSize = SignalSpec.Param(50, 'ms');
P.targetHoldJuiceInterval = SignalSpec.Param(100, 'ms');

P.allowHandNotSeen = SignalSpec.ParamBoolean(false);
P.allowReacquireCenter = SignalSpec.ParamBoolean(false);
P.allowReacquireTarget = SignalSpec.ParamBoolean(false);

P.frameSkipTime = SignalSpec.Param(200,'ms');
P.frameIntegrationTime = SignalSpec.Param(200,'ms');
P.imageDecoderTraining = SignalSpec.ParamBoolean(false);
P.resetImageDecoder = SignalSpec.PulseSwitch();
P.imageDecoderDebugDisplayMode = SignalSpec.ParamBoolean(false);
P.conditionsToDecode = SignalSpec.Param(true(4, 1));

BusSerialize.createBusBaseWorkspace('ParamBus', P);
clear P;


% Define TaskControl Bus
c.runTask = SignalSpec.ToggleSwitch();
c.saveData = SignalSpec.ToggleSwitch();
c.controlImaging = SignalSpec.ToggleSwitch(true);
c.imageEveryNthTrial = SignalSpec.Param(1, 'trials');
c.autoTimeoutActive = SignalSpec.ToggleSwitch(false);
c.endTimeoutNow = SignalSpec.PulseSwitch();
c.giveFreeJuice = SignalSpec.PulseSwitch(); % fed through change detection so that it acts a one-tick push button
c.resetConditionBlock = SignalSpec.PulseSwitch(); % fed through change detection so that it acts a one-tick push button
c.flushJuice = SignalSpec.ToggleSwitch();
c.resetStats = SignalSpec.ToggleSwitch();
BusSerialize.createBusBaseWorkspace('TaskControlBus', c);
clear c;

%% Create non-tunable utility buses

% Build TrialDataBus
td.taskRunning = SignalSpec.ParamBoolean(false);
td.rt = SignalSpec.Param(uint32(0), 'ms');
td.rtNominal = SignalSpec.Param(uint32(0), 'ms');
td.delay = SignalSpec.Param(uint32(0), 'ms');
td.iti = SignalSpec.Param(uint32(0), 'ms');
td.holdXCenter = SignalSpec.Param(0, 'mm');
td.holdYCenter = SignalSpec.Param(0, 'mm');
td.holdXTarget = SignalSpec.Param(0, 'mm');
td.holdYTarget = SignalSpec.Param(0, 'mm');
td.targetXCurrent = SignalSpec.Param(0, 'mm');
td.targetYCurrent = SignalSpec.Param(0, 'mm');
td.targetSizeCurrent = SignalSpec.Param(0, 'mm');
td.targetAcceptanceSizeCurrent = SignalSpec.Param(0, 'mm');

td.timeInitTrial = SignalSpec.Param(uint32(0), 'ms');
td.timeGoCueCommand = SignalSpec.Param(uint32(0), 'ms');
td.timeGoCue = SignalSpec.Param(uint32(0), 'ms');
td.timeTargetOnsetCommand = SignalSpec.Param(uint32(0), 'ms');
td.timeTargetOnset = SignalSpec.Param(uint32(0), 'ms');
td.timeMove = SignalSpec.Param(uint32(0), 'ms');

td.moveOnsetThreshOccurred = SignalSpec.Param(false);

td.isTouchingCenter = SignalSpec.ParamBoolean(false);
td.isTouchingTarget = SignalSpec.ParamBoolean(false);
td.isHoldingCenter = SignalSpec.ParamBoolean(false);
td.isHoldingTarget = SignalSpec.ParamBoolean(false);

td.distanceTowardsTarget = SignalSpec.Param(0, 'mm');
td.velocityTowardsTarget = SignalSpec.Param(0, 'mm/sec');
td.accelerationTowardsTarget = SignalSpec.Param(0, 'mm/sec^2');
td.lateralDistance = SignalSpec.Param(0, 'mm');
td.lateralVelocity = SignalSpec.Param(0, 'mm/sec');
td.lateralAcceleration = SignalSpec.Param(0, 'mm/sec^2');
td.peakVelocityTowardsTarget = SignalSpec.Param(0, 'mm/sec');
td.peakVelocityTowardsTargetTooLow = SignalSpec.ParamBoolean(false);
td.peakAccelerationTowardsTarget = SignalSpec.Param(0, 'mm/sec^2');
td.deceleratedBelowThresh = SignalSpec.ParamBoolean(false);
td.postPeakMinAccelerationTowardsTarget = SignalSpec.Param(0, 'mm/sec^2');

td.success = SignalSpec.ParamBoolean(false);
td.substantiveFailure = SignalSpec.ParamBoolean(false);
td.getNewTrialParams = SignalSpec.ParamBoolean(false);
td.failureCode = SignalSpec.ParamEnum('TaskState', TaskState.getDefaultValue());
td.consecutiveNoStarts = SignalSpec.Param(uint16(0));
td.purgatoryTimeRemaining = SignalSpec.Analog(uint32(0), 'ms');
td.inPurgatory = SignalSpec.ParamBoolean(false);
td.juiceTimeTotal = SignalSpec.Param(uint32(0), 'ms');
td.juiceNumDrops = SignalSpec.Param(uint16(0), 'drops');
td.juiceDropSize = SignalSpec.Param(uint16(0), 'ms');
td.juiceDropInterval = SignalSpec.Param(uint16(0), 'ms');
td.juiceDropsRemaining = SignalSpec.Param(uint16(0), 'drops');
td.timeFailureFeedback = SignalSpec.Param(uint32(0), 'ms');

% online imaging
td.imagingThisTrial = SignalSpec.ParamBoolean(false);
td.useNextFrame = SignalSpec.ParamBoolean(false);
td.decodeComplete = SignalSpec.ParamBoolean(false);
% td.decodedConditionId = SignalSpec.Param(uint16(0), 'au');
td.decodeSuccess = SignalSpec.ParamBoolean(false);
td.isDecodeCondition = SignalSpec.ParamBoolean(false);

BusSerialize.createBusBaseWorkspace('TrialDataBus', td);
clear td;

%% Build output buses

e = struct();
e.event = SignalSpec.EventNameEnum('TaskEvent');
BusSerialize.createBusBaseWorkspace('TaskEventBus', e);
clear e;

c = struct();
c.taskCommand = SignalSpec.AnalogEnum('DisplayCommand');
BusSerialize.createBusBaseWorkspace('DisplayCommandBus', c);
clear c;

c = struct();
c.taskName = SignalSpec.ParamString('CenterOutReachTask');
c.taskVersion = SignalSpec.Param(uint32(taskVersion));
BusSerialize.createBusBaseWorkspace('DisplaySetTaskBus', c);
clear c;

% build TrialDataOutputBus: subset of TrialDataBus that is sent to the 
% data logger at the end of the trial
td = struct();
td.rt = SignalSpec.Param(uint32(0), 'ms');
td.delay = SignalSpec.Param(uint32(0), 'ms');
td.iti = SignalSpec.Param(uint32(0), 'ms');
td.success = SignalSpec.ParamBoolean(false);
td.substantiveFailure = SignalSpec.ParamBoolean(false);
td.failureCode = SignalSpec.ParamEnum('TaskState');
td.consecutiveNoStarts = SignalSpec.Param(uint16(0));
td.inPurgatory = SignalSpec.ParamBoolean(false);
td.purgatoryTimeRemaining = SignalSpec.Analog(uint32(0), 'ms');
td.holdXCenter = SignalSpec.Param(0, 'mm');
td.holdYCenter = SignalSpec.Param(0, 'mm');
td.holdXTarget = SignalSpec.Param(0, 'mm');
td.holdYTarget = SignalSpec.Param(0, 'mm');
td.decodeSuccess = SignalSpec.ParamBoolean(false);
td.isDecodeCondition = SignalSpec.ParamBoolean(false);
BusSerialize.createBusBaseWorkspace('TrialDataOutputBus', td);
clear td;

% Build HandOutputBus (drop handUpdate signal)
h = struct();
h.handSource = SignalSpec.ParamEnum('HandSource');
h.handSeen = SignalSpec.AnalogBoolean(false);
h.handOnDevice = SignalSpec.AnalogBoolean(false);
h.handX = SignalSpec.Analog(0, 'mm');
h.handY = SignalSpec.Analog(0, 'mm');
h.handZ = SignalSpec.Analog(0, 'mm');
h.handTouching = SignalSpec.AnalogBoolean(false); % touching screen?
h.handVelocityX = SignalSpec.Analog(0, 'mm/sec');
h.handVelocityY = SignalSpec.Analog(0, 'mm/sec');
h.handVelocityZ = SignalSpec.Analog(0, 'mm/sec');
h.handAccelerationX = SignalSpec.Analog(0, 'mm/sec');
h.handAccelerationY = SignalSpec.Analog(0, 'mm/sec');
h.handAccelerationZ = SignalSpec.Analog(0, 'mm/sec');
h.handSpeed = SignalSpec.Analog(0, 'mm/sec');
h.handMoving = SignalSpec.AnalogBoolean(false);
BusSerialize.createBusBaseWorkspace('HandOutputBus', h);
clear h;

% Build AnalogOutputBus
a = struct();
a.photobox = SignalSpec.Analog(false); % debounced
a.photoboxRaw = SignalSpec.Analog(0, 'V');
BusSerialize.createBusBaseWorkspace('AnalogOutputBus', a);
clear a;

% Build EyeOutputBus
e = struct();
e.eyeRawX = SignalSpec.Analog(0);
e.eyeRawY = SignalSpec.Analog(0);
BusSerialize.createBusBaseWorkspace('EyeOutputBus', e);
clear e;

% Build TaskStatisticsBus
s = struct();
s.conditionBlockTrialsRemaining = SignalSpec.Param(uint16(0), 'trials');
s.conditionBlocksCompleted = SignalSpec.Param(uint16(0), 'blocks');
s.successes = SignalSpec.Param(uint16(0), 'trials');
s.failures = SignalSpec.Param(uint16(0), 'trials');
s.successRate = SignalSpec.Param(0);
s.recentSuccessRate = SignalSpec.Param(0);
BusSerialize.createBusBaseWorkspace('TaskStatisticsBus', s);
clear s;

% Build TaskOutputBus
o = struct();
o.juiceRelease = SignalSpec.ParamBoolean(false); % ttl signal to solenoid, task handles open / close logic internally
o.displayCommandQueue = SignalSpec.AnalogEnumVectorVariable('DisplayCommand', RigInfo.outputSizes.maxEventsPerTick); % this must be analog in order to queue multiple commands up
o.taskEventQueue = SignalSpec.EventEnumQueueVariable('TaskEvent', RigInfo.outputSizes.maxEventsPerTick); % this must be analog in order to queue multiple commands up
o.scopeCommandQueue = SignalSpec.AnalogEnumVectorVariable('ScopeCommand', RigInfo.outputSizes.maxEventsPerTick); % this must be analog in order to queue multiple commands up
o.TrialStart = SignalSpec.ParamBoolean(false);
o.TrialEnd = SignalSpec.ParamBoolean(false);
o.TrialITI = SignalSpec.ParamBoolean(false);
o.handOutput = SignalSpec.Bus('HandOutputBus');
o.eyeOutput = SignalSpec.Bus('EyeOutputBus');
o.analogOutput = SignalSpec.Bus('AnalogOutputBus');
o.trialData = SignalSpec.Bus('TrialDataBus');
o.trialDataOutput = SignalSpec.Bus('TrialDataOutputBus');
o.condition = SignalSpec.Bus('ConditionBus');
o.taskControl = SignalSpec.Bus('TaskControlBus');
o.param = SignalSpec.Bus('ParamBus');
o.dataLoggerInfo = SignalSpec.Bus('DataLoggerInfoBus');
o.trialId = SignalSpec.Param(uint32(0));
o.taskStatistics = SignalSpec.Bus('TaskStatisticsBus');
BusSerialize.createBusBaseWorkspace('TaskOutputBus', o);
clear o;

% Build ToHostBus
o = struct();
o.rigConfig = SignalSpec.Bus('RigConfigBus');
o.clock = SignalSpec.Analog(uint32(0), 'ms');
o.scopeState = SignalSpec.Bus('MicroscopeStateBus');
o.juiceRelease = SignalSpec.ParamBoolean(false); % ttl signal to solenoid, task handles open / close logic internally
o.hand = SignalSpec.Bus('HandOutputBus');
o.eye = SignalSpec.Bus('EyeOutputBus');
o.analog = SignalSpec.Bus('AnalogOutputBus');
o.trialData = SignalSpec.Bus('TrialDataOutputBus');
o.condition = SignalSpec.Bus('ConditionBus');
o.taskControl = SignalSpec.Bus('TaskControlBus');
o.param = SignalSpec.Bus('ParamBus');
o.dataLoggerInfo = SignalSpec.Bus('DataLoggerInfoBus');
o.trialId = SignalSpec.Param(uint32(0));
o.taskStatistics = SignalSpec.Bus('TaskStatisticsBus');
o.taskEventBuffer = SignalSpec.EventEnumQueueVariable('TaskEvent', RigInfo.outputSizes.maxEventsPerTrial); % this must be analog in order to queue multiple commands up
o.taskEventTimes = BusSerialize.SignalSpec.AnalogVectorVariable(zeros(0, 1, 'uint32'), RigInfo.outputSizes.maxEventsPerTrial, 'ms'); % timed from trial start
BusSerialize.createBusBaseWorkspace('ToHostBus', o);
clear o;

%% Uppdate code for buses

busList = {...
    'ParamBus', ...
    'TaskControlBus', ...
    'TrialDataBus', ...
    'TaskStatisticsBus', ...
    'TaskEventBus', ...
    'DisplayCommandBus', ...
    'DisplaySetTaskBus', ...
    'TrialDataOutputBus', ...
    'HandOutputBus', ...
    'AnalogOutputBus', ...
    'EyeOutputBus', ...
    'ToHostBus', ...
};
BusSerialize.updateCodeForBuses(busList);

BusSerialize.writeInitializeBusCode('TaskOutputBus');

%% Create tunable params

BusSerialize.TunableParameter.createBus('TunableTaskControl', 'TaskControlBus');
BusSerialize.TunableParameter.createBus('TunableParam', 'ParamBus');

%% Create ChannelReachControl crc
assignin('base', 'crc', CenterOutReachControl.getInstance());

%% Define flag so that we don't reinitialize
assignin('base', initializedFlagName, true);


