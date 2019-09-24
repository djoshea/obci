function initializeRigIO()
% defines Rig buses and stores RigInfo struct in base workspace

%% Define RigInfo struct

% sets up all networking info in RigInfo.network
RigInfo = buildRigInfoCommon();

RigInfo.outputSizes.udpToDataLogger = 100000;
RigInfo.outputSizes.udpToDisplay = 70000;
RigInfo.outputSizes.udpToScope = 1500;
RigInfo.outputSizes.serialToCerebus = 1000;
RigInfo.outputSizes.trialInfoToScope = 1000;

assignin('base', 'RigInfo', RigInfo);

%% Create MicroscopeState buses

createMicroscopeBuses();

%% Define Rig IO buses

import BusSerialize.SignalSpec;

% Build HandSource
handSourceList = {'Mouse', 'Polaris', 'Haptic'};
BusSerialize.defineEnum('HandSource', handSourceList);
BusSerialize.updateCodeForEnums('HandSource');

% % Build PolarisInputBus
v = struct();
v.update = SignalSpec.AnalogBoolean(false);
v.markerSeen = SignalSpec.AnalogBoolean(false);
v.touchingScreen = SignalSpec.AnalogBoolean(false);
v.markerX = SignalSpec.Analog(0, 'mm');
v.markerY = SignalSpec.Analog(0, 'mm');
v.markerZ = SignalSpec.Analog(0, 'mm');
v.markerVelX = SignalSpec.Analog(0, 'mm/s');
v.markerVelY = SignalSpec.Analog(0, 'mm/s');
v.markerVelZ = SignalSpec.Analog(0, 'mm/s');
v.numMakersInVolume = SignalSpec.Analog(uint8(0), 'markers');
v.numReflections = SignalSpec.Analog(uint8(0), 'markers');
v.numMarkersOutOfVolume = SignalSpec.Analog(uint8(0), 'markers');
BusSerialize.createBusBaseWorkspace('PolarisInputBus', v);
clear v;

% Build EyeInputBus
e = struct();
e.eyeUpdate = SignalSpec.Analog(false);
e.eyeRawX = SignalSpec.Analog(0);
e.eyeRawY = SignalSpec.Analog(0);
BusSerialize.createBusBaseWorkspace('EyeInputBus', e);
clear e;

% Build Mouse Input Bus
m = struct();
m.update = SignalSpec.Analog(false);
m.mouseX = SignalSpec.Analog(0, 'mm');
m.mouseY = SignalSpec.Analog(0, 'mm');
m.mouseVelX = SignalSpec.Analog(0, 'mm/s');
m.mouseVelY = SignalSpec.Analog(0, 'mm/s');
m.mouseClick = SignalSpec.Analog(false);
BusSerialize.createBusBaseWorkspace('MouseInputBus', m);
clear m;

% Build HandBus
h = struct();
h.handSource = SignalSpec.ParamEnum('HandSource');
h.handUpdate = SignalSpec.AnalogBoolean(false);
h.handSeen = SignalSpec.AnalogBoolean(false);
h.handOnDevice = SignalSpec.AnalogBoolean(false);
h.handX = SignalSpec.Analog(0, 'mm');
h.handY = SignalSpec.Analog(0, 'mm');
h.handZ = SignalSpec.Analog(0, 'mm');
h.handTouching = SignalSpec.AnalogBoolean(false); % touching screen?
h.handVelocityX = SignalSpec.Analog(0, 'mm/sec');
h.handVelocityY = SignalSpec.Analog(0, 'mm/sec');
h.handVelocityZ = SignalSpec.Analog(0, 'mm/sec');
h.handAccelerationX = SignalSpec.Analog(0, 'mm/sec^2');
h.handAccelerationY = SignalSpec.Analog(0, 'mm/sec^2');
h.handAccelerationZ = SignalSpec.Analog(0, 'mm/sec^2');
h.handSpeed = SignalSpec.Analog(0, 'mm/sec');
h.handMoving = SignalSpec.AnalogBoolean(false);
BusSerialize.createBusBaseWorkspace('HandBus', h);
clear h;

% Build DisplayInfoRequestBus
d = struct();
d.infoPoll = SignalSpec.Param(true);
BusSerialize.createBusBaseWorkspace('DisplayInfoRequestBus', d);
clear d;

% Build Analog Input Bus
a = struct();
a.photoboxRaw = SignalSpec.Analog(0, 'V');
a.photobox = SignalSpec.Analog(false); % debounced
BusSerialize.createBusBaseWorkspace('AnalogInputBus', a);
clear a;

% Build Scope Timing Bus
t = struct();
t.startFrameGalvoAnalog = SignalSpec.Analog(0, 'V');
t.endFrameGalvoAnalog = SignalSpec.Analog(0, 'V');
t.startFrameResonantAnalog = SignalSpec.Analog(0, 'V');
t.endFrameResonantAnalog = SignalSpec.Analog(0, 'V');
t.cameraFrameEndAnalog = SignalSpec.Analog(0, 'V');
t.cameraFrameEnd = SignalSpec.AnalogBoolean(false); % pulse at end of frame (from orca out 0)
t.cameraFrameExposure = SignalSpec.AnalogBoolean(false); % high during exposure (from orca out 2)
t.led470Active = SignalSpec.AnalogBoolean(false); % high when 470 nm led is on (from arduino)
t.led405Active = SignalSpec.AnalogBoolean(false); % high when 405 nm led is on (from arduino)
BusSerialize.createBusBaseWorkspace('ScopeTimingBus', t);
clear a;

% build decoder signal bus
de = struct();
de.decoderUpdate = SignalSpec.ParamBoolean(false, 'includeForSerialization', false);
de.decodeConditionId = SignalSpec.Analog(uint16(0), '');
de.conditionPredictionLikelihood = SignalSpec.AnalogVectorMultiChannel(zeros(4, 1, 'double'), 'AU', ...
    'concatLastDim', true);
de.classifierInfo = SignalSpec.ParamStringVariable('', 300); 

BusSerialize.createBusBaseWorkspace('DecoderBus', de);
clear de;


% ScopeEvent enum
events = ...
{   'CameraFrameEnd', ...
};
BusSerialize.defineEnum('ScopeEvent', events);
clear events;

% Build Scope Event Bus
e = struct();
e.event = SignalSpec.EventNameEnum('ScopeEvent');
BusSerialize.createBusBaseWorkspace('ScopeEventBus', e);
clear e;

% create mOEGFrameInfoBus
info = struct();
info.mOEGIsAcquiring = SignalSpec.AnalogBoolean(false);
info.mOEGFileNumber = SignalSpec.Analog(uint32(0));
info.mOEGFrameNumber = SignalSpec.Analog(uint32(0));
info.mOEGLastFileFrameCount = SignalSpec.Param(uint32(0));
BusSerialize.createBusBaseWorkspace('mOEGFrameInfoBus', info);
BusSerialize.updateCodeForBuses({'mOEGFrameInfoBus'});

% Build RigInputBus
r = struct();
r.rigConfig = SignalSpec.Bus('RigConfigBus');
r.clock = SignalSpec.Analog(uint32(0), 'ms');
r.hand = SignalSpec.Bus('HandBus');
r.eye = SignalSpec.Bus('EyeInputBus');
r.analog = SignalSpec.Bus('AnalogInputBus');
r.scopeState = SignalSpec.Bus('MicroscopeStateBus');
r.scopeTiming = SignalSpec.Bus('ScopeTimingBus');
r.mOEGFrameInfo = SignalSpec.Bus('mOEGFrameInfoBus');
r.decoderBus = SignalSpec.Bus('DecoderBus');
BusSerialize.createBusBaseWorkspace('RigInputBus', r);
clear r;

% Build RigConfigBus
c = struct();
c.handSource = SignalSpec.ParamEnum('HandSource', 'value', HandSource.Polaris);
c.polarisReflectionDistanceThreshXY = SignalSpec.Param(200, 'mm');
c.polarisReflectionDistanceThreshZ = SignalSpec.Param(100, 'mm');
c.polarisThreshTouchingZ = SignalSpec.Param(15, 'mm');
c.polarisManualOffset = SignalSpec.Param([0 10 0], 'mm'); % move cursor above bead by 10 mm
c.polarisVolumeLimsX = SignalSpec.Param(RigInfo.polarisCalibration.limsX, 'mm');
c.polarisVolumeLimsY = SignalSpec.Param(RigInfo.polarisCalibration.limsY, 'mm');
c.polarisVolumeLimsZ = SignalSpec.Param(RigInfo.polarisCalibration.limsZ, 'mm');
c.polarisOrigin = SignalSpec.Param(RigInfo.polarisCalibration.origin, 'mm');
c.moveSpeedThresh = SignalSpec.Param(100, 'mm/s'); % normally 15
BusSerialize.createBusBaseWorkspace('RigConfigBus', c);
clear c;

% Build RigOutputBus
o.deliverJuice = SignalSpec.Analog(false);
o.udpToDataLogger = SignalSpec.ParamVectorVariable(zeros(0, 1, 'uint8'), RigInfo.outputSizes.udpToDataLogger);
o.udpToDisplay = SignalSpec.ParamVectorVariable(zeros(0, 1, 'uint8'), RigInfo.outputSizes.udpToDisplay);
o.udpToScope = SignalSpec.ParamVectorVariable(zeros(0, 1, 'uint8'), RigInfo.outputSizes.udpToScope);
o.scopeTrigger = SignalSpec.ParamBoolean(false);
o.scopeTrialInfo = SignalSpec.ParamStringVariable('', RigInfo.outputSizes.trialInfoToScope);
o.TrialStart = SignalSpec.ParamBoolean(false);
o.TrialEnd = SignalSpec.ParamBoolean(false);
o.trialId = SignalSpec.Param(uint32(0));
o.mOEGLed470Active = SignalSpec.ParamBoolean(false);
o.mOEGLed405Active = SignalSpec.ParamBoolean(false);
BusSerialize.createBusBaseWorkspace('RigOutputBus', o);
clear o;

enumList = {'ScopeEvent'};
BusSerialize.updateCodeForEnums(enumList);

busList = {...
    'PolarisInputBus', ...
    'EyeInputBus', ...
    'MouseInputBus', ...
    'AnalogInputBus', ...
    'ScopeTimingBus', ...
    'ScopeEventBus', ...
    'DisplayInfoRequestBus', ...
    'HandBus' ...
    'RigInputBus', ...
    'RigConfigBus', ...
    'RigOutputBus', ...
    'DecoderBus', ...
};
BusSerialize.updateCodeForBuses(busList);

%% Create tunable parameters=
BusSerialize.TunableParameter.createBus('TunableRigConfig', 'RigConfigBus');

end
