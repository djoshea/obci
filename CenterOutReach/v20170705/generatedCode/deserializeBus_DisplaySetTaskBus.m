function [bus, valid, offset] = deserializeBus_DisplaySetTaskBus(input, offset, valid, namePrefix)
%#codegen
% DO NOT EDIT: Auto-generated by 
%   BusSerialize.writeDeserializeBusCode('DisplaySetTaskBus')

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

    bus = initializeBus_DisplaySetTaskBus();
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Deserializing fixed-sized field taskName
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Checking header
    if valid == uint8(0) || offset + uint32(20 + numel(namePrefix) - 1) > numel(in)
        valid = uint8(0);
    end
    expectedHeader_taskName = uint8([0, 4, typecast(uint16(numel(namePrefix) + 8), 'uint8'), namePrefix, 'taskName', typecast(uint16(4), 'uint8'), 'char', 8, 1])';
    for headerOffset = 1:uint32(20+numel(namePrefix)-1)
        valid = uint8(valid && in(offset+headerOffset-1) == expectedHeader_taskName(headerOffset));
    end
    offset = offset + uint32(20 + numel(namePrefix));

    % Establishing size
    if valid == uint8(0) || offset + uint32(2 - 1) > numel(in)
        % buffer not large enough for header
        valid = uint8(0);
        bus.taskName = zeros([18 1], 'uint8');
    else
        sz = typecast(in(offset:(offset+uint32(2-1))), 'uint16')';
        offset = offset + uint32(2);
        % check size
        if sz(1) ~= uint16(18), valid = uint8(0); end
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
            bus.taskName = zeros([18 1], 'uint8');
        else
            % read and typecast data
            assert(elements <= uint32(18));
            bus.taskName = zeros([18 1], 'uint8');
            if elements > uint32(0)
                bus.taskName(1:elements) = typecast(in(offset:offset+uint32(elements*1 - 1))', 'uint8')';
                offset = offset + uint32(elements*1);
            end
        end
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Deserializing fixed-sized field taskVersion
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Checking header
    if valid == uint8(0) || offset + uint32(19 + numel(namePrefix) - 1) > numel(in)
        valid = uint8(0);
    end
    expectedHeader_taskVersion = uint8([2, 4, typecast(uint16(numel(namePrefix) + 11), 'uint8'), namePrefix, 'taskVersion', typecast(uint16(0), 'uint8'), '', 7, 1])';
    for headerOffset = 1:uint32(19+numel(namePrefix)-1)
        valid = uint8(valid && in(offset+headerOffset-1) == expectedHeader_taskVersion(headerOffset));
    end
    offset = offset + uint32(19 + numel(namePrefix));

    % Establishing size
    if valid == uint8(0) || offset + uint32(2 - 1) > numel(in)
        % buffer not large enough for header
        valid = uint8(0);
        bus.taskVersion = zeros([1 1], 'uint32');
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
            bus.taskVersion = zeros([1 1], 'uint32');
        else
            % read and typecast data
            assert(elements <= uint32(1));
            bus.taskVersion = zeros([1 1], 'uint32');
            if elements > uint32(0)
                bus.taskVersion(1:elements) = typecast(in(offset:offset+uint32(elements*4 - 1))', 'uint32')';
                offset = offset + uint32(elements*4);
            end
        end
    end


end