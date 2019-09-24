function outSize = getSerializedBusLength_ToHostBus(bus, namePrefix)
%#codegen
% DO NOT EDIT: Auto-generated by 
%   BusSerialize.writeGetSerializedBusLengthCode('ToHostBus')

    if nargin < 2, namePrefix = uint8(''); end
    namePrefixBytes = uint8(namePrefix(:))';
    outSize = uint32(0);
    % element rigConfig
    outSize = outSize + uint32(getSerializedBusLength_RigConfigBus(bus.rigConfig(1), uint8([namePrefix '_rigConfig']))); % for rigConfig nested bus

    % element clock
    outSize = outSize + uint32(1); % bit flags
    outSize = outSize + uint32(1); % signal type
    outSize = outSize + uint32(2 + numel(namePrefixBytes) + 5); % for name (including prefix)
    outSize = outSize + uint32(2 + 2); % for units
    outSize = outSize + uint32(1); % for data type id
    outSize = outSize + uint32(1 + 2*1); % for dimensions
    outSize = outSize + uint32(4 * numel(bus.clock)); % for clock data 

    % element scopeState
    outSize = outSize + uint32(getSerializedBusLength_MicroscopeStateBus(bus.scopeState(1), uint8([namePrefix '_scopeState']))); % for scopeState nested bus

    % element juiceRelease
    outSize = outSize + uint32(1); % bit flags
    outSize = outSize + uint32(1); % signal type
    outSize = outSize + uint32(2 + numel(namePrefixBytes) + 12); % for name (including prefix)
    outSize = outSize + uint32(2 + 0); % for units
    outSize = outSize + uint32(1); % for data type id
    outSize = outSize + uint32(1 + 2*1); % for dimensions
    outSize = outSize + uint32(1 * numel(bus.juiceRelease)); % for juiceRelease data 

    % element hand
    outSize = outSize + uint32(getSerializedBusLength_HandOutputBus(bus.hand(1), uint8([namePrefix '_hand']))); % for hand nested bus

    % element eye
    outSize = outSize + uint32(getSerializedBusLength_EyeOutputBus(bus.eye(1), uint8([namePrefix '_eye']))); % for eye nested bus

    % element analog
    outSize = outSize + uint32(getSerializedBusLength_AnalogOutputBus(bus.analog(1), uint8([namePrefix '_analog']))); % for analog nested bus

    % element trialData
    outSize = outSize + uint32(getSerializedBusLength_TrialDataOutputBus(bus.trialData(1), uint8([namePrefix '_trialData']))); % for trialData nested bus

    % element condition
    outSize = outSize + uint32(getSerializedBusLength_ConditionBus(bus.condition(1), uint8([namePrefix '_condition']))); % for condition nested bus

    % element taskControl
    outSize = outSize + uint32(getSerializedBusLength_TaskControlBus(bus.taskControl(1), uint8([namePrefix '_taskControl']))); % for taskControl nested bus

    % element param
    outSize = outSize + uint32(getSerializedBusLength_ParamBus(bus.param(1), uint8([namePrefix '_param']))); % for param nested bus

    % element dataLoggerInfo
    outSize = outSize + uint32(getSerializedBusLength_DataLoggerInfoBus(bus.dataLoggerInfo(1), uint8([namePrefix '_dataLoggerInfo']))); % for dataLoggerInfo nested bus

    % element trialId
    outSize = outSize + uint32(1); % bit flags
    outSize = outSize + uint32(1); % signal type
    outSize = outSize + uint32(2 + numel(namePrefixBytes) + 7); % for name (including prefix)
    outSize = outSize + uint32(2 + 0); % for units
    outSize = outSize + uint32(1); % for data type id
    outSize = outSize + uint32(1 + 2*1); % for dimensions
    outSize = outSize + uint32(4 * numel(bus.trialId)); % for trialId data 

    % element taskStatistics
    outSize = outSize + uint32(getSerializedBusLength_TaskStatisticsBus(bus.taskStatistics(1), uint8([namePrefix '_taskStatistics']))); % for taskStatistics nested bus

    % element taskEventBuffer
    outSize = outSize + uint32(1); % bit flags
    outSize = outSize + uint32(1); % signal type
    outSize = outSize + uint32(2 + numel(namePrefixBytes) + 15); % for name (including prefix)
    outSize = outSize + uint32(2 + 4); % for units
    outSize = outSize + uint32(1); % for data type id
    outSize = outSize + uint32(1 + 2*1); % for dimensions
    for iEl = 1:numel(bus.taskEventBuffer)
        outSize = outSize + uint32(numel(enumToString_TaskEvent(bus.taskEventBuffer(iEl)))); % for taskEventBuffer enum to string
    end
    outSize = outSize + uint32(numel(bus.taskEventBuffer)-1); 
    % element taskEventTimes
    outSize = outSize + uint32(1); % bit flags
    outSize = outSize + uint32(1); % signal type
    outSize = outSize + uint32(2 + numel(namePrefixBytes) + 14); % for name (including prefix)
    outSize = outSize + uint32(2 + 2); % for units
    outSize = outSize + uint32(1); % for data type id
    outSize = outSize + uint32(1 + 2*1); % for dimensions
    outSize = outSize + uint32(4 * numel(bus.taskEventTimes)); % for taskEventTimes data 


end