function [bus, valid, offset] = deserializeBus_TaskStatisticsBus(input, offset, valid, namePrefix)
%#codegen
% DO NOT EDIT: Auto-generated by 
%   BusSerialize.writeDeserializeBusCode('TaskStatisticsBus')

    in = typecast(input, 'uint8');
    if nargin < 2
         offset = uint32(1);
    end
    if nargin < 3
         valid = uint8(1);
    end
    if nargin < 4
        namePrefix = uint8('');
    end
    offset = uint32(offset);

    bus = initializeBus_TaskStatisticsBus();
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Deserializing fixed-sized field conditionBlockTrialsRemaining
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Checking header
    if valid == uint8(0) || offset + uint32(43 + numel(namePrefix) - 1) > numel(in)
        valid = uint8(0);
    end
    expectedHeader_conditionBlockTrialsRemaining = uint8([2, 4, typecast(uint16(numel(namePrefix) + 29), 'uint8'), namePrefix, 'conditionBlockTrialsRemaining', typecast(uint16(6), 'uint8'), 'trials', 5, 1])';
    for headerOffset = 1:uint32(43+numel(namePrefix)-1)
        valid = uint8(valid && in(offset+headerOffset-1) == expectedHeader_conditionBlockTrialsRemaining(headerOffset));
    end
    offset = offset + uint32(43 + numel(namePrefix));

    % Establishing size
    if valid == uint8(0) || offset + uint32(2 - 1) > numel(in)
        % buffer not large enough for header
        valid = uint8(0);
        bus.conditionBlockTrialsRemaining = zeros([1 1], 'uint16');
    else
        sz = typecast(in(offset:(offset+uint32(2-1))), 'uint16')';
        offset = offset + uint32(2);
        % check size
        if sz(1) ~= uint16(1), valid = uint8(0); end
        elements = uint32(1);
        for i = 1:1
             elements = elements * uint32(sz(i));
        end
        if elements > uint32(0) && offset + uint32(elements*2 - 1) > numel(in)
            % buffer not large enough for data
            valid = uint8(0);
        end
        if valid && elements == uint32(0)
            % assigning empty value
            bus.conditionBlockTrialsRemaining = zeros([1 1], 'uint16');
        else
            % read and typecast data
            assert(elements <= uint32(1));
            bus.conditionBlockTrialsRemaining = zeros([1 1], 'uint16');
            if elements > uint32(0)
                bus.conditionBlockTrialsRemaining(1:elements) = typecast(in(offset:offset+uint32(elements*2 - 1))', 'uint16')';
                offset = offset + uint32(elements*2);
            end
        end
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Deserializing fixed-sized field conditionBlocksCompleted
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Checking header
    if valid == uint8(0) || offset + uint32(38 + numel(namePrefix) - 1) > numel(in)
        valid = uint8(0);
    end
    expectedHeader_conditionBlocksCompleted = uint8([2, 4, typecast(uint16(numel(namePrefix) + 24), 'uint8'), namePrefix, 'conditionBlocksCompleted', typecast(uint16(6), 'uint8'), 'blocks', 5, 1])';
    for headerOffset = 1:uint32(38+numel(namePrefix)-1)
        valid = uint8(valid && in(offset+headerOffset-1) == expectedHeader_conditionBlocksCompleted(headerOffset));
    end
    offset = offset + uint32(38 + numel(namePrefix));

    % Establishing size
    if valid == uint8(0) || offset + uint32(2 - 1) > numel(in)
        % buffer not large enough for header
        valid = uint8(0);
        bus.conditionBlocksCompleted = zeros([1 1], 'uint16');
    else
        sz = typecast(in(offset:(offset+uint32(2-1))), 'uint16')';
        offset = offset + uint32(2);
        % check size
        if sz(1) ~= uint16(1), valid = uint8(0); end
        elements = uint32(1);
        for i = 1:1
             elements = elements * uint32(sz(i));
        end
        if elements > uint32(0) && offset + uint32(elements*2 - 1) > numel(in)
            % buffer not large enough for data
            valid = uint8(0);
        end
        if valid && elements == uint32(0)
            % assigning empty value
            bus.conditionBlocksCompleted = zeros([1 1], 'uint16');
        else
            % read and typecast data
            assert(elements <= uint32(1));
            bus.conditionBlocksCompleted = zeros([1 1], 'uint16');
            if elements > uint32(0)
                bus.conditionBlocksCompleted(1:elements) = typecast(in(offset:offset+uint32(elements*2 - 1))', 'uint16')';
                offset = offset + uint32(elements*2);
            end
        end
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Deserializing fixed-sized field successes
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Checking header
    if valid == uint8(0) || offset + uint32(23 + numel(namePrefix) - 1) > numel(in)
        valid = uint8(0);
    end
    expectedHeader_successes = uint8([2, 4, typecast(uint16(numel(namePrefix) + 9), 'uint8'), namePrefix, 'successes', typecast(uint16(6), 'uint8'), 'trials', 5, 1])';
    for headerOffset = 1:uint32(23+numel(namePrefix)-1)
        valid = uint8(valid && in(offset+headerOffset-1) == expectedHeader_successes(headerOffset));
    end
    offset = offset + uint32(23 + numel(namePrefix));

    % Establishing size
    if valid == uint8(0) || offset + uint32(2 - 1) > numel(in)
        % buffer not large enough for header
        valid = uint8(0);
        bus.successes = zeros([1 1], 'uint16');
    else
        sz = typecast(in(offset:(offset+uint32(2-1))), 'uint16')';
        offset = offset + uint32(2);
        % check size
        if sz(1) ~= uint16(1), valid = uint8(0); end
        elements = uint32(1);
        for i = 1:1
             elements = elements * uint32(sz(i));
        end
        if elements > uint32(0) && offset + uint32(elements*2 - 1) > numel(in)
            % buffer not large enough for data
            valid = uint8(0);
        end
        if valid && elements == uint32(0)
            % assigning empty value
            bus.successes = zeros([1 1], 'uint16');
        else
            % read and typecast data
            assert(elements <= uint32(1));
            bus.successes = zeros([1 1], 'uint16');
            if elements > uint32(0)
                bus.successes(1:elements) = typecast(in(offset:offset+uint32(elements*2 - 1))', 'uint16')';
                offset = offset + uint32(elements*2);
            end
        end
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Deserializing fixed-sized field failures
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Checking header
    if valid == uint8(0) || offset + uint32(22 + numel(namePrefix) - 1) > numel(in)
        valid = uint8(0);
    end
    expectedHeader_failures = uint8([2, 4, typecast(uint16(numel(namePrefix) + 8), 'uint8'), namePrefix, 'failures', typecast(uint16(6), 'uint8'), 'trials', 5, 1])';
    for headerOffset = 1:uint32(22+numel(namePrefix)-1)
        valid = uint8(valid && in(offset+headerOffset-1) == expectedHeader_failures(headerOffset));
    end
    offset = offset + uint32(22 + numel(namePrefix));

    % Establishing size
    if valid == uint8(0) || offset + uint32(2 - 1) > numel(in)
        % buffer not large enough for header
        valid = uint8(0);
        bus.failures = zeros([1 1], 'uint16');
    else
        sz = typecast(in(offset:(offset+uint32(2-1))), 'uint16')';
        offset = offset + uint32(2);
        % check size
        if sz(1) ~= uint16(1), valid = uint8(0); end
        elements = uint32(1);
        for i = 1:1
             elements = elements * uint32(sz(i));
        end
        if elements > uint32(0) && offset + uint32(elements*2 - 1) > numel(in)
            % buffer not large enough for data
            valid = uint8(0);
        end
        if valid && elements == uint32(0)
            % assigning empty value
            bus.failures = zeros([1 1], 'uint16');
        else
            % read and typecast data
            assert(elements <= uint32(1));
            bus.failures = zeros([1 1], 'uint16');
            if elements > uint32(0)
                bus.failures(1:elements) = typecast(in(offset:offset+uint32(elements*2 - 1))', 'uint16')';
                offset = offset + uint32(elements*2);
            end
        end
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Deserializing fixed-sized field successRate
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Checking header
    if valid == uint8(0) || offset + uint32(19 + numel(namePrefix) - 1) > numel(in)
        valid = uint8(0);
    end
    expectedHeader_successRate = uint8([2, 4, typecast(uint16(numel(namePrefix) + 11), 'uint8'), namePrefix, 'successRate', typecast(uint16(0), 'uint8'), '', 0, 1])';
    for headerOffset = 1:uint32(19+numel(namePrefix)-1)
        valid = uint8(valid && in(offset+headerOffset-1) == expectedHeader_successRate(headerOffset));
    end
    offset = offset + uint32(19 + numel(namePrefix));

    % Establishing size
    if valid == uint8(0) || offset + uint32(2 - 1) > numel(in)
        % buffer not large enough for header
        valid = uint8(0);
        bus.successRate = zeros([1 1], 'double');
    else
        sz = typecast(in(offset:(offset+uint32(2-1))), 'uint16')';
        offset = offset + uint32(2);
        % check size
        if sz(1) ~= uint16(1), valid = uint8(0); end
        elements = uint32(1);
        for i = 1:1
             elements = elements * uint32(sz(i));
        end
        if elements > uint32(0) && offset + uint32(elements*8 - 1) > numel(in)
            % buffer not large enough for data
            valid = uint8(0);
        end
        if valid && elements == uint32(0)
            % assigning empty value
            bus.successRate = zeros([1 1], 'double');
        else
            % read and typecast data
            assert(elements <= uint32(1));
            bus.successRate = zeros([1 1], 'double');
            if elements > uint32(0)
                bus.successRate(1:elements) = typecast(in(offset:offset+uint32(elements*8 - 1))', 'double')';
                offset = offset + uint32(elements*8);
            end
        end
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Deserializing fixed-sized field recentSuccessRate
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Checking header
    if valid == uint8(0) || offset + uint32(25 + numel(namePrefix) - 1) > numel(in)
        valid = uint8(0);
    end
    expectedHeader_recentSuccessRate = uint8([2, 4, typecast(uint16(numel(namePrefix) + 17), 'uint8'), namePrefix, 'recentSuccessRate', typecast(uint16(0), 'uint8'), '', 0, 1])';
    for headerOffset = 1:uint32(25+numel(namePrefix)-1)
        valid = uint8(valid && in(offset+headerOffset-1) == expectedHeader_recentSuccessRate(headerOffset));
    end
    offset = offset + uint32(25 + numel(namePrefix));

    % Establishing size
    if valid == uint8(0) || offset + uint32(2 - 1) > numel(in)
        % buffer not large enough for header
        valid = uint8(0);
        bus.recentSuccessRate = zeros([1 1], 'double');
    else
        sz = typecast(in(offset:(offset+uint32(2-1))), 'uint16')';
        offset = offset + uint32(2);
        % check size
        if sz(1) ~= uint16(1), valid = uint8(0); end
        elements = uint32(1);
        for i = 1:1
             elements = elements * uint32(sz(i));
        end
        if elements > uint32(0) && offset + uint32(elements*8 - 1) > numel(in)
            % buffer not large enough for data
            valid = uint8(0);
        end
        if valid && elements == uint32(0)
            % assigning empty value
            bus.recentSuccessRate = zeros([1 1], 'double');
        else
            % read and typecast data
            assert(elements <= uint32(1));
            bus.recentSuccessRate = zeros([1 1], 'double');
            if elements > uint32(0)
                bus.recentSuccessRate(1:elements) = typecast(in(offset:offset+uint32(elements*8 - 1))', 'double')';
                offset = offset + uint32(elements*8);
            end
        end
    end


end