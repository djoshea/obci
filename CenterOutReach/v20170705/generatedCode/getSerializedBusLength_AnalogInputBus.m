function outSize = getSerializedBusLength_AnalogInputBus(bus, namePrefix)
%#codegen
% DO NOT EDIT: Auto-generated by 
%   BusSerialize.writeGetSerializedBusLengthCode('AnalogInputBus')

    if nargin < 2, namePrefix = uint8(''); end
    namePrefixBytes = uint8(namePrefix(:))';
    outSize = uint32(0);
    % element photoboxRaw
    outSize = outSize + uint32(1); % bit flags
    outSize = outSize + uint32(1); % signal type
    outSize = outSize + uint32(2 + numel(namePrefixBytes) + 11); % for name (including prefix)
    outSize = outSize + uint32(2 + 1); % for units
    outSize = outSize + uint32(1); % for data type id
    outSize = outSize + uint32(1 + 2*1); % for dimensions
    outSize = outSize + uint32(8 * numel(bus.photoboxRaw)); % for photoboxRaw data 

    % element photobox
    outSize = outSize + uint32(1); % bit flags
    outSize = outSize + uint32(1); % signal type
    outSize = outSize + uint32(2 + numel(namePrefixBytes) + 8); % for name (including prefix)
    outSize = outSize + uint32(2 + 4); % for units
    outSize = outSize + uint32(1); % for data type id
    outSize = outSize + uint32(1 + 2*1); % for dimensions
    outSize = outSize + uint32(1 * numel(bus.photobox)); % for photobox data 


end