function outSize = getSerializedBusLength_HandBus(bus, namePrefix)
%#codegen
% DO NOT EDIT: Auto-generated by 
%   BusSerialize.writeGetSerializedBusLengthCode('HandBus')

    if nargin < 2, namePrefix = uint8(''); end
    namePrefixBytes = uint8(namePrefix(:))';
    outSize = uint32(0);
    % element handSource
    outSize = outSize + uint32(1); % bit flags
    outSize = outSize + uint32(1); % signal type
    outSize = outSize + uint32(2 + numel(namePrefixBytes) + 10); % for name (including prefix)
    outSize = outSize + uint32(2 + 4); % for units
    outSize = outSize + uint32(1); % for data type id
    outSize = outSize + uint32(1 + 2*1); % for dimensions
    for iEl = 1:numel(bus.handSource)
        outSize = outSize + uint32(numel(enumToString_HandSource(bus.handSource(iEl)))); % for handSource enum to string
    end
    outSize = outSize + uint32(numel(bus.handSource)-1); 
    % element handUpdate
    outSize = outSize + uint32(1); % bit flags
    outSize = outSize + uint32(1); % signal type
    outSize = outSize + uint32(2 + numel(namePrefixBytes) + 10); % for name (including prefix)
    outSize = outSize + uint32(2 + 0); % for units
    outSize = outSize + uint32(1); % for data type id
    outSize = outSize + uint32(1 + 2*1); % for dimensions
    outSize = outSize + uint32(1 * numel(bus.handUpdate)); % for handUpdate data 

    % element handSeen
    outSize = outSize + uint32(1); % bit flags
    outSize = outSize + uint32(1); % signal type
    outSize = outSize + uint32(2 + numel(namePrefixBytes) + 8); % for name (including prefix)
    outSize = outSize + uint32(2 + 0); % for units
    outSize = outSize + uint32(1); % for data type id
    outSize = outSize + uint32(1 + 2*1); % for dimensions
    outSize = outSize + uint32(1 * numel(bus.handSeen)); % for handSeen data 

    % element handOnDevice
    outSize = outSize + uint32(1); % bit flags
    outSize = outSize + uint32(1); % signal type
    outSize = outSize + uint32(2 + numel(namePrefixBytes) + 12); % for name (including prefix)
    outSize = outSize + uint32(2 + 0); % for units
    outSize = outSize + uint32(1); % for data type id
    outSize = outSize + uint32(1 + 2*1); % for dimensions
    outSize = outSize + uint32(1 * numel(bus.handOnDevice)); % for handOnDevice data 

    % element handX
    outSize = outSize + uint32(1); % bit flags
    outSize = outSize + uint32(1); % signal type
    outSize = outSize + uint32(2 + numel(namePrefixBytes) + 5); % for name (including prefix)
    outSize = outSize + uint32(2 + 2); % for units
    outSize = outSize + uint32(1); % for data type id
    outSize = outSize + uint32(1 + 2*1); % for dimensions
    outSize = outSize + uint32(8 * numel(bus.handX)); % for handX data 

    % element handY
    outSize = outSize + uint32(1); % bit flags
    outSize = outSize + uint32(1); % signal type
    outSize = outSize + uint32(2 + numel(namePrefixBytes) + 5); % for name (including prefix)
    outSize = outSize + uint32(2 + 2); % for units
    outSize = outSize + uint32(1); % for data type id
    outSize = outSize + uint32(1 + 2*1); % for dimensions
    outSize = outSize + uint32(8 * numel(bus.handY)); % for handY data 

    % element handZ
    outSize = outSize + uint32(1); % bit flags
    outSize = outSize + uint32(1); % signal type
    outSize = outSize + uint32(2 + numel(namePrefixBytes) + 5); % for name (including prefix)
    outSize = outSize + uint32(2 + 2); % for units
    outSize = outSize + uint32(1); % for data type id
    outSize = outSize + uint32(1 + 2*1); % for dimensions
    outSize = outSize + uint32(8 * numel(bus.handZ)); % for handZ data 

    % element handTouching
    outSize = outSize + uint32(1); % bit flags
    outSize = outSize + uint32(1); % signal type
    outSize = outSize + uint32(2 + numel(namePrefixBytes) + 12); % for name (including prefix)
    outSize = outSize + uint32(2 + 0); % for units
    outSize = outSize + uint32(1); % for data type id
    outSize = outSize + uint32(1 + 2*1); % for dimensions
    outSize = outSize + uint32(1 * numel(bus.handTouching)); % for handTouching data 

    % element handVelocityX
    outSize = outSize + uint32(1); % bit flags
    outSize = outSize + uint32(1); % signal type
    outSize = outSize + uint32(2 + numel(namePrefixBytes) + 13); % for name (including prefix)
    outSize = outSize + uint32(2 + 6); % for units
    outSize = outSize + uint32(1); % for data type id
    outSize = outSize + uint32(1 + 2*1); % for dimensions
    outSize = outSize + uint32(8 * numel(bus.handVelocityX)); % for handVelocityX data 

    % element handVelocityY
    outSize = outSize + uint32(1); % bit flags
    outSize = outSize + uint32(1); % signal type
    outSize = outSize + uint32(2 + numel(namePrefixBytes) + 13); % for name (including prefix)
    outSize = outSize + uint32(2 + 6); % for units
    outSize = outSize + uint32(1); % for data type id
    outSize = outSize + uint32(1 + 2*1); % for dimensions
    outSize = outSize + uint32(8 * numel(bus.handVelocityY)); % for handVelocityY data 

    % element handVelocityZ
    outSize = outSize + uint32(1); % bit flags
    outSize = outSize + uint32(1); % signal type
    outSize = outSize + uint32(2 + numel(namePrefixBytes) + 13); % for name (including prefix)
    outSize = outSize + uint32(2 + 6); % for units
    outSize = outSize + uint32(1); % for data type id
    outSize = outSize + uint32(1 + 2*1); % for dimensions
    outSize = outSize + uint32(8 * numel(bus.handVelocityZ)); % for handVelocityZ data 

    % element handAccelerationX
    outSize = outSize + uint32(1); % bit flags
    outSize = outSize + uint32(1); % signal type
    outSize = outSize + uint32(2 + numel(namePrefixBytes) + 17); % for name (including prefix)
    outSize = outSize + uint32(2 + 8); % for units
    outSize = outSize + uint32(1); % for data type id
    outSize = outSize + uint32(1 + 2*1); % for dimensions
    outSize = outSize + uint32(8 * numel(bus.handAccelerationX)); % for handAccelerationX data 

    % element handAccelerationY
    outSize = outSize + uint32(1); % bit flags
    outSize = outSize + uint32(1); % signal type
    outSize = outSize + uint32(2 + numel(namePrefixBytes) + 17); % for name (including prefix)
    outSize = outSize + uint32(2 + 8); % for units
    outSize = outSize + uint32(1); % for data type id
    outSize = outSize + uint32(1 + 2*1); % for dimensions
    outSize = outSize + uint32(8 * numel(bus.handAccelerationY)); % for handAccelerationY data 

    % element handAccelerationZ
    outSize = outSize + uint32(1); % bit flags
    outSize = outSize + uint32(1); % signal type
    outSize = outSize + uint32(2 + numel(namePrefixBytes) + 17); % for name (including prefix)
    outSize = outSize + uint32(2 + 8); % for units
    outSize = outSize + uint32(1); % for data type id
    outSize = outSize + uint32(1 + 2*1); % for dimensions
    outSize = outSize + uint32(8 * numel(bus.handAccelerationZ)); % for handAccelerationZ data 

    % element handSpeed
    outSize = outSize + uint32(1); % bit flags
    outSize = outSize + uint32(1); % signal type
    outSize = outSize + uint32(2 + numel(namePrefixBytes) + 9); % for name (including prefix)
    outSize = outSize + uint32(2 + 6); % for units
    outSize = outSize + uint32(1); % for data type id
    outSize = outSize + uint32(1 + 2*1); % for dimensions
    outSize = outSize + uint32(8 * numel(bus.handSpeed)); % for handSpeed data 

    % element handMoving
    outSize = outSize + uint32(1); % bit flags
    outSize = outSize + uint32(1); % signal type
    outSize = outSize + uint32(2 + numel(namePrefixBytes) + 10); % for name (including prefix)
    outSize = outSize + uint32(2 + 0); % for units
    outSize = outSize + uint32(1); % for data type id
    outSize = outSize + uint32(1 + 2*1); % for dimensions
    outSize = outSize + uint32(1 * numel(bus.handMoving)); % for handMoving data 


end