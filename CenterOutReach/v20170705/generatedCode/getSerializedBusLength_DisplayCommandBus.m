function outSize = getSerializedBusLength_DisplayCommandBus(bus, namePrefix)
%#codegen
% DO NOT EDIT: Auto-generated by 
%   BusSerialize.writeGetSerializedBusLengthCode('DisplayCommandBus')

    if nargin < 2, namePrefix = uint8(''); end
    namePrefixBytes = uint8(namePrefix(:))';
    outSize = uint32(0);
    % element taskCommand
    outSize = outSize + uint32(1); % bit flags
    outSize = outSize + uint32(1); % signal type
    outSize = outSize + uint32(2 + numel(namePrefixBytes) + 11); % for name (including prefix)
    outSize = outSize + uint32(2 + 4); % for units
    outSize = outSize + uint32(1); % for data type id
    outSize = outSize + uint32(1 + 2*1); % for dimensions
    for iEl = 1:numel(bus.taskCommand)
        outSize = outSize + uint32(numel(enumToString_DisplayCommand(bus.taskCommand(iEl)))); % for taskCommand enum to string
    end
    outSize = outSize + uint32(numel(bus.taskCommand)-1); 

end