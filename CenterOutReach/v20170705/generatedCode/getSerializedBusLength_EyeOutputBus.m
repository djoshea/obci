function outSize = getSerializedBusLength_EyeOutputBus(bus, namePrefix)
%#codegen
% DO NOT EDIT: Auto-generated by 
%   BusSerialize.writeGetSerializedBusLengthCode('EyeOutputBus')

    if nargin < 2, namePrefix = uint8(''); end
    namePrefixBytes = uint8(namePrefix(:))';
    outSize = uint32(0);
    % element eyeRawX
    outSize = outSize + uint32(1); % bit flags
    outSize = outSize + uint32(1); % signal type
    outSize = outSize + uint32(2 + numel(namePrefixBytes) + 7); % for name (including prefix)
    outSize = outSize + uint32(2 + 0); % for units
    outSize = outSize + uint32(1); % for data type id
    outSize = outSize + uint32(1 + 2*1); % for dimensions
    outSize = outSize + uint32(8 * numel(bus.eyeRawX)); % for eyeRawX data 

    % element eyeRawY
    outSize = outSize + uint32(1); % bit flags
    outSize = outSize + uint32(1); % signal type
    outSize = outSize + uint32(2 + numel(namePrefixBytes) + 7); % for name (including prefix)
    outSize = outSize + uint32(2 + 0); % for units
    outSize = outSize + uint32(1); % for data type id
    outSize = outSize + uint32(1 + 2*1); % for dimensions
    outSize = outSize + uint32(8 * numel(bus.eyeRawY)); % for eyeRawY data 


end