function [bus, valid, offset] = deserializeBus_PolarisInputBus(input, offset, valid, namePrefix)
%#codegen
% DO NOT EDIT: Auto-generated by 
%   BusSerialize.writeDeserializeBusCode('PolarisInputBus')

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

    bus = initializeBus_PolarisInputBus();
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Deserializing fixed-sized field update
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Checking header
    if valid == uint8(0) || offset + uint32(14 + numel(namePrefix) - 1) > numel(in)
        valid = uint8(0);
    end
    expectedHeader_update = uint8([2, 5, typecast(uint16(numel(namePrefix) + 6), 'uint8'), namePrefix, 'update', typecast(uint16(0), 'uint8'), '', 3, 1])';
    for headerOffset = 1:uint32(14+numel(namePrefix)-1)
        valid = uint8(valid && in(offset+headerOffset-1) == expectedHeader_update(headerOffset));
    end
    offset = offset + uint32(14 + numel(namePrefix));

    % Establishing size
    if valid == uint8(0) || offset + uint32(2 - 1) > numel(in)
        % buffer not large enough for header
        valid = uint8(0);
        bus.update = zeros([1 1], 'uint8');
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
            bus.update = zeros([1 1], 'uint8');
        else
            % read and typecast data
            assert(elements <= uint32(1));
            bus.update = zeros([1 1], 'uint8');
            if elements > uint32(0)
                bus.update(1:elements) = typecast(in(offset:offset+uint32(elements*1 - 1))', 'uint8')';
                offset = offset + uint32(elements*1);
            end
        end
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Deserializing fixed-sized field markerSeen
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Checking header
    if valid == uint8(0) || offset + uint32(18 + numel(namePrefix) - 1) > numel(in)
        valid = uint8(0);
    end
    expectedHeader_markerSeen = uint8([2, 5, typecast(uint16(numel(namePrefix) + 10), 'uint8'), namePrefix, 'markerSeen', typecast(uint16(0), 'uint8'), '', 3, 1])';
    for headerOffset = 1:uint32(18+numel(namePrefix)-1)
        valid = uint8(valid && in(offset+headerOffset-1) == expectedHeader_markerSeen(headerOffset));
    end
    offset = offset + uint32(18 + numel(namePrefix));

    % Establishing size
    if valid == uint8(0) || offset + uint32(2 - 1) > numel(in)
        % buffer not large enough for header
        valid = uint8(0);
        bus.markerSeen = zeros([1 1], 'uint8');
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
            bus.markerSeen = zeros([1 1], 'uint8');
        else
            % read and typecast data
            assert(elements <= uint32(1));
            bus.markerSeen = zeros([1 1], 'uint8');
            if elements > uint32(0)
                bus.markerSeen(1:elements) = typecast(in(offset:offset+uint32(elements*1 - 1))', 'uint8')';
                offset = offset + uint32(elements*1);
            end
        end
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Deserializing fixed-sized field touchingScreen
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Checking header
    if valid == uint8(0) || offset + uint32(22 + numel(namePrefix) - 1) > numel(in)
        valid = uint8(0);
    end
    expectedHeader_touchingScreen = uint8([2, 5, typecast(uint16(numel(namePrefix) + 14), 'uint8'), namePrefix, 'touchingScreen', typecast(uint16(0), 'uint8'), '', 3, 1])';
    for headerOffset = 1:uint32(22+numel(namePrefix)-1)
        valid = uint8(valid && in(offset+headerOffset-1) == expectedHeader_touchingScreen(headerOffset));
    end
    offset = offset + uint32(22 + numel(namePrefix));

    % Establishing size
    if valid == uint8(0) || offset + uint32(2 - 1) > numel(in)
        % buffer not large enough for header
        valid = uint8(0);
        bus.touchingScreen = zeros([1 1], 'uint8');
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
            bus.touchingScreen = zeros([1 1], 'uint8');
        else
            % read and typecast data
            assert(elements <= uint32(1));
            bus.touchingScreen = zeros([1 1], 'uint8');
            if elements > uint32(0)
                bus.touchingScreen(1:elements) = typecast(in(offset:offset+uint32(elements*1 - 1))', 'uint8')';
                offset = offset + uint32(elements*1);
            end
        end
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Deserializing fixed-sized field markerX
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Checking header
    if valid == uint8(0) || offset + uint32(17 + numel(namePrefix) - 1) > numel(in)
        valid = uint8(0);
    end
    expectedHeader_markerX = uint8([2, 5, typecast(uint16(numel(namePrefix) + 7), 'uint8'), namePrefix, 'markerX', typecast(uint16(2), 'uint8'), 'mm', 0, 1])';
    for headerOffset = 1:uint32(17+numel(namePrefix)-1)
        valid = uint8(valid && in(offset+headerOffset-1) == expectedHeader_markerX(headerOffset));
    end
    offset = offset + uint32(17 + numel(namePrefix));

    % Establishing size
    if valid == uint8(0) || offset + uint32(2 - 1) > numel(in)
        % buffer not large enough for header
        valid = uint8(0);
        bus.markerX = zeros([1 1], 'double');
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
            bus.markerX = zeros([1 1], 'double');
        else
            % read and typecast data
            assert(elements <= uint32(1));
            bus.markerX = zeros([1 1], 'double');
            if elements > uint32(0)
                bus.markerX(1:elements) = typecast(in(offset:offset+uint32(elements*8 - 1))', 'double')';
                offset = offset + uint32(elements*8);
            end
        end
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Deserializing fixed-sized field markerY
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Checking header
    if valid == uint8(0) || offset + uint32(17 + numel(namePrefix) - 1) > numel(in)
        valid = uint8(0);
    end
    expectedHeader_markerY = uint8([2, 5, typecast(uint16(numel(namePrefix) + 7), 'uint8'), namePrefix, 'markerY', typecast(uint16(2), 'uint8'), 'mm', 0, 1])';
    for headerOffset = 1:uint32(17+numel(namePrefix)-1)
        valid = uint8(valid && in(offset+headerOffset-1) == expectedHeader_markerY(headerOffset));
    end
    offset = offset + uint32(17 + numel(namePrefix));

    % Establishing size
    if valid == uint8(0) || offset + uint32(2 - 1) > numel(in)
        % buffer not large enough for header
        valid = uint8(0);
        bus.markerY = zeros([1 1], 'double');
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
            bus.markerY = zeros([1 1], 'double');
        else
            % read and typecast data
            assert(elements <= uint32(1));
            bus.markerY = zeros([1 1], 'double');
            if elements > uint32(0)
                bus.markerY(1:elements) = typecast(in(offset:offset+uint32(elements*8 - 1))', 'double')';
                offset = offset + uint32(elements*8);
            end
        end
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Deserializing fixed-sized field markerZ
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Checking header
    if valid == uint8(0) || offset + uint32(17 + numel(namePrefix) - 1) > numel(in)
        valid = uint8(0);
    end
    expectedHeader_markerZ = uint8([2, 5, typecast(uint16(numel(namePrefix) + 7), 'uint8'), namePrefix, 'markerZ', typecast(uint16(2), 'uint8'), 'mm', 0, 1])';
    for headerOffset = 1:uint32(17+numel(namePrefix)-1)
        valid = uint8(valid && in(offset+headerOffset-1) == expectedHeader_markerZ(headerOffset));
    end
    offset = offset + uint32(17 + numel(namePrefix));

    % Establishing size
    if valid == uint8(0) || offset + uint32(2 - 1) > numel(in)
        % buffer not large enough for header
        valid = uint8(0);
        bus.markerZ = zeros([1 1], 'double');
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
            bus.markerZ = zeros([1 1], 'double');
        else
            % read and typecast data
            assert(elements <= uint32(1));
            bus.markerZ = zeros([1 1], 'double');
            if elements > uint32(0)
                bus.markerZ(1:elements) = typecast(in(offset:offset+uint32(elements*8 - 1))', 'double')';
                offset = offset + uint32(elements*8);
            end
        end
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Deserializing fixed-sized field markerVelX
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Checking header
    if valid == uint8(0) || offset + uint32(22 + numel(namePrefix) - 1) > numel(in)
        valid = uint8(0);
    end
    expectedHeader_markerVelX = uint8([2, 5, typecast(uint16(numel(namePrefix) + 10), 'uint8'), namePrefix, 'markerVelX', typecast(uint16(4), 'uint8'), 'mm/s', 0, 1])';
    for headerOffset = 1:uint32(22+numel(namePrefix)-1)
        valid = uint8(valid && in(offset+headerOffset-1) == expectedHeader_markerVelX(headerOffset));
    end
    offset = offset + uint32(22 + numel(namePrefix));

    % Establishing size
    if valid == uint8(0) || offset + uint32(2 - 1) > numel(in)
        % buffer not large enough for header
        valid = uint8(0);
        bus.markerVelX = zeros([1 1], 'double');
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
            bus.markerVelX = zeros([1 1], 'double');
        else
            % read and typecast data
            assert(elements <= uint32(1));
            bus.markerVelX = zeros([1 1], 'double');
            if elements > uint32(0)
                bus.markerVelX(1:elements) = typecast(in(offset:offset+uint32(elements*8 - 1))', 'double')';
                offset = offset + uint32(elements*8);
            end
        end
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Deserializing fixed-sized field markerVelY
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Checking header
    if valid == uint8(0) || offset + uint32(22 + numel(namePrefix) - 1) > numel(in)
        valid = uint8(0);
    end
    expectedHeader_markerVelY = uint8([2, 5, typecast(uint16(numel(namePrefix) + 10), 'uint8'), namePrefix, 'markerVelY', typecast(uint16(4), 'uint8'), 'mm/s', 0, 1])';
    for headerOffset = 1:uint32(22+numel(namePrefix)-1)
        valid = uint8(valid && in(offset+headerOffset-1) == expectedHeader_markerVelY(headerOffset));
    end
    offset = offset + uint32(22 + numel(namePrefix));

    % Establishing size
    if valid == uint8(0) || offset + uint32(2 - 1) > numel(in)
        % buffer not large enough for header
        valid = uint8(0);
        bus.markerVelY = zeros([1 1], 'double');
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
            bus.markerVelY = zeros([1 1], 'double');
        else
            % read and typecast data
            assert(elements <= uint32(1));
            bus.markerVelY = zeros([1 1], 'double');
            if elements > uint32(0)
                bus.markerVelY(1:elements) = typecast(in(offset:offset+uint32(elements*8 - 1))', 'double')';
                offset = offset + uint32(elements*8);
            end
        end
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Deserializing fixed-sized field markerVelZ
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Checking header
    if valid == uint8(0) || offset + uint32(22 + numel(namePrefix) - 1) > numel(in)
        valid = uint8(0);
    end
    expectedHeader_markerVelZ = uint8([2, 5, typecast(uint16(numel(namePrefix) + 10), 'uint8'), namePrefix, 'markerVelZ', typecast(uint16(4), 'uint8'), 'mm/s', 0, 1])';
    for headerOffset = 1:uint32(22+numel(namePrefix)-1)
        valid = uint8(valid && in(offset+headerOffset-1) == expectedHeader_markerVelZ(headerOffset));
    end
    offset = offset + uint32(22 + numel(namePrefix));

    % Establishing size
    if valid == uint8(0) || offset + uint32(2 - 1) > numel(in)
        % buffer not large enough for header
        valid = uint8(0);
        bus.markerVelZ = zeros([1 1], 'double');
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
            bus.markerVelZ = zeros([1 1], 'double');
        else
            % read and typecast data
            assert(elements <= uint32(1));
            bus.markerVelZ = zeros([1 1], 'double');
            if elements > uint32(0)
                bus.markerVelZ(1:elements) = typecast(in(offset:offset+uint32(elements*8 - 1))', 'double')';
                offset = offset + uint32(elements*8);
            end
        end
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Deserializing fixed-sized field numMakersInVolume
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Checking header
    if valid == uint8(0) || offset + uint32(32 + numel(namePrefix) - 1) > numel(in)
        valid = uint8(0);
    end
    expectedHeader_numMakersInVolume = uint8([2, 5, typecast(uint16(numel(namePrefix) + 17), 'uint8'), namePrefix, 'numMakersInVolume', typecast(uint16(7), 'uint8'), 'markers', 3, 1])';
    for headerOffset = 1:uint32(32+numel(namePrefix)-1)
        valid = uint8(valid && in(offset+headerOffset-1) == expectedHeader_numMakersInVolume(headerOffset));
    end
    offset = offset + uint32(32 + numel(namePrefix));

    % Establishing size
    if valid == uint8(0) || offset + uint32(2 - 1) > numel(in)
        % buffer not large enough for header
        valid = uint8(0);
        bus.numMakersInVolume = zeros([1 1], 'uint8');
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
            bus.numMakersInVolume = zeros([1 1], 'uint8');
        else
            % read and typecast data
            assert(elements <= uint32(1));
            bus.numMakersInVolume = zeros([1 1], 'uint8');
            if elements > uint32(0)
                bus.numMakersInVolume(1:elements) = typecast(in(offset:offset+uint32(elements*1 - 1))', 'uint8')';
                offset = offset + uint32(elements*1);
            end
        end
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Deserializing fixed-sized field numReflections
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Checking header
    if valid == uint8(0) || offset + uint32(29 + numel(namePrefix) - 1) > numel(in)
        valid = uint8(0);
    end
    expectedHeader_numReflections = uint8([2, 5, typecast(uint16(numel(namePrefix) + 14), 'uint8'), namePrefix, 'numReflections', typecast(uint16(7), 'uint8'), 'markers', 3, 1])';
    for headerOffset = 1:uint32(29+numel(namePrefix)-1)
        valid = uint8(valid && in(offset+headerOffset-1) == expectedHeader_numReflections(headerOffset));
    end
    offset = offset + uint32(29 + numel(namePrefix));

    % Establishing size
    if valid == uint8(0) || offset + uint32(2 - 1) > numel(in)
        % buffer not large enough for header
        valid = uint8(0);
        bus.numReflections = zeros([1 1], 'uint8');
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
            bus.numReflections = zeros([1 1], 'uint8');
        else
            % read and typecast data
            assert(elements <= uint32(1));
            bus.numReflections = zeros([1 1], 'uint8');
            if elements > uint32(0)
                bus.numReflections(1:elements) = typecast(in(offset:offset+uint32(elements*1 - 1))', 'uint8')';
                offset = offset + uint32(elements*1);
            end
        end
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Deserializing fixed-sized field numMarkersOutOfVolume
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Checking header
    if valid == uint8(0) || offset + uint32(36 + numel(namePrefix) - 1) > numel(in)
        valid = uint8(0);
    end
    expectedHeader_numMarkersOutOfVolume = uint8([2, 5, typecast(uint16(numel(namePrefix) + 21), 'uint8'), namePrefix, 'numMarkersOutOfVolume', typecast(uint16(7), 'uint8'), 'markers', 3, 1])';
    for headerOffset = 1:uint32(36+numel(namePrefix)-1)
        valid = uint8(valid && in(offset+headerOffset-1) == expectedHeader_numMarkersOutOfVolume(headerOffset));
    end
    offset = offset + uint32(36 + numel(namePrefix));

    % Establishing size
    if valid == uint8(0) || offset + uint32(2 - 1) > numel(in)
        % buffer not large enough for header
        valid = uint8(0);
        bus.numMarkersOutOfVolume = zeros([1 1], 'uint8');
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
            bus.numMarkersOutOfVolume = zeros([1 1], 'uint8');
        else
            % read and typecast data
            assert(elements <= uint32(1));
            bus.numMarkersOutOfVolume = zeros([1 1], 'uint8');
            if elements > uint32(0)
                bus.numMarkersOutOfVolume(1:elements) = typecast(in(offset:offset+uint32(elements*1 - 1))', 'uint8')';
                offset = offset + uint32(elements*1);
            end
        end
    end


end