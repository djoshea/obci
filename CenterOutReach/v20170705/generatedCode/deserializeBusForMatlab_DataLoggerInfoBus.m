function [bus, valid, offset] = deserializeBusForMatlab_DataLoggerInfoBus(input, offset, valid, namePrefix)
%#codegen
% DO NOT EDIT: Auto-generated by 
%   BusSerialize.writeDeserializeBusCode('DataLoggerInfoBus')

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

    bus = initializeBus_DataLoggerInfoBus();
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Deserializing variable-sized field dataStore
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Checking header
    if valid == uint8(0) || offset + uint32(21 + numel(namePrefix) - 1) > numel(in)
        valid = uint8(0);
    end
    expectedHeader_dataStore = uint8([1, 4, typecast(uint16(numel(namePrefix) + 9), 'uint8'), namePrefix, 'dataStore', typecast(uint16(4), 'uint8'), 'char', 8, 1])';
    for headerOffset = 1:uint32(21+numel(namePrefix)-1)
        valid = uint8(valid && in(offset+headerOffset-1) == expectedHeader_dataStore(headerOffset));
    end
    offset = offset + uint32(21 + numel(namePrefix));

    % Establishing size
    coder.varsize('bus.dataStore', 30);
    if valid == uint8(0) || offset + uint32(2 - 1) > numel(in)
        % buffer not large enough for header
        valid = uint8(0);
        bus.dataStore = zeros([30 1], 'uint8');
    else
        sz = typecast(in(offset:(offset+uint32(2-1))), 'uint16')';
        offset = offset + uint32(2);
        % check size
        if sz(1) > uint16(30), valid = uint8(0); end
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
            bus.dataStore = zeros([0 1], 'uint8');
        else
            % mollify codegen
            assert(sz(1) <= uint16(30));
            % read and typecast data
            assert(elements <= uint32(30));
            bus.dataStore = zeros([sz uint16(1)], 'uint8');
            bus.dataStore = char(bus.dataStore);
            if isempty(bus.dataStore), bus.dataStore = ''; end
            if elements > uint32(0)
                bus.dataStore = char(in(offset:offset+uint32(elements*1 - 1)));
                if size(bus.dataStore, 1) > size(bus.dataStore, 2) && size(bus.dataStore, 2) == 1, bus.dataStore = bus.dataStore'; end
                offset = offset + uint32(elements*1);
            end
        end
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Deserializing variable-sized field subject
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Checking header
    if valid == uint8(0) || offset + uint32(19 + numel(namePrefix) - 1) > numel(in)
        valid = uint8(0);
    end
    expectedHeader_subject = uint8([1, 4, typecast(uint16(numel(namePrefix) + 7), 'uint8'), namePrefix, 'subject', typecast(uint16(4), 'uint8'), 'char', 8, 1])';
    for headerOffset = 1:uint32(19+numel(namePrefix)-1)
        valid = uint8(valid && in(offset+headerOffset-1) == expectedHeader_subject(headerOffset));
    end
    offset = offset + uint32(19 + numel(namePrefix));

    % Establishing size
    coder.varsize('bus.subject', 30);
    if valid == uint8(0) || offset + uint32(2 - 1) > numel(in)
        % buffer not large enough for header
        valid = uint8(0);
        bus.subject = zeros([30 1], 'uint8');
    else
        sz = typecast(in(offset:(offset+uint32(2-1))), 'uint16')';
        offset = offset + uint32(2);
        % check size
        if sz(1) > uint16(30), valid = uint8(0); end
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
            bus.subject = zeros([0 1], 'uint8');
        else
            % mollify codegen
            assert(sz(1) <= uint16(30));
            % read and typecast data
            assert(elements <= uint32(30));
            bus.subject = zeros([sz uint16(1)], 'uint8');
            bus.subject = char(bus.subject);
            if isempty(bus.subject), bus.subject = ''; end
            if elements > uint32(0)
                bus.subject = char(in(offset:offset+uint32(elements*1 - 1)));
                if size(bus.subject, 1) > size(bus.subject, 2) && size(bus.subject, 2) == 1, bus.subject = bus.subject'; end
                offset = offset + uint32(elements*1);
            end
        end
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Deserializing variable-sized field protocol
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Checking header
    if valid == uint8(0) || offset + uint32(20 + numel(namePrefix) - 1) > numel(in)
        valid = uint8(0);
    end
    expectedHeader_protocol = uint8([1, 4, typecast(uint16(numel(namePrefix) + 8), 'uint8'), namePrefix, 'protocol', typecast(uint16(4), 'uint8'), 'char', 8, 1])';
    for headerOffset = 1:uint32(20+numel(namePrefix)-1)
        valid = uint8(valid && in(offset+headerOffset-1) == expectedHeader_protocol(headerOffset));
    end
    offset = offset + uint32(20 + numel(namePrefix));

    % Establishing size
    coder.varsize('bus.protocol', 30);
    if valid == uint8(0) || offset + uint32(2 - 1) > numel(in)
        % buffer not large enough for header
        valid = uint8(0);
        bus.protocol = zeros([30 1], 'uint8');
    else
        sz = typecast(in(offset:(offset+uint32(2-1))), 'uint16')';
        offset = offset + uint32(2);
        % check size
        if sz(1) > uint16(30), valid = uint8(0); end
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
            bus.protocol = zeros([0 1], 'uint8');
        else
            % mollify codegen
            assert(sz(1) <= uint16(30));
            % read and typecast data
            assert(elements <= uint32(30));
            bus.protocol = zeros([sz uint16(1)], 'uint8');
            bus.protocol = char(bus.protocol);
            if isempty(bus.protocol), bus.protocol = ''; end
            if elements > uint32(0)
                bus.protocol = char(in(offset:offset+uint32(elements*1 - 1)));
                if size(bus.protocol, 1) > size(bus.protocol, 2) && size(bus.protocol, 2) == 1, bus.protocol = bus.protocol'; end
                offset = offset + uint32(elements*1);
            end
        end
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Deserializing fixed-sized field protocolVersion
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Checking header
    if valid == uint8(0) || offset + uint32(23 + numel(namePrefix) - 1) > numel(in)
        valid = uint8(0);
    end
    expectedHeader_protocolVersion = uint8([2, 4, typecast(uint16(numel(namePrefix) + 15), 'uint8'), namePrefix, 'protocolVersion', typecast(uint16(0), 'uint8'), '', 7, 1])';
    for headerOffset = 1:uint32(23+numel(namePrefix)-1)
        valid = uint8(valid && in(offset+headerOffset-1) == expectedHeader_protocolVersion(headerOffset));
    end
    offset = offset + uint32(23 + numel(namePrefix));

    % Establishing size
    if valid == uint8(0) || offset + uint32(2 - 1) > numel(in)
        % buffer not large enough for header
        valid = uint8(0);
        bus.protocolVersion = zeros([1 1], 'uint32');
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
            bus.protocolVersion = zeros([1 1], 'uint32');
        else
            % read and typecast data
            assert(elements <= uint32(1));
            bus.protocolVersion = zeros([1 1], 'uint32');
            if elements > uint32(0)
                bus.protocolVersion(1:elements) = typecast(in(offset:offset+uint32(elements*4 - 1))', 'uint32')';
                offset = offset + uint32(elements*4);
            end
        end
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Deserializing fixed-sized field saveTag
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Checking header
    if valid == uint8(0) || offset + uint32(15 + numel(namePrefix) - 1) > numel(in)
        valid = uint8(0);
    end
    expectedHeader_saveTag = uint8([2, 4, typecast(uint16(numel(namePrefix) + 7), 'uint8'), namePrefix, 'saveTag', typecast(uint16(0), 'uint8'), '', 7, 1])';
    for headerOffset = 1:uint32(15+numel(namePrefix)-1)
        valid = uint8(valid && in(offset+headerOffset-1) == expectedHeader_saveTag(headerOffset));
    end
    offset = offset + uint32(15 + numel(namePrefix));

    % Establishing size
    if valid == uint8(0) || offset + uint32(2 - 1) > numel(in)
        % buffer not large enough for header
        valid = uint8(0);
        bus.saveTag = zeros([1 1], 'uint32');
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
            bus.saveTag = zeros([1 1], 'uint32');
        else
            % read and typecast data
            assert(elements <= uint32(1));
            bus.saveTag = zeros([1 1], 'uint32');
            if elements > uint32(0)
                bus.saveTag(1:elements) = typecast(in(offset:offset+uint32(elements*4 - 1))', 'uint32')';
                offset = offset + uint32(elements*4);
            end
        end
    end


end