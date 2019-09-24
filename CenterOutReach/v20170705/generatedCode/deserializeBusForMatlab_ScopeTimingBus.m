function [bus, valid, offset] = deserializeBusForMatlab_ScopeTimingBus(input, offset, valid, namePrefix)
%#codegen
% DO NOT EDIT: Auto-generated by 
%   BusSerialize.writeDeserializeBusCode('ScopeTimingBus')

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

    bus = initializeBus_ScopeTimingBus();
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Deserializing fixed-sized field startFrameGalvoAnalog
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Checking header
    if valid == uint8(0) || offset + uint32(30 + numel(namePrefix) - 1) > numel(in)
        valid = uint8(0);
    end
    expectedHeader_startFrameGalvoAnalog = uint8([2, 5, typecast(uint16(numel(namePrefix) + 21), 'uint8'), namePrefix, 'startFrameGalvoAnalog', typecast(uint16(1), 'uint8'), 'V', 0, 1])';
    for headerOffset = 1:uint32(30+numel(namePrefix)-1)
        valid = uint8(valid && in(offset+headerOffset-1) == expectedHeader_startFrameGalvoAnalog(headerOffset));
    end
    offset = offset + uint32(30 + numel(namePrefix));

    % Establishing size
    if valid == uint8(0) || offset + uint32(2 - 1) > numel(in)
        % buffer not large enough for header
        valid = uint8(0);
        bus.startFrameGalvoAnalog = zeros([1 1], 'double');
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
            bus.startFrameGalvoAnalog = zeros([1 1], 'double');
        else
            % read and typecast data
            assert(elements <= uint32(1));
            bus.startFrameGalvoAnalog = zeros([1 1], 'double');
            if elements > uint32(0)
                bus.startFrameGalvoAnalog(1:elements) = typecast(in(offset:offset+uint32(elements*8 - 1))', 'double')';
                offset = offset + uint32(elements*8);
            end
        end
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Deserializing fixed-sized field endFrameGalvoAnalog
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Checking header
    if valid == uint8(0) || offset + uint32(28 + numel(namePrefix) - 1) > numel(in)
        valid = uint8(0);
    end
    expectedHeader_endFrameGalvoAnalog = uint8([2, 5, typecast(uint16(numel(namePrefix) + 19), 'uint8'), namePrefix, 'endFrameGalvoAnalog', typecast(uint16(1), 'uint8'), 'V', 0, 1])';
    for headerOffset = 1:uint32(28+numel(namePrefix)-1)
        valid = uint8(valid && in(offset+headerOffset-1) == expectedHeader_endFrameGalvoAnalog(headerOffset));
    end
    offset = offset + uint32(28 + numel(namePrefix));

    % Establishing size
    if valid == uint8(0) || offset + uint32(2 - 1) > numel(in)
        % buffer not large enough for header
        valid = uint8(0);
        bus.endFrameGalvoAnalog = zeros([1 1], 'double');
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
            bus.endFrameGalvoAnalog = zeros([1 1], 'double');
        else
            % read and typecast data
            assert(elements <= uint32(1));
            bus.endFrameGalvoAnalog = zeros([1 1], 'double');
            if elements > uint32(0)
                bus.endFrameGalvoAnalog(1:elements) = typecast(in(offset:offset+uint32(elements*8 - 1))', 'double')';
                offset = offset + uint32(elements*8);
            end
        end
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Deserializing fixed-sized field startFrameResonantAnalog
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Checking header
    if valid == uint8(0) || offset + uint32(33 + numel(namePrefix) - 1) > numel(in)
        valid = uint8(0);
    end
    expectedHeader_startFrameResonantAnalog = uint8([2, 5, typecast(uint16(numel(namePrefix) + 24), 'uint8'), namePrefix, 'startFrameResonantAnalog', typecast(uint16(1), 'uint8'), 'V', 0, 1])';
    for headerOffset = 1:uint32(33+numel(namePrefix)-1)
        valid = uint8(valid && in(offset+headerOffset-1) == expectedHeader_startFrameResonantAnalog(headerOffset));
    end
    offset = offset + uint32(33 + numel(namePrefix));

    % Establishing size
    if valid == uint8(0) || offset + uint32(2 - 1) > numel(in)
        % buffer not large enough for header
        valid = uint8(0);
        bus.startFrameResonantAnalog = zeros([1 1], 'double');
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
            bus.startFrameResonantAnalog = zeros([1 1], 'double');
        else
            % read and typecast data
            assert(elements <= uint32(1));
            bus.startFrameResonantAnalog = zeros([1 1], 'double');
            if elements > uint32(0)
                bus.startFrameResonantAnalog(1:elements) = typecast(in(offset:offset+uint32(elements*8 - 1))', 'double')';
                offset = offset + uint32(elements*8);
            end
        end
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Deserializing fixed-sized field endFrameResonantAnalog
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Checking header
    if valid == uint8(0) || offset + uint32(31 + numel(namePrefix) - 1) > numel(in)
        valid = uint8(0);
    end
    expectedHeader_endFrameResonantAnalog = uint8([2, 5, typecast(uint16(numel(namePrefix) + 22), 'uint8'), namePrefix, 'endFrameResonantAnalog', typecast(uint16(1), 'uint8'), 'V', 0, 1])';
    for headerOffset = 1:uint32(31+numel(namePrefix)-1)
        valid = uint8(valid && in(offset+headerOffset-1) == expectedHeader_endFrameResonantAnalog(headerOffset));
    end
    offset = offset + uint32(31 + numel(namePrefix));

    % Establishing size
    if valid == uint8(0) || offset + uint32(2 - 1) > numel(in)
        % buffer not large enough for header
        valid = uint8(0);
        bus.endFrameResonantAnalog = zeros([1 1], 'double');
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
            bus.endFrameResonantAnalog = zeros([1 1], 'double');
        else
            % read and typecast data
            assert(elements <= uint32(1));
            bus.endFrameResonantAnalog = zeros([1 1], 'double');
            if elements > uint32(0)
                bus.endFrameResonantAnalog(1:elements) = typecast(in(offset:offset+uint32(elements*8 - 1))', 'double')';
                offset = offset + uint32(elements*8);
            end
        end
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Deserializing fixed-sized field cameraFrameEndAnalog
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Checking header
    if valid == uint8(0) || offset + uint32(29 + numel(namePrefix) - 1) > numel(in)
        valid = uint8(0);
    end
    expectedHeader_cameraFrameEndAnalog = uint8([2, 5, typecast(uint16(numel(namePrefix) + 20), 'uint8'), namePrefix, 'cameraFrameEndAnalog', typecast(uint16(1), 'uint8'), 'V', 0, 1])';
    for headerOffset = 1:uint32(29+numel(namePrefix)-1)
        valid = uint8(valid && in(offset+headerOffset-1) == expectedHeader_cameraFrameEndAnalog(headerOffset));
    end
    offset = offset + uint32(29 + numel(namePrefix));

    % Establishing size
    if valid == uint8(0) || offset + uint32(2 - 1) > numel(in)
        % buffer not large enough for header
        valid = uint8(0);
        bus.cameraFrameEndAnalog = zeros([1 1], 'double');
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
            bus.cameraFrameEndAnalog = zeros([1 1], 'double');
        else
            % read and typecast data
            assert(elements <= uint32(1));
            bus.cameraFrameEndAnalog = zeros([1 1], 'double');
            if elements > uint32(0)
                bus.cameraFrameEndAnalog(1:elements) = typecast(in(offset:offset+uint32(elements*8 - 1))', 'double')';
                offset = offset + uint32(elements*8);
            end
        end
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Deserializing fixed-sized field cameraFrameEnd
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Checking header
    if valid == uint8(0) || offset + uint32(22 + numel(namePrefix) - 1) > numel(in)
        valid = uint8(0);
    end
    expectedHeader_cameraFrameEnd = uint8([2, 5, typecast(uint16(numel(namePrefix) + 14), 'uint8'), namePrefix, 'cameraFrameEnd', typecast(uint16(0), 'uint8'), '', 3, 1])';
    for headerOffset = 1:uint32(22+numel(namePrefix)-1)
        valid = uint8(valid && in(offset+headerOffset-1) == expectedHeader_cameraFrameEnd(headerOffset));
    end
    offset = offset + uint32(22 + numel(namePrefix));

    % Establishing size
    if valid == uint8(0) || offset + uint32(2 - 1) > numel(in)
        % buffer not large enough for header
        valid = uint8(0);
        bus.cameraFrameEnd = zeros([1 1], 'uint8');
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
            bus.cameraFrameEnd = zeros([1 1], 'uint8');
        else
            % read and typecast data
            assert(elements <= uint32(1));
            bus.cameraFrameEnd = zeros([1 1], 'uint8');
            if elements > uint32(0)
                bus.cameraFrameEnd(1:elements) = typecast(in(offset:offset+uint32(elements*1 - 1))', 'uint8')';
                offset = offset + uint32(elements*1);
            end
        end
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Deserializing fixed-sized field cameraFrameExposure
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Checking header
    if valid == uint8(0) || offset + uint32(27 + numel(namePrefix) - 1) > numel(in)
        valid = uint8(0);
    end
    expectedHeader_cameraFrameExposure = uint8([2, 5, typecast(uint16(numel(namePrefix) + 19), 'uint8'), namePrefix, 'cameraFrameExposure', typecast(uint16(0), 'uint8'), '', 3, 1])';
    for headerOffset = 1:uint32(27+numel(namePrefix)-1)
        valid = uint8(valid && in(offset+headerOffset-1) == expectedHeader_cameraFrameExposure(headerOffset));
    end
    offset = offset + uint32(27 + numel(namePrefix));

    % Establishing size
    if valid == uint8(0) || offset + uint32(2 - 1) > numel(in)
        % buffer not large enough for header
        valid = uint8(0);
        bus.cameraFrameExposure = zeros([1 1], 'uint8');
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
            bus.cameraFrameExposure = zeros([1 1], 'uint8');
        else
            % read and typecast data
            assert(elements <= uint32(1));
            bus.cameraFrameExposure = zeros([1 1], 'uint8');
            if elements > uint32(0)
                bus.cameraFrameExposure(1:elements) = typecast(in(offset:offset+uint32(elements*1 - 1))', 'uint8')';
                offset = offset + uint32(elements*1);
            end
        end
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Deserializing fixed-sized field led470Active
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Checking header
    if valid == uint8(0) || offset + uint32(20 + numel(namePrefix) - 1) > numel(in)
        valid = uint8(0);
    end
    expectedHeader_led470Active = uint8([2, 5, typecast(uint16(numel(namePrefix) + 12), 'uint8'), namePrefix, 'led470Active', typecast(uint16(0), 'uint8'), '', 3, 1])';
    for headerOffset = 1:uint32(20+numel(namePrefix)-1)
        valid = uint8(valid && in(offset+headerOffset-1) == expectedHeader_led470Active(headerOffset));
    end
    offset = offset + uint32(20 + numel(namePrefix));

    % Establishing size
    if valid == uint8(0) || offset + uint32(2 - 1) > numel(in)
        % buffer not large enough for header
        valid = uint8(0);
        bus.led470Active = zeros([1 1], 'uint8');
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
            bus.led470Active = zeros([1 1], 'uint8');
        else
            % read and typecast data
            assert(elements <= uint32(1));
            bus.led470Active = zeros([1 1], 'uint8');
            if elements > uint32(0)
                bus.led470Active(1:elements) = typecast(in(offset:offset+uint32(elements*1 - 1))', 'uint8')';
                offset = offset + uint32(elements*1);
            end
        end
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Deserializing fixed-sized field led405Active
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Checking header
    if valid == uint8(0) || offset + uint32(20 + numel(namePrefix) - 1) > numel(in)
        valid = uint8(0);
    end
    expectedHeader_led405Active = uint8([2, 5, typecast(uint16(numel(namePrefix) + 12), 'uint8'), namePrefix, 'led405Active', typecast(uint16(0), 'uint8'), '', 3, 1])';
    for headerOffset = 1:uint32(20+numel(namePrefix)-1)
        valid = uint8(valid && in(offset+headerOffset-1) == expectedHeader_led405Active(headerOffset));
    end
    offset = offset + uint32(20 + numel(namePrefix));

    % Establishing size
    if valid == uint8(0) || offset + uint32(2 - 1) > numel(in)
        % buffer not large enough for header
        valid = uint8(0);
        bus.led405Active = zeros([1 1], 'uint8');
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
            bus.led405Active = zeros([1 1], 'uint8');
        else
            % read and typecast data
            assert(elements <= uint32(1));
            bus.led405Active = zeros([1 1], 'uint8');
            if elements > uint32(0)
                bus.led405Active(1:elements) = typecast(in(offset:offset+uint32(elements*1 - 1))', 'uint8')';
                offset = offset + uint32(elements*1);
            end
        end
    end


end