function [out, valid] = serializeBus_mOEGFrameInfoBus(bus, namePrefix)
%#codegen
% DO NOT EDIT: Auto-generated by 
%   BusSerialize.writeSerializeBusCode('mOEGFrameInfoBus')

    if nargin < 2, namePrefix = uint8(''); end
    namePrefixBytes = uint8(namePrefix(:))';
    valid = uint8(0);
    outSize = getSerializedBusLength_mOEGFrameInfoBus(bus, namePrefix);
    assert(outSize <= 119 + 4*numel(namePrefix));
    out = zeros(outSize, 1, 'uint8');
    offset = uint32(1);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Serialize fixed-sized mOEGIsAcquiring
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Check input size is valid
    assert(numel(bus.mOEGIsAcquiring) == 1, 'numel(bus.mOEGIsAcquiring) must be 1');    % mOEGIsAcquiring bitFlags
    if(offset > numel(out)), return, end
    out(offset) = uint8(2);
    offset = offset + uint32(1);

    % mOEGIsAcquiring signal type
    if(offset > numel(out)), return, end
    out(offset) = uint8(5);
    offset = offset + uint32(1);

    % mOEGIsAcquiring name with prefix 
    if(offset+uint32(2+15 -1) > numel(out)), return, end
    out(offset:(offset+uint32(1))) = typecast(uint16(numel(namePrefixBytes) + 15), 'uint8');
    offset = offset + uint32(2);
    out(offset:(offset+uint32(numel(namePrefixBytes) + 15-1))) = [namePrefixBytes, uint8('mOEGIsAcquiring')];
    offset = offset + uint32(numel(namePrefixBytes) + 15);

    % mOEGIsAcquiring units
    if(offset+uint32(2+0 -1) > numel(out)), return, end
    out(offset:(offset+uint32(1))) = typecast(uint16(0), 'uint8');
    offset = offset + uint32(2);

    % mOEGIsAcquiring data type id
    if(offset > numel(out)), return, end
    out(offset) = uint8(3); % data type is uint8
    offset = offset + uint32(1);

    % mOEGIsAcquiring dimensions
    if(offset > numel(out)), return, end
    if(offset+uint32(1+2*1-1) > numel(out)), return, end
    out(offset) = uint8(1);
    offset = offset + uint32(1);
    out(offset:(offset+uint32(2*1-1))) = typecast(uint16(numel(bus.mOEGIsAcquiring)), 'uint8');
    offset = offset + uint32(2*1);

    % mOEGIsAcquiring data
    nBytes = uint32(1 * numel(bus.mOEGIsAcquiring));
    if nBytes > uint32(0)
        if(offset+uint32(nBytes-1) > numel(out)), return, end
        out(offset:(offset+uint32(nBytes-1))) = uint8(bus.mOEGIsAcquiring(:));
    end
    offset = offset + nBytes;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Serialize fixed-sized mOEGFileNumber
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Check input size is valid
    assert(numel(bus.mOEGFileNumber) == 1, 'numel(bus.mOEGFileNumber) must be 1');    % mOEGFileNumber bitFlags
    if(offset > numel(out)), return, end
    out(offset) = uint8(2);
    offset = offset + uint32(1);

    % mOEGFileNumber signal type
    if(offset > numel(out)), return, end
    out(offset) = uint8(5);
    offset = offset + uint32(1);

    % mOEGFileNumber name with prefix 
    if(offset+uint32(2+14 -1) > numel(out)), return, end
    out(offset:(offset+uint32(1))) = typecast(uint16(numel(namePrefixBytes) + 14), 'uint8');
    offset = offset + uint32(2);
    out(offset:(offset+uint32(numel(namePrefixBytes) + 14-1))) = [namePrefixBytes, uint8('mOEGFileNumber')];
    offset = offset + uint32(numel(namePrefixBytes) + 14);

    % mOEGFileNumber units
    if(offset+uint32(2+0 -1) > numel(out)), return, end
    out(offset:(offset+uint32(1))) = typecast(uint16(0), 'uint8');
    offset = offset + uint32(2);

    % mOEGFileNumber data type id
    if(offset > numel(out)), return, end
    out(offset) = uint8(7); % data type is uint32
    offset = offset + uint32(1);

    % mOEGFileNumber dimensions
    if(offset > numel(out)), return, end
    if(offset+uint32(1+2*1-1) > numel(out)), return, end
    out(offset) = uint8(1);
    offset = offset + uint32(1);
    out(offset:(offset+uint32(2*1-1))) = typecast(uint16(numel(bus.mOEGFileNumber)), 'uint8');
    offset = offset + uint32(2*1);

    % mOEGFileNumber data
    nBytes = uint32(4 * numel(bus.mOEGFileNumber));
    if nBytes > uint32(0)
        if(offset+uint32(nBytes-1) > numel(out)), return, end
        out(offset:(offset+uint32(nBytes-1))) = typecast(uint32(bus.mOEGFileNumber(:))', 'uint8')';
    end
    offset = offset + nBytes;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Serialize fixed-sized mOEGFrameNumber
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Check input size is valid
    assert(numel(bus.mOEGFrameNumber) == 1, 'numel(bus.mOEGFrameNumber) must be 1');    % mOEGFrameNumber bitFlags
    if(offset > numel(out)), return, end
    out(offset) = uint8(2);
    offset = offset + uint32(1);

    % mOEGFrameNumber signal type
    if(offset > numel(out)), return, end
    out(offset) = uint8(5);
    offset = offset + uint32(1);

    % mOEGFrameNumber name with prefix 
    if(offset+uint32(2+15 -1) > numel(out)), return, end
    out(offset:(offset+uint32(1))) = typecast(uint16(numel(namePrefixBytes) + 15), 'uint8');
    offset = offset + uint32(2);
    out(offset:(offset+uint32(numel(namePrefixBytes) + 15-1))) = [namePrefixBytes, uint8('mOEGFrameNumber')];
    offset = offset + uint32(numel(namePrefixBytes) + 15);

    % mOEGFrameNumber units
    if(offset+uint32(2+0 -1) > numel(out)), return, end
    out(offset:(offset+uint32(1))) = typecast(uint16(0), 'uint8');
    offset = offset + uint32(2);

    % mOEGFrameNumber data type id
    if(offset > numel(out)), return, end
    out(offset) = uint8(7); % data type is uint32
    offset = offset + uint32(1);

    % mOEGFrameNumber dimensions
    if(offset > numel(out)), return, end
    if(offset+uint32(1+2*1-1) > numel(out)), return, end
    out(offset) = uint8(1);
    offset = offset + uint32(1);
    out(offset:(offset+uint32(2*1-1))) = typecast(uint16(numel(bus.mOEGFrameNumber)), 'uint8');
    offset = offset + uint32(2*1);

    % mOEGFrameNumber data
    nBytes = uint32(4 * numel(bus.mOEGFrameNumber));
    if nBytes > uint32(0)
        if(offset+uint32(nBytes-1) > numel(out)), return, end
        out(offset:(offset+uint32(nBytes-1))) = typecast(uint32(bus.mOEGFrameNumber(:))', 'uint8')';
    end
    offset = offset + nBytes;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Serialize fixed-sized mOEGLastFileFrameCount
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Check input size is valid
    assert(numel(bus.mOEGLastFileFrameCount) == 1, 'numel(bus.mOEGLastFileFrameCount) must be 1');    % mOEGLastFileFrameCount bitFlags
    if(offset > numel(out)), return, end
    out(offset) = uint8(2);
    offset = offset + uint32(1);

    % mOEGLastFileFrameCount signal type
    if(offset > numel(out)), return, end
    out(offset) = uint8(4);
    offset = offset + uint32(1);

    % mOEGLastFileFrameCount name with prefix 
    if(offset+uint32(2+22 -1) > numel(out)), return, end
    out(offset:(offset+uint32(1))) = typecast(uint16(numel(namePrefixBytes) + 22), 'uint8');
    offset = offset + uint32(2);
    out(offset:(offset+uint32(numel(namePrefixBytes) + 22-1))) = [namePrefixBytes, uint8('mOEGLastFileFrameCount')];
    offset = offset + uint32(numel(namePrefixBytes) + 22);

    % mOEGLastFileFrameCount units
    if(offset+uint32(2+0 -1) > numel(out)), return, end
    out(offset:(offset+uint32(1))) = typecast(uint16(0), 'uint8');
    offset = offset + uint32(2);

    % mOEGLastFileFrameCount data type id
    if(offset > numel(out)), return, end
    out(offset) = uint8(7); % data type is uint32
    offset = offset + uint32(1);

    % mOEGLastFileFrameCount dimensions
    if(offset > numel(out)), return, end
    if(offset+uint32(1+2*1-1) > numel(out)), return, end
    out(offset) = uint8(1);
    offset = offset + uint32(1);
    out(offset:(offset+uint32(2*1-1))) = typecast(uint16(numel(bus.mOEGLastFileFrameCount)), 'uint8');
    offset = offset + uint32(2*1);

    % mOEGLastFileFrameCount data
    nBytes = uint32(4 * numel(bus.mOEGLastFileFrameCount));
    if nBytes > uint32(0)
        if(offset+uint32(nBytes-1) > numel(out)), return, end
        out(offset:(offset+uint32(nBytes-1))) = typecast(uint32(bus.mOEGLastFileFrameCount(:))', 'uint8')';
    end
    offset = offset + nBytes; %#ok<NASGU>

    valid = uint8(1);
end