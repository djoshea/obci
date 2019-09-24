function [bus, valid, offset] = deserializeBus_TaskControlBus(input, offset, valid, namePrefix)
%#codegen
% DO NOT EDIT: Auto-generated by 
%   BusSerialize.writeDeserializeBusCode('TaskControlBus')

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

    bus = initializeBus_TaskControlBus();
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Deserializing fixed-sized field runTask
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Checking header
    if valid == uint8(0) || offset + uint32(15 + numel(namePrefix) - 1) > numel(in)
        valid = uint8(0);
    end
    expectedHeader_runTask = uint8([2, 4, typecast(uint16(numel(namePrefix) + 7), 'uint8'), namePrefix, 'runTask', typecast(uint16(0), 'uint8'), '', 3, 1])';
    for headerOffset = 1:uint32(15+numel(namePrefix)-1)
        valid = uint8(valid && in(offset+headerOffset-1) == expectedHeader_runTask(headerOffset));
    end
    offset = offset + uint32(15 + numel(namePrefix));

    % Establishing size
    if valid == uint8(0) || offset + uint32(2 - 1) > numel(in)
        % buffer not large enough for header
        valid = uint8(0);
        bus.runTask = zeros([1 1], 'uint8');
    else
        sz = typecast(in(offset:(offset+uint32(2-1))), 'uint16')';
        offset = offset + uint32(2);
        % check size
        if sz(1) ~= uint16(1), valid = uint8(0); end
        elements = uint32(1);
        for i = 1:1
             elements = elements * uint32(sz(i));
        end
        if elements > uint32(0) && offset + uint32(elements*1 - 1) > numel(in)
            % buffer not large enough for data
            valid = uint8(0);
        end
        if valid && elements == uint32(0)
            % assigning empty value
            bus.runTask = zeros([1 1], 'uint8');
        else
            % read and typecast data
            assert(elements <= uint32(1));
            bus.runTask = zeros([1 1], 'uint8');
            if elements > uint32(0)
                bus.runTask(1:elements) = typecast(in(offset:offset+uint32(elements*1 - 1))', 'uint8')';
                offset = offset + uint32(elements*1);
            end
        end
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Deserializing fixed-sized field saveData
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Checking header
    if valid == uint8(0) || offset + uint32(16 + numel(namePrefix) - 1) > numel(in)
        valid = uint8(0);
    end
    expectedHeader_saveData = uint8([2, 4, typecast(uint16(numel(namePrefix) + 8), 'uint8'), namePrefix, 'saveData', typecast(uint16(0), 'uint8'), '', 3, 1])';
    for headerOffset = 1:uint32(16+numel(namePrefix)-1)
        valid = uint8(valid && in(offset+headerOffset-1) == expectedHeader_saveData(headerOffset));
    end
    offset = offset + uint32(16 + numel(namePrefix));

    % Establishing size
    if valid == uint8(0) || offset + uint32(2 - 1) > numel(in)
        % buffer not large enough for header
        valid = uint8(0);
        bus.saveData = zeros([1 1], 'uint8');
    else
        sz = typecast(in(offset:(offset+uint32(2-1))), 'uint16')';
        offset = offset + uint32(2);
        % check size
        if sz(1) ~= uint16(1), valid = uint8(0); end
        elements = uint32(1);
        for i = 1:1
             elements = elements * uint32(sz(i));
        end
        if elements > uint32(0) && offset + uint32(elements*1 - 1) > numel(in)
            % buffer not large enough for data
            valid = uint8(0);
        end
        if valid && elements == uint32(0)
            % assigning empty value
            bus.saveData = zeros([1 1], 'uint8');
        else
            % read and typecast data
            assert(elements <= uint32(1));
            bus.saveData = zeros([1 1], 'uint8');
            if elements > uint32(0)
                bus.saveData(1:elements) = typecast(in(offset:offset+uint32(elements*1 - 1))', 'uint8')';
                offset = offset + uint32(elements*1);
            end
        end
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Deserializing fixed-sized field controlImaging
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Checking header
    if valid == uint8(0) || offset + uint32(22 + numel(namePrefix) - 1) > numel(in)
        valid = uint8(0);
    end
    expectedHeader_controlImaging = uint8([2, 4, typecast(uint16(numel(namePrefix) + 14), 'uint8'), namePrefix, 'controlImaging', typecast(uint16(0), 'uint8'), '', 3, 1])';
    for headerOffset = 1:uint32(22+numel(namePrefix)-1)
        valid = uint8(valid && in(offset+headerOffset-1) == expectedHeader_controlImaging(headerOffset));
    end
    offset = offset + uint32(22 + numel(namePrefix));

    % Establishing size
    if valid == uint8(0) || offset + uint32(2 - 1) > numel(in)
        % buffer not large enough for header
        valid = uint8(0);
        bus.controlImaging = zeros([1 1], 'uint8');
    else
        sz = typecast(in(offset:(offset+uint32(2-1))), 'uint16')';
        offset = offset + uint32(2);
        % check size
        if sz(1) ~= uint16(1), valid = uint8(0); end
        elements = uint32(1);
        for i = 1:1
             elements = elements * uint32(sz(i));
        end
        if elements > uint32(0) && offset + uint32(elements*1 - 1) > numel(in)
            % buffer not large enough for data
            valid = uint8(0);
        end
        if valid && elements == uint32(0)
            % assigning empty value
            bus.controlImaging = zeros([1 1], 'uint8');
        else
            % read and typecast data
            assert(elements <= uint32(1));
            bus.controlImaging = zeros([1 1], 'uint8');
            if elements > uint32(0)
                bus.controlImaging(1:elements) = typecast(in(offset:offset+uint32(elements*1 - 1))', 'uint8')';
                offset = offset + uint32(elements*1);
            end
        end
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Deserializing fixed-sized field imageEveryNthTrial
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Checking header
    if valid == uint8(0) || offset + uint32(32 + numel(namePrefix) - 1) > numel(in)
        valid = uint8(0);
    end
    expectedHeader_imageEveryNthTrial = uint8([2, 4, typecast(uint16(numel(namePrefix) + 18), 'uint8'), namePrefix, 'imageEveryNthTrial', typecast(uint16(6), 'uint8'), 'trials', 0, 1])';
    for headerOffset = 1:uint32(32+numel(namePrefix)-1)
        valid = uint8(valid && in(offset+headerOffset-1) == expectedHeader_imageEveryNthTrial(headerOffset));
    end
    offset = offset + uint32(32 + numel(namePrefix));

    % Establishing size
    if valid == uint8(0) || offset + uint32(2 - 1) > numel(in)
        % buffer not large enough for header
        valid = uint8(0);
        bus.imageEveryNthTrial = zeros([1 1], 'double');
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
            bus.imageEveryNthTrial = zeros([1 1], 'double');
        else
            % read and typecast data
            assert(elements <= uint32(1));
            bus.imageEveryNthTrial = zeros([1 1], 'double');
            if elements > uint32(0)
                bus.imageEveryNthTrial(1:elements) = typecast(in(offset:offset+uint32(elements*8 - 1))', 'double')';
                offset = offset + uint32(elements*8);
            end
        end
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Deserializing fixed-sized field autoTimeoutActive
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Checking header
    if valid == uint8(0) || offset + uint32(25 + numel(namePrefix) - 1) > numel(in)
        valid = uint8(0);
    end
    expectedHeader_autoTimeoutActive = uint8([2, 4, typecast(uint16(numel(namePrefix) + 17), 'uint8'), namePrefix, 'autoTimeoutActive', typecast(uint16(0), 'uint8'), '', 3, 1])';
    for headerOffset = 1:uint32(25+numel(namePrefix)-1)
        valid = uint8(valid && in(offset+headerOffset-1) == expectedHeader_autoTimeoutActive(headerOffset));
    end
    offset = offset + uint32(25 + numel(namePrefix));

    % Establishing size
    if valid == uint8(0) || offset + uint32(2 - 1) > numel(in)
        % buffer not large enough for header
        valid = uint8(0);
        bus.autoTimeoutActive = zeros([1 1], 'uint8');
    else
        sz = typecast(in(offset:(offset+uint32(2-1))), 'uint16')';
        offset = offset + uint32(2);
        % check size
        if sz(1) ~= uint16(1), valid = uint8(0); end
        elements = uint32(1);
        for i = 1:1
             elements = elements * uint32(sz(i));
        end
        if elements > uint32(0) && offset + uint32(elements*1 - 1) > numel(in)
            % buffer not large enough for data
            valid = uint8(0);
        end
        if valid && elements == uint32(0)
            % assigning empty value
            bus.autoTimeoutActive = zeros([1 1], 'uint8');
        else
            % read and typecast data
            assert(elements <= uint32(1));
            bus.autoTimeoutActive = zeros([1 1], 'uint8');
            if elements > uint32(0)
                bus.autoTimeoutActive(1:elements) = typecast(in(offset:offset+uint32(elements*1 - 1))', 'uint8')';
                offset = offset + uint32(elements*1);
            end
        end
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Deserializing fixed-sized field endTimeoutNow
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Checking header
    if valid == uint8(0) || offset + uint32(21 + numel(namePrefix) - 1) > numel(in)
        valid = uint8(0);
    end
    expectedHeader_endTimeoutNow = uint8([2, 5, typecast(uint16(numel(namePrefix) + 13), 'uint8'), namePrefix, 'endTimeoutNow', typecast(uint16(0), 'uint8'), '', 3, 1])';
    for headerOffset = 1:uint32(21+numel(namePrefix)-1)
        valid = uint8(valid && in(offset+headerOffset-1) == expectedHeader_endTimeoutNow(headerOffset));
    end
    offset = offset + uint32(21 + numel(namePrefix));

    % Establishing size
    if valid == uint8(0) || offset + uint32(2 - 1) > numel(in)
        % buffer not large enough for header
        valid = uint8(0);
        bus.endTimeoutNow = zeros([1 1], 'uint8');
    else
        sz = typecast(in(offset:(offset+uint32(2-1))), 'uint16')';
        offset = offset + uint32(2);
        % check size
        if sz(1) ~= uint16(1), valid = uint8(0); end
        elements = uint32(1);
        for i = 1:1
             elements = elements * uint32(sz(i));
        end
        if elements > uint32(0) && offset + uint32(elements*1 - 1) > numel(in)
            % buffer not large enough for data
            valid = uint8(0);
        end
        if valid && elements == uint32(0)
            % assigning empty value
            bus.endTimeoutNow = zeros([1 1], 'uint8');
        else
            % read and typecast data
            assert(elements <= uint32(1));
            bus.endTimeoutNow = zeros([1 1], 'uint8');
            if elements > uint32(0)
                bus.endTimeoutNow(1:elements) = typecast(in(offset:offset+uint32(elements*1 - 1))', 'uint8')';
                offset = offset + uint32(elements*1);
            end
        end
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Deserializing fixed-sized field giveFreeJuice
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Checking header
    if valid == uint8(0) || offset + uint32(21 + numel(namePrefix) - 1) > numel(in)
        valid = uint8(0);
    end
    expectedHeader_giveFreeJuice = uint8([2, 5, typecast(uint16(numel(namePrefix) + 13), 'uint8'), namePrefix, 'giveFreeJuice', typecast(uint16(0), 'uint8'), '', 3, 1])';
    for headerOffset = 1:uint32(21+numel(namePrefix)-1)
        valid = uint8(valid && in(offset+headerOffset-1) == expectedHeader_giveFreeJuice(headerOffset));
    end
    offset = offset + uint32(21 + numel(namePrefix));

    % Establishing size
    if valid == uint8(0) || offset + uint32(2 - 1) > numel(in)
        % buffer not large enough for header
        valid = uint8(0);
        bus.giveFreeJuice = zeros([1 1], 'uint8');
    else
        sz = typecast(in(offset:(offset+uint32(2-1))), 'uint16')';
        offset = offset + uint32(2);
        % check size
        if sz(1) ~= uint16(1), valid = uint8(0); end
        elements = uint32(1);
        for i = 1:1
             elements = elements * uint32(sz(i));
        end
        if elements > uint32(0) && offset + uint32(elements*1 - 1) > numel(in)
            % buffer not large enough for data
            valid = uint8(0);
        end
        if valid && elements == uint32(0)
            % assigning empty value
            bus.giveFreeJuice = zeros([1 1], 'uint8');
        else
            % read and typecast data
            assert(elements <= uint32(1));
            bus.giveFreeJuice = zeros([1 1], 'uint8');
            if elements > uint32(0)
                bus.giveFreeJuice(1:elements) = typecast(in(offset:offset+uint32(elements*1 - 1))', 'uint8')';
                offset = offset + uint32(elements*1);
            end
        end
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Deserializing fixed-sized field resetConditionBlock
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Checking header
    if valid == uint8(0) || offset + uint32(27 + numel(namePrefix) - 1) > numel(in)
        valid = uint8(0);
    end
    expectedHeader_resetConditionBlock = uint8([2, 5, typecast(uint16(numel(namePrefix) + 19), 'uint8'), namePrefix, 'resetConditionBlock', typecast(uint16(0), 'uint8'), '', 3, 1])';
    for headerOffset = 1:uint32(27+numel(namePrefix)-1)
        valid = uint8(valid && in(offset+headerOffset-1) == expectedHeader_resetConditionBlock(headerOffset));
    end
    offset = offset + uint32(27 + numel(namePrefix));

    % Establishing size
    if valid == uint8(0) || offset + uint32(2 - 1) > numel(in)
        % buffer not large enough for header
        valid = uint8(0);
        bus.resetConditionBlock = zeros([1 1], 'uint8');
    else
        sz = typecast(in(offset:(offset+uint32(2-1))), 'uint16')';
        offset = offset + uint32(2);
        % check size
        if sz(1) ~= uint16(1), valid = uint8(0); end
        elements = uint32(1);
        for i = 1:1
             elements = elements * uint32(sz(i));
        end
        if elements > uint32(0) && offset + uint32(elements*1 - 1) > numel(in)
            % buffer not large enough for data
            valid = uint8(0);
        end
        if valid && elements == uint32(0)
            % assigning empty value
            bus.resetConditionBlock = zeros([1 1], 'uint8');
        else
            % read and typecast data
            assert(elements <= uint32(1));
            bus.resetConditionBlock = zeros([1 1], 'uint8');
            if elements > uint32(0)
                bus.resetConditionBlock(1:elements) = typecast(in(offset:offset+uint32(elements*1 - 1))', 'uint8')';
                offset = offset + uint32(elements*1);
            end
        end
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Deserializing fixed-sized field flushJuice
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Checking header
    if valid == uint8(0) || offset + uint32(18 + numel(namePrefix) - 1) > numel(in)
        valid = uint8(0);
    end
    expectedHeader_flushJuice = uint8([2, 4, typecast(uint16(numel(namePrefix) + 10), 'uint8'), namePrefix, 'flushJuice', typecast(uint16(0), 'uint8'), '', 3, 1])';
    for headerOffset = 1:uint32(18+numel(namePrefix)-1)
        valid = uint8(valid && in(offset+headerOffset-1) == expectedHeader_flushJuice(headerOffset));
    end
    offset = offset + uint32(18 + numel(namePrefix));

    % Establishing size
    if valid == uint8(0) || offset + uint32(2 - 1) > numel(in)
        % buffer not large enough for header
        valid = uint8(0);
        bus.flushJuice = zeros([1 1], 'uint8');
    else
        sz = typecast(in(offset:(offset+uint32(2-1))), 'uint16')';
        offset = offset + uint32(2);
        % check size
        if sz(1) ~= uint16(1), valid = uint8(0); end
        elements = uint32(1);
        for i = 1:1
             elements = elements * uint32(sz(i));
        end
        if elements > uint32(0) && offset + uint32(elements*1 - 1) > numel(in)
            % buffer not large enough for data
            valid = uint8(0);
        end
        if valid && elements == uint32(0)
            % assigning empty value
            bus.flushJuice = zeros([1 1], 'uint8');
        else
            % read and typecast data
            assert(elements <= uint32(1));
            bus.flushJuice = zeros([1 1], 'uint8');
            if elements > uint32(0)
                bus.flushJuice(1:elements) = typecast(in(offset:offset+uint32(elements*1 - 1))', 'uint8')';
                offset = offset + uint32(elements*1);
            end
        end
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Deserializing fixed-sized field resetStats
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Checking header
    if valid == uint8(0) || offset + uint32(18 + numel(namePrefix) - 1) > numel(in)
        valid = uint8(0);
    end
    expectedHeader_resetStats = uint8([2, 4, typecast(uint16(numel(namePrefix) + 10), 'uint8'), namePrefix, 'resetStats', typecast(uint16(0), 'uint8'), '', 3, 1])';
    for headerOffset = 1:uint32(18+numel(namePrefix)-1)
        valid = uint8(valid && in(offset+headerOffset-1) == expectedHeader_resetStats(headerOffset));
    end
    offset = offset + uint32(18 + numel(namePrefix));

    % Establishing size
    if valid == uint8(0) || offset + uint32(2 - 1) > numel(in)
        % buffer not large enough for header
        valid = uint8(0);
        bus.resetStats = zeros([1 1], 'uint8');
    else
        sz = typecast(in(offset:(offset+uint32(2-1))), 'uint16')';
        offset = offset + uint32(2);
        % check size
        if sz(1) ~= uint16(1), valid = uint8(0); end
        elements = uint32(1);
        for i = 1:1
             elements = elements * uint32(sz(i));
        end
        if elements > uint32(0) && offset + uint32(elements*1 - 1) > numel(in)
            % buffer not large enough for data
            valid = uint8(0);
        end
        if valid && elements == uint32(0)
            % assigning empty value
            bus.resetStats = zeros([1 1], 'uint8');
        else
            % read and typecast data
            assert(elements <= uint32(1));
            bus.resetStats = zeros([1 1], 'uint8');
            if elements > uint32(0)
                bus.resetStats(1:elements) = typecast(in(offset:offset+uint32(elements*1 - 1))', 'uint8')';
                offset = offset + uint32(elements*1);
            end
        end
    end


end