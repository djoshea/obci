function [bus, valid, offset] = deserializeBusForMatlab_mOEGFrameInfoBus(input, offset, valid, namePrefix)
%#codegen
% DO NOT EDIT: Auto-generated by 
%   BusSerialize.writeDeserializeBusCode('mOEGFrameInfoBus')

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

    bus = initializeBus_mOEGFrameInfoBus();
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Deserializing fixed-sized field mOEGIsAcquiring
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Checking header
    if valid == uint8(0) || offset + uint32(23 + numel(namePrefix) - 1) > numel(in)
        valid = uint8(0);
    end
    expectedHeader_mOEGIsAcquiring = uint8([2, 5, typecast(uint16(numel(namePrefix) + 15), 'uint8'), namePrefix, 'mOEGIsAcquiring', typecast(uint16(0), 'uint8'), '', 3, 1])';
    for headerOffset = 1:uint32(23+numel(namePrefix)-1)
        valid = uint8(valid && in(offset+headerOffset-1) == expectedHeader_mOEGIsAcquiring(headerOffset));
    end
    offset = offset + uint32(23 + numel(namePrefix));

    % Establishing size
    if valid == uint8(0) || offset + uint32(2 - 1) > numel(in)
        % buffer not large enough for header
        valid = uint8(0);
        bus.mOEGIsAcquiring = zeros([1 1], 'uint8');
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
            bus.mOEGIsAcquiring = zeros([1 1], 'uint8');
        else
            % read and typecast data
            assert(elements <= uint32(1));
            bus.mOEGIsAcquiring = zeros([1 1], 'uint8');
            if elements > uint32(0)
                bus.mOEGIsAcquiring(1:elements) = typecast(in(offset:offset+uint32(elements*1 - 1))', 'uint8')';
                offset = offset + uint32(elements*1);
            end
        end
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Deserializing fixed-sized field mOEGFileNumber
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Checking header
    if valid == uint8(0) || offset + uint32(22 + numel(namePrefix) - 1) > numel(in)
        valid = uint8(0);
    end
    expectedHeader_mOEGFileNumber = uint8([2, 5, typecast(uint16(numel(namePrefix) + 14), 'uint8'), namePrefix, 'mOEGFileNumber', typecast(uint16(0), 'uint8'), '', 7, 1])';
    for headerOffset = 1:uint32(22+numel(namePrefix)-1)
        valid = uint8(valid && in(offset+headerOffset-1) == expectedHeader_mOEGFileNumber(headerOffset));
    end
    offset = offset + uint32(22 + numel(namePrefix));

    % Establishing size
    if valid == uint8(0) || offset + uint32(2 - 1) > numel(in)
        % buffer not large enough for header
        valid = uint8(0);
        bus.mOEGFileNumber = zeros([1 1], 'uint32');
    else
        sz = typecast(in(offset:(offset+uint32(2-1))), 'uint16')';
        offset = offset + uint32(2);
        % check size
        if sz(1) ~= uint16(1), valid = uint8(0); end
        elements = uint32(1);
        for i = 1:1
             elements = elements * uint32(sz(i));
        end
        if elements > uint32(0) && offset + uint32(elements*4 - 1) > numel(in)
            % buffer not large enough for data
            valid = uint8(0);
        end
        if valid && elements == uint32(0)
            % assigning empty value
            bus.mOEGFileNumber = zeros([1 1], 'uint32');
        else
            % read and typecast data
            assert(elements <= uint32(1));
            bus.mOEGFileNumber = zeros([1 1], 'uint32');
            if elements > uint32(0)
                bus.mOEGFileNumber(1:elements) = typecast(in(offset:offset+uint32(elements*4 - 1))', 'uint32')';
                offset = offset + uint32(elements*4);
            end
        end
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Deserializing fixed-sized field mOEGFrameNumber
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Checking header
    if valid == uint8(0) || offset + uint32(23 + numel(namePrefix) - 1) > numel(in)
        valid = uint8(0);
    end
    expectedHeader_mOEGFrameNumber = uint8([2, 5, typecast(uint16(numel(namePrefix) + 15), 'uint8'), namePrefix, 'mOEGFrameNumber', typecast(uint16(0), 'uint8'), '', 7, 1])';
    for headerOffset = 1:uint32(23+numel(namePrefix)-1)
        valid = uint8(valid && in(offset+headerOffset-1) == expectedHeader_mOEGFrameNumber(headerOffset));
    end
    offset = offset + uint32(23 + numel(namePrefix));

    % Establishing size
    if valid == uint8(0) || offset + uint32(2 - 1) > numel(in)
        % buffer not large enough for header
        valid = uint8(0);
        bus.mOEGFrameNumber = zeros([1 1], 'uint32');
    else
        sz = typecast(in(offset:(offset+uint32(2-1))), 'uint16')';
        offset = offset + uint32(2);
        % check size
        if sz(1) ~= uint16(1), valid = uint8(0); end
        elements = uint32(1);
        for i = 1:1
             elements = elements * uint32(sz(i));
        end
        if elements > uint32(0) && offset + uint32(elements*4 - 1) > numel(in)
            % buffer not large enough for data
            valid = uint8(0);
        end
        if valid && elements == uint32(0)
            % assigning empty value
            bus.mOEGFrameNumber = zeros([1 1], 'uint32');
        else
            % read and typecast data
            assert(elements <= uint32(1));
            bus.mOEGFrameNumber = zeros([1 1], 'uint32');
            if elements > uint32(0)
                bus.mOEGFrameNumber(1:elements) = typecast(in(offset:offset+uint32(elements*4 - 1))', 'uint32')';
                offset = offset + uint32(elements*4);
            end
        end
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Deserializing fixed-sized field mOEGLastFileFrameCount
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Checking header
    if valid == uint8(0) || offset + uint32(30 + numel(namePrefix) - 1) > numel(in)
        valid = uint8(0);
    end
    expectedHeader_mOEGLastFileFrameCount = uint8([2, 4, typecast(uint16(numel(namePrefix) + 22), 'uint8'), namePrefix, 'mOEGLastFileFrameCount', typecast(uint16(0), 'uint8'), '', 7, 1])';
    for headerOffset = 1:uint32(30+numel(namePrefix)-1)
        valid = uint8(valid && in(offset+headerOffset-1) == expectedHeader_mOEGLastFileFrameCount(headerOffset));
    end
    offset = offset + uint32(30 + numel(namePrefix));

    % Establishing size
    if valid == uint8(0) || offset + uint32(2 - 1) > numel(in)
        % buffer not large enough for header
        valid = uint8(0);
        bus.mOEGLastFileFrameCount = zeros([1 1], 'uint32');
    else
        sz = typecast(in(offset:(offset+uint32(2-1))), 'uint16')';
        offset = offset + uint32(2);
        % check size
        if sz(1) ~= uint16(1), valid = uint8(0); end
        elements = uint32(1);
        for i = 1:1
             elements = elements * uint32(sz(i));
        end
        if elements > uint32(0) && offset + uint32(elements*4 - 1) > numel(in)
            % buffer not large enough for data
            valid = uint8(0);
        end
        if valid && elements == uint32(0)
            % assigning empty value
            bus.mOEGLastFileFrameCount = zeros([1 1], 'uint32');
        else
            % read and typecast data
            assert(elements <= uint32(1));
            bus.mOEGLastFileFrameCount = zeros([1 1], 'uint32');
            if elements > uint32(0)
                bus.mOEGLastFileFrameCount(1:elements) = typecast(in(offset:offset+uint32(elements*4 - 1))', 'uint32')';
                offset = offset + uint32(elements*4);
            end
        end
    end


end