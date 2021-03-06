function [out, valid] = serializeBusWithDataLoggerHeader_TaskStatisticsBus(bus, groupType, groupName, timestamp, namePrefix)
%#codegen
% DO NOT EDIT: Auto-generated by 
%   BusSerialize.writeSerializeBusCode('TaskStatisticsBus')

    if nargin < 5, namePrefix = uint8(''); end
    namePrefixBytes = uint8(namePrefix(:))';
    valid = uint8(0);
    headerLength = uint32(BusSerialize.computeDataLoggerHeaderLength(uint8([namePrefixBytes, groupName])));
    outSize = headerLength + getSerializedBusLength_TaskStatisticsBus(bus, namePrefix);
    assert(outSize <= headerLength + 206 + 6*numel(namePrefix));
    out = zeros(outSize, 1, 'uint8');
    offset = uint32(1);

    % Serialize data logger header
    header = BusSerialize.serializeDataLoggerHeader(groupType, uint8([namePrefixBytes, groupName]), uint32(4181534687), uint16(6), timestamp);
    out(1:headerLength) = uint8(header);
    offset = offset + headerLength;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Serialize fixed-sized conditionBlockTrialsRemaining
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Check input size is valid
    assert(numel(bus.conditionBlockTrialsRemaining) == 1, 'numel(bus.conditionBlockTrialsRemaining) must be 1');    % conditionBlockTrialsRemaining bitFlags
    if(offset > numel(out)), return, end
    out(offset) = uint8(2);
    offset = offset + uint32(1);

    % conditionBlockTrialsRemaining signal type
    if(offset > numel(out)), return, end
    out(offset) = uint8(4);
    offset = offset + uint32(1);

    % conditionBlockTrialsRemaining name with prefix 
    if(offset+uint32(2+29 -1) > numel(out)), return, end
    out(offset:(offset+uint32(1))) = typecast(uint16(numel(namePrefixBytes) + 29), 'uint8');
    offset = offset + uint32(2);
    out(offset:(offset+uint32(numel(namePrefixBytes) + 29-1))) = [namePrefixBytes, uint8('conditionBlockTrialsRemaining')];
    offset = offset + uint32(numel(namePrefixBytes) + 29);

    % conditionBlockTrialsRemaining units
    if(offset+uint32(2+6 -1) > numel(out)), return, end
    out(offset:(offset+uint32(1))) = typecast(uint16(6), 'uint8');
    offset = offset + uint32(2);
    out(offset:(offset+uint32(6-1))) = uint8('trials');
    offset = offset + uint32(6);

    % conditionBlockTrialsRemaining data type id
    if(offset > numel(out)), return, end
    out(offset) = uint8(5); % data type is uint16
    offset = offset + uint32(1);

    % conditionBlockTrialsRemaining dimensions
    if(offset > numel(out)), return, end
    if(offset+uint32(1+2*1-1) > numel(out)), return, end
    out(offset) = uint8(1);
    offset = offset + uint32(1);
    out(offset:(offset+uint32(2*1-1))) = typecast(uint16(numel(bus.conditionBlockTrialsRemaining)), 'uint8');
    offset = offset + uint32(2*1);

    % conditionBlockTrialsRemaining data
    nBytes = uint32(2 * numel(bus.conditionBlockTrialsRemaining));
    if nBytes > uint32(0)
        if(offset+uint32(nBytes-1) > numel(out)), return, end
        out(offset:(offset+uint32(nBytes-1))) = typecast(uint16(bus.conditionBlockTrialsRemaining(:))', 'uint8')';
    end
    offset = offset + nBytes;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Serialize fixed-sized conditionBlocksCompleted
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Check input size is valid
    assert(numel(bus.conditionBlocksCompleted) == 1, 'numel(bus.conditionBlocksCompleted) must be 1');    % conditionBlocksCompleted bitFlags
    if(offset > numel(out)), return, end
    out(offset) = uint8(2);
    offset = offset + uint32(1);

    % conditionBlocksCompleted signal type
    if(offset > numel(out)), return, end
    out(offset) = uint8(4);
    offset = offset + uint32(1);

    % conditionBlocksCompleted name with prefix 
    if(offset+uint32(2+24 -1) > numel(out)), return, end
    out(offset:(offset+uint32(1))) = typecast(uint16(numel(namePrefixBytes) + 24), 'uint8');
    offset = offset + uint32(2);
    out(offset:(offset+uint32(numel(namePrefixBytes) + 24-1))) = [namePrefixBytes, uint8('conditionBlocksCompleted')];
    offset = offset + uint32(numel(namePrefixBytes) + 24);

    % conditionBlocksCompleted units
    if(offset+uint32(2+6 -1) > numel(out)), return, end
    out(offset:(offset+uint32(1))) = typecast(uint16(6), 'uint8');
    offset = offset + uint32(2);
    out(offset:(offset+uint32(6-1))) = uint8('blocks');
    offset = offset + uint32(6);

    % conditionBlocksCompleted data type id
    if(offset > numel(out)), return, end
    out(offset) = uint8(5); % data type is uint16
    offset = offset + uint32(1);

    % conditionBlocksCompleted dimensions
    if(offset > numel(out)), return, end
    if(offset+uint32(1+2*1-1) > numel(out)), return, end
    out(offset) = uint8(1);
    offset = offset + uint32(1);
    out(offset:(offset+uint32(2*1-1))) = typecast(uint16(numel(bus.conditionBlocksCompleted)), 'uint8');
    offset = offset + uint32(2*1);

    % conditionBlocksCompleted data
    nBytes = uint32(2 * numel(bus.conditionBlocksCompleted));
    if nBytes > uint32(0)
        if(offset+uint32(nBytes-1) > numel(out)), return, end
        out(offset:(offset+uint32(nBytes-1))) = typecast(uint16(bus.conditionBlocksCompleted(:))', 'uint8')';
    end
    offset = offset + nBytes;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Serialize fixed-sized successes
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Check input size is valid
    assert(numel(bus.successes) == 1, 'numel(bus.successes) must be 1');    % successes bitFlags
    if(offset > numel(out)), return, end
    out(offset) = uint8(2);
    offset = offset + uint32(1);

    % successes signal type
    if(offset > numel(out)), return, end
    out(offset) = uint8(4);
    offset = offset + uint32(1);

    % successes name with prefix 
    if(offset+uint32(2+9 -1) > numel(out)), return, end
    out(offset:(offset+uint32(1))) = typecast(uint16(numel(namePrefixBytes) + 9), 'uint8');
    offset = offset + uint32(2);
    out(offset:(offset+uint32(numel(namePrefixBytes) + 9-1))) = [namePrefixBytes, uint8('successes')];
    offset = offset + uint32(numel(namePrefixBytes) + 9);

    % successes units
    if(offset+uint32(2+6 -1) > numel(out)), return, end
    out(offset:(offset+uint32(1))) = typecast(uint16(6), 'uint8');
    offset = offset + uint32(2);
    out(offset:(offset+uint32(6-1))) = uint8('trials');
    offset = offset + uint32(6);

    % successes data type id
    if(offset > numel(out)), return, end
    out(offset) = uint8(5); % data type is uint16
    offset = offset + uint32(1);

    % successes dimensions
    if(offset > numel(out)), return, end
    if(offset+uint32(1+2*1-1) > numel(out)), return, end
    out(offset) = uint8(1);
    offset = offset + uint32(1);
    out(offset:(offset+uint32(2*1-1))) = typecast(uint16(numel(bus.successes)), 'uint8');
    offset = offset + uint32(2*1);

    % successes data
    nBytes = uint32(2 * numel(bus.successes));
    if nBytes > uint32(0)
        if(offset+uint32(nBytes-1) > numel(out)), return, end
        out(offset:(offset+uint32(nBytes-1))) = typecast(uint16(bus.successes(:))', 'uint8')';
    end
    offset = offset + nBytes;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Serialize fixed-sized failures
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Check input size is valid
    assert(numel(bus.failures) == 1, 'numel(bus.failures) must be 1');    % failures bitFlags
    if(offset > numel(out)), return, end
    out(offset) = uint8(2);
    offset = offset + uint32(1);

    % failures signal type
    if(offset > numel(out)), return, end
    out(offset) = uint8(4);
    offset = offset + uint32(1);

    % failures name with prefix 
    if(offset+uint32(2+8 -1) > numel(out)), return, end
    out(offset:(offset+uint32(1))) = typecast(uint16(numel(namePrefixBytes) + 8), 'uint8');
    offset = offset + uint32(2);
    out(offset:(offset+uint32(numel(namePrefixBytes) + 8-1))) = [namePrefixBytes, uint8('failures')];
    offset = offset + uint32(numel(namePrefixBytes) + 8);

    % failures units
    if(offset+uint32(2+6 -1) > numel(out)), return, end
    out(offset:(offset+uint32(1))) = typecast(uint16(6), 'uint8');
    offset = offset + uint32(2);
    out(offset:(offset+uint32(6-1))) = uint8('trials');
    offset = offset + uint32(6);

    % failures data type id
    if(offset > numel(out)), return, end
    out(offset) = uint8(5); % data type is uint16
    offset = offset + uint32(1);

    % failures dimensions
    if(offset > numel(out)), return, end
    if(offset+uint32(1+2*1-1) > numel(out)), return, end
    out(offset) = uint8(1);
    offset = offset + uint32(1);
    out(offset:(offset+uint32(2*1-1))) = typecast(uint16(numel(bus.failures)), 'uint8');
    offset = offset + uint32(2*1);

    % failures data
    nBytes = uint32(2 * numel(bus.failures));
    if nBytes > uint32(0)
        if(offset+uint32(nBytes-1) > numel(out)), return, end
        out(offset:(offset+uint32(nBytes-1))) = typecast(uint16(bus.failures(:))', 'uint8')';
    end
    offset = offset + nBytes;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Serialize fixed-sized successRate
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Check input size is valid
    assert(numel(bus.successRate) == 1, 'numel(bus.successRate) must be 1');    % successRate bitFlags
    if(offset > numel(out)), return, end
    out(offset) = uint8(2);
    offset = offset + uint32(1);

    % successRate signal type
    if(offset > numel(out)), return, end
    out(offset) = uint8(4);
    offset = offset + uint32(1);

    % successRate name with prefix 
    if(offset+uint32(2+11 -1) > numel(out)), return, end
    out(offset:(offset+uint32(1))) = typecast(uint16(numel(namePrefixBytes) + 11), 'uint8');
    offset = offset + uint32(2);
    out(offset:(offset+uint32(numel(namePrefixBytes) + 11-1))) = [namePrefixBytes, uint8('successRate')];
    offset = offset + uint32(numel(namePrefixBytes) + 11);

    % successRate units
    if(offset+uint32(2+0 -1) > numel(out)), return, end
    out(offset:(offset+uint32(1))) = typecast(uint16(0), 'uint8');
    offset = offset + uint32(2);

    % successRate data type id
    if(offset > numel(out)), return, end
    out(offset) = uint8(0); % data type is double
    offset = offset + uint32(1);

    % successRate dimensions
    if(offset > numel(out)), return, end
    if(offset+uint32(1+2*1-1) > numel(out)), return, end
    out(offset) = uint8(1);
    offset = offset + uint32(1);
    out(offset:(offset+uint32(2*1-1))) = typecast(uint16(numel(bus.successRate)), 'uint8');
    offset = offset + uint32(2*1);

    % successRate data
    nBytes = uint32(8 * numel(bus.successRate));
    if nBytes > uint32(0)
        if(offset+uint32(nBytes-1) > numel(out)), return, end
        out(offset:(offset+uint32(nBytes-1))) = typecast(double(bus.successRate(:))', 'uint8')';
    end
    offset = offset + nBytes;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Serialize fixed-sized recentSuccessRate
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Check input size is valid
    assert(numel(bus.recentSuccessRate) == 1, 'numel(bus.recentSuccessRate) must be 1');    % recentSuccessRate bitFlags
    if(offset > numel(out)), return, end
    out(offset) = uint8(2);
    offset = offset + uint32(1);

    % recentSuccessRate signal type
    if(offset > numel(out)), return, end
    out(offset) = uint8(4);
    offset = offset + uint32(1);

    % recentSuccessRate name with prefix 
    if(offset+uint32(2+17 -1) > numel(out)), return, end
    out(offset:(offset+uint32(1))) = typecast(uint16(numel(namePrefixBytes) + 17), 'uint8');
    offset = offset + uint32(2);
    out(offset:(offset+uint32(numel(namePrefixBytes) + 17-1))) = [namePrefixBytes, uint8('recentSuccessRate')];
    offset = offset + uint32(numel(namePrefixBytes) + 17);

    % recentSuccessRate units
    if(offset+uint32(2+0 -1) > numel(out)), return, end
    out(offset:(offset+uint32(1))) = typecast(uint16(0), 'uint8');
    offset = offset + uint32(2);

    % recentSuccessRate data type id
    if(offset > numel(out)), return, end
    out(offset) = uint8(0); % data type is double
    offset = offset + uint32(1);

    % recentSuccessRate dimensions
    if(offset > numel(out)), return, end
    if(offset+uint32(1+2*1-1) > numel(out)), return, end
    out(offset) = uint8(1);
    offset = offset + uint32(1);
    out(offset:(offset+uint32(2*1-1))) = typecast(uint16(numel(bus.recentSuccessRate)), 'uint8');
    offset = offset + uint32(2*1);

    % recentSuccessRate data
    nBytes = uint32(8 * numel(bus.recentSuccessRate));
    if nBytes > uint32(0)
        if(offset+uint32(nBytes-1) > numel(out)), return, end
        out(offset:(offset+uint32(nBytes-1))) = typecast(double(bus.recentSuccessRate(:))', 'uint8')';
    end
    offset = offset + nBytes; %#ok<NASGU>

    valid = uint8(1);
end