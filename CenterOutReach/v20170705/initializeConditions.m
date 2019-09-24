function maxConditions = initializeConditions()
% defines condition related buses / enums

maxConditions = 20;

BusSerialize.defineEnum('TrialCategory', ...
    {'Unknown', 'TargetOnly', 'CenterOut'});

BusSerialize.updateCodeForEnums({'TrialCategory', 'DirectionName'});

import BusSerialize.SignalSpec;

v.enforceMinPeakVelocity = SignalSpec.ParamBoolean(false);
v.fracZeroDelay = SignalSpec.Param(0);
v.fracShortDelay = SignalSpec.Param(0);
v.delayRangeShortMin = SignalSpec.Param(0, 'ms');
v.delayRangeShortMax = SignalSpec.Param(0, 'ms');
v.delayRangeLongMin = SignalSpec.Param(0, 'ms');
v.delayRangeLongMax = SignalSpec.Param(0, 'ms');
v.delayNominal = SignalSpec.Param(0, 'ms');

% target location/shape specification. default starting target before
% shift.
v.centerX = SignalSpec.Param(0, 'mm');
v.centerY = SignalSpec.Param(0, 'mm');
v.targetX = SignalSpec.Param(0, 'mm');
v.targetY = SignalSpec.Param(0, 'mm');
v.targetSize = SignalSpec.Param(0, 'mm');
v.targetAcceptanceSize = SignalSpec.Param(0, 'mm');
v.targetDistance = SignalSpec.Param(0, 'mm');
v.targetDirection = SignalSpec.Param(0, 'radians');
v.targetDirectionName = SignalSpec.ParamEnum('DirectionName');

% is this trial center touch then juice only? for training mostly
v.hasCenterTouch = SignalSpec.ParamBoolean(true);
v.juiceDuringTargetHold = SignalSpec.ParamBoolean(false);

% condition meta information
v.trialCategory = SignalSpec.ParamEnum('TrialCategory');

v.hasImaging = SignalSpec.ParamBoolean(false);

v.conditionId = SignalSpec.Param(uint16(0));
v.conditionProportion = SignalSpec.Param(0);
v.conditionDesc = SignalSpec.ParamStringVariable('', 50);

BusSerialize.createBusBaseWorkspace('ConditionBus', v);

% and create a version with only the fixed size signals for use with
% stateflow
BusSerialize.createBusBaseWorkspaceWithFixedSizeSignalsOnly('ConditionFixedBus', v);

% and code to convert from variable to fixed
BusSerialize.writeDropVariableLengthSignalsFromBusCode('ConditionBus', 'ConditionFixedBus'); 

BusSerialize.updateCodeForBuses({'ConditionBus', 'ConditionFixedBus'});

%% Create tunable params

TunableConditions = BusSerialize.TunableParameter.createVariableLengthBusArray('TunableConditions', 'ConditionBus', maxConditions);
TunableConditionRepeats = BusSerialize.TunableParameter.create('TunableConditionRepeats', zeros(maxConditions, 1, 'uint16'));

%% Set tunable param values

hp = CenterOutReachConditionHyperparameters();
[C, conditionRepeats] = buildConditions(hp);
assert(numel(C) <= maxConditions, 'numel(conditions) == %d exceeds maxConditions == %d', numel(C), maxConditions);
TunableConditions.setValue(C, 'localOnly', true);
TunableConditionRepeats.setValue(conditionRepeats, 'localOnly', true);

%% Create TaskInfo constants

taskInfo.maxConditions = maxConditions;
%taskInfo.maxLenConditionsSerialized = conditionsSerializedMaxLength;
assignin('base', 'TaskInfo', taskInfo);
