function [out, valid] = serializeBus_RigConfigBus(bus, namePrefix)
%#codegen
% DO NOT EDIT: Auto-generated by 
%   BusSerialize.writeSerializeBusCode('RigConfigBus')

    if nargin < 2, namePrefix = uint8(''); end
    namePrefixBytes = uint8(namePrefix(:))';
    valid = uint8(0);
    coder.varsize('out', 457 + 10*numel(namePrefix));
    outSize = getSerializedBusLength_RigConfigBus(bus, namePrefix);
    assert(outSize <= 457 + 10*numel(namePrefix));
    out = zeros(outSize, 1, 'uint8');
    offset = uint32(1);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Serialize fixed-sized handSource
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Check input size is valid
    assert(numel(bus.handSource) == 1, 'numel(bus.handSource) must be 1');    % handSource bitFlags
    if(offset > numel(out)), return, end
    out(offset) = uint8(0);
    offset = offset + uint32(1);

    % handSource signal type
    if(offset > numel(out)), return, end
    out(offset) = uint8(4);
    offset = offset + uint32(1);

    % handSource name with prefix 
    if(offset+uint32(2+10 -1) > numel(out)), return, end
    out(offset:(offset+uint32(1))) = typecast(uint16(numel(namePrefixBytes) + 10), 'uint8');
    offset = offset + uint32(2);
    out(offset:(offset+uint32(numel(namePrefixBytes) + 10-1))) = [namePrefixBytes, uint8('handSource')];
    offset = offset + uint32(numel(namePrefixBytes) + 10);

    % handSource units
    if(offset+uint32(2+4 -1) > numel(out)), return, end
    out(offset:(offset+uint32(1))) = typecast(uint16(4), 'uint8');
    offset = offset + uint32(2);
    out(offset:(offset+uint32(4-1))) = uint8('enum');
    offset = offset + uint32(4);

    % handSource data type id
    if(offset > numel(out)), return, end
    out(offset) = uint8(8); % data type is HandSource
    offset = offset + uint32(1);

    % handSource dimensions
    if(offset > numel(out)), return, end
    if(offset+uint32(1+2*1-1) > numel(out)), return, end
    out(offset) = uint8(1);
    offset = offset + uint32(1);
    % converting enum type HandSource to string
    coder.varsize('enumAsStr_handSource', 7);
    enumAsStr_handSource = zeros(0, 1, 'uint8');
    for iEnum = 1:numel(bus.handSource)
        enumAsStr_handSource = [enumAsStr_handSource; uint8(enumToString_HandSource(bus.handSource(iEnum)))']; %#ok<AGROW>
        if iEnum < numel(bus.handSource)
            enumAsStr_handSource = [enumAsStr_handSource; uint8(';')]; %#ok<AGROW>
        end
    end
    out(offset:(offset+uint32(2*1-1))) = typecast(uint16(numel(enumAsStr_handSource)), 'uint8');
    offset = offset + uint32(2*1);

    % handSource data
    nBytes = uint32(numel(enumAsStr_handSource));
    if nBytes > uint32(0)
        if(offset+uint32(nBytes-1) > numel(out)), return, end
        out(offset:(offset+uint32(nBytes-1))) = uint8(enumAsStr_handSource(:));
    end
    offset = offset + nBytes;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Serialize fixed-sized polarisReflectionDistanceThreshXY
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Check input size is valid
    assert(numel(bus.polarisReflectionDistanceThreshXY) == 1, 'numel(bus.polarisReflectionDistanceThreshXY) must be 1');    % polarisReflectionDistanceThreshXY bitFlags
    if(offset > numel(out)), return, end
    out(offset) = uint8(2);
    offset = offset + uint32(1);

    % polarisReflectionDistanceThreshXY signal type
    if(offset > numel(out)), return, end
    out(offset) = uint8(4);
    offset = offset + uint32(1);

    % polarisReflectionDistanceThreshXY name with prefix 
    if(offset+uint32(2+33 -1) > numel(out)), return, end
    out(offset:(offset+uint32(1))) = typecast(uint16(numel(namePrefixBytes) + 33), 'uint8');
    offset = offset + uint32(2);
    out(offset:(offset+uint32(numel(namePrefixBytes) + 33-1))) = [namePrefixBytes, uint8('polarisReflectionDistanceThreshXY')];
    offset = offset + uint32(numel(namePrefixBytes) + 33);

    % polarisReflectionDistanceThreshXY units
    if(offset+uint32(2+2 -1) > numel(out)), return, end
    out(offset:(offset+uint32(1))) = typecast(uint16(2), 'uint8');
    offset = offset + uint32(2);
    out(offset:(offset+uint32(2-1))) = uint8('mm');
    offset = offset + uint32(2);

    % polarisReflectionDistanceThreshXY data type id
    if(offset > numel(out)), return, end
    out(offset) = uint8(0); % data type is double
    offset = offset + uint32(1);

    % polarisReflectionDistanceThreshXY dimensions
    if(offset > numel(out)), return, end
    if(offset+uint32(1+2*1-1) > numel(out)), return, end
    out(offset) = uint8(1);
    offset = offset + uint32(1);
    out(offset:(offset+uint32(2*1-1))) = typecast(uint16(numel(bus.polarisReflectionDistanceThreshXY)), 'uint8');
    offset = offset + uint32(2*1);

    % polarisReflectionDistanceThreshXY data
    nBytes = uint32(8 * numel(bus.polarisReflectionDistanceThreshXY));
    if nBytes > uint32(0)
        if(offset+uint32(nBytes-1) > numel(out)), return, end
        out(offset:(offset+uint32(nBytes-1))) = typecast(double(bus.polarisReflectionDistanceThreshXY(:))', 'uint8')';
    end
    offset = offset + nBytes;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Serialize fixed-sized polarisReflectionDistanceThreshZ
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Check input size is valid
    assert(numel(bus.polarisReflectionDistanceThreshZ) == 1, 'numel(bus.polarisReflectionDistanceThreshZ) must be 1');    % polarisReflectionDistanceThreshZ bitFlags
    if(offset > numel(out)), return, end
    out(offset) = uint8(2);
    offset = offset + uint32(1);

    % polarisReflectionDistanceThreshZ signal type
    if(offset > numel(out)), return, end
    out(offset) = uint8(4);
    offset = offset + uint32(1);

    % polarisReflectionDistanceThreshZ name with prefix 
    if(offset+uint32(2+32 -1) > numel(out)), return, end
    out(offset:(offset+uint32(1))) = typecast(uint16(numel(namePrefixBytes) + 32), 'uint8');
    offset = offset + uint32(2);
    out(offset:(offset+uint32(numel(namePrefixBytes) + 32-1))) = [namePrefixBytes, uint8('polarisReflectionDistanceThreshZ')];
    offset = offset + uint32(numel(namePrefixBytes) + 32);

    % polarisReflectionDistanceThreshZ units
    if(offset+uint32(2+2 -1) > numel(out)), return, end
    out(offset:(offset+uint32(1))) = typecast(uint16(2), 'uint8');
    offset = offset + uint32(2);
    out(offset:(offset+uint32(2-1))) = uint8('mm');
    offset = offset + uint32(2);

    % polarisReflectionDistanceThreshZ data type id
    if(offset > numel(out)), return, end
    out(offset) = uint8(0); % data type is double
    offset = offset + uint32(1);

    % polarisReflectionDistanceThreshZ dimensions
    if(offset > numel(out)), return, end
    if(offset+uint32(1+2*1-1) > numel(out)), return, end
    out(offset) = uint8(1);
    offset = offset + uint32(1);
    out(offset:(offset+uint32(2*1-1))) = typecast(uint16(numel(bus.polarisReflectionDistanceThreshZ)), 'uint8');
    offset = offset + uint32(2*1);

    % polarisReflectionDistanceThreshZ data
    nBytes = uint32(8 * numel(bus.polarisReflectionDistanceThreshZ));
    if nBytes > uint32(0)
        if(offset+uint32(nBytes-1) > numel(out)), return, end
        out(offset:(offset+uint32(nBytes-1))) = typecast(double(bus.polarisReflectionDistanceThreshZ(:))', 'uint8')';
    end
    offset = offset + nBytes;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Serialize fixed-sized polarisThreshTouchingZ
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Check input size is valid
    assert(numel(bus.polarisThreshTouchingZ) == 1, 'numel(bus.polarisThreshTouchingZ) must be 1');    % polarisThreshTouchingZ bitFlags
    if(offset > numel(out)), return, end
    out(offset) = uint8(2);
    offset = offset + uint32(1);

    % polarisThreshTouchingZ signal type
    if(offset > numel(out)), return, end
    out(offset) = uint8(4);
    offset = offset + uint32(1);

    % polarisThreshTouchingZ name with prefix 
    if(offset+uint32(2+22 -1) > numel(out)), return, end
    out(offset:(offset+uint32(1))) = typecast(uint16(numel(namePrefixBytes) + 22), 'uint8');
    offset = offset + uint32(2);
    out(offset:(offset+uint32(numel(namePrefixBytes) + 22-1))) = [namePrefixBytes, uint8('polarisThreshTouchingZ')];
    offset = offset + uint32(numel(namePrefixBytes) + 22);

    % polarisThreshTouchingZ units
    if(offset+uint32(2+2 -1) > numel(out)), return, end
    out(offset:(offset+uint32(1))) = typecast(uint16(2), 'uint8');
    offset = offset + uint32(2);
    out(offset:(offset+uint32(2-1))) = uint8('mm');
    offset = offset + uint32(2);

    % polarisThreshTouchingZ data type id
    if(offset > numel(out)), return, end
    out(offset) = uint8(0); % data type is double
    offset = offset + uint32(1);

    % polarisThreshTouchingZ dimensions
    if(offset > numel(out)), return, end
    if(offset+uint32(1+2*1-1) > numel(out)), return, end
    out(offset) = uint8(1);
    offset = offset + uint32(1);
    out(offset:(offset+uint32(2*1-1))) = typecast(uint16(numel(bus.polarisThreshTouchingZ)), 'uint8');
    offset = offset + uint32(2*1);

    % polarisThreshTouchingZ data
    nBytes = uint32(8 * numel(bus.polarisThreshTouchingZ));
    if nBytes > uint32(0)
        if(offset+uint32(nBytes-1) > numel(out)), return, end
        out(offset:(offset+uint32(nBytes-1))) = typecast(double(bus.polarisThreshTouchingZ(:))', 'uint8')';
    end
    offset = offset + nBytes;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Serialize fixed-sized polarisManualOffset
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Check input size is valid
    assert(numel(bus.polarisManualOffset) == 3, 'numel(bus.polarisManualOffset) must be 3');    % polarisManualOffset bitFlags
    if(offset > numel(out)), return, end
    out(offset) = uint8(2);
    offset = offset + uint32(1);

    % polarisManualOffset signal type
    if(offset > numel(out)), return, end
    out(offset) = uint8(4);
    offset = offset + uint32(1);

    % polarisManualOffset name with prefix 
    if(offset+uint32(2+19 -1) > numel(out)), return, end
    out(offset:(offset+uint32(1))) = typecast(uint16(numel(namePrefixBytes) + 19), 'uint8');
    offset = offset + uint32(2);
    out(offset:(offset+uint32(numel(namePrefixBytes) + 19-1))) = [namePrefixBytes, uint8('polarisManualOffset')];
    offset = offset + uint32(numel(namePrefixBytes) + 19);

    % polarisManualOffset units
    if(offset+uint32(2+2 -1) > numel(out)), return, end
    out(offset:(offset+uint32(1))) = typecast(uint16(2), 'uint8');
    offset = offset + uint32(2);
    out(offset:(offset+uint32(2-1))) = uint8('mm');
    offset = offset + uint32(2);

    % polarisManualOffset data type id
    if(offset > numel(out)), return, end
    out(offset) = uint8(0); % data type is double
    offset = offset + uint32(1);

    % polarisManualOffset dimensions
    if(offset > numel(out)), return, end
    if(offset+uint32(1+2*1-1) > numel(out)), return, end
    out(offset) = uint8(1);
    offset = offset + uint32(1);
    out(offset:(offset+uint32(2*1-1))) = typecast(uint16(numel(bus.polarisManualOffset)), 'uint8');
    offset = offset + uint32(2*1);

    % polarisManualOffset data
    nBytes = uint32(8 * numel(bus.polarisManualOffset));
    if nBytes > uint32(0)
        if(offset+uint32(nBytes-1) > numel(out)), return, end
        out(offset:(offset+uint32(nBytes-1))) = typecast(double(bus.polarisManualOffset(:))', 'uint8')';
    end
    offset = offset + nBytes;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Serialize fixed-sized polarisVolumeLimsX
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Check input size is valid
    assert(numel(bus.polarisVolumeLimsX) == 2, 'numel(bus.polarisVolumeLimsX) must be 2');    % polarisVolumeLimsX bitFlags
    if(offset > numel(out)), return, end
    out(offset) = uint8(2);
    offset = offset + uint32(1);

    % polarisVolumeLimsX signal type
    if(offset > numel(out)), return, end
    out(offset) = uint8(4);
    offset = offset + uint32(1);

    % polarisVolumeLimsX name with prefix 
    if(offset+uint32(2+18 -1) > numel(out)), return, end
    out(offset:(offset+uint32(1))) = typecast(uint16(numel(namePrefixBytes) + 18), 'uint8');
    offset = offset + uint32(2);
    out(offset:(offset+uint32(numel(namePrefixBytes) + 18-1))) = [namePrefixBytes, uint8('polarisVolumeLimsX')];
    offset = offset + uint32(numel(namePrefixBytes) + 18);

    % polarisVolumeLimsX units
    if(offset+uint32(2+2 -1) > numel(out)), return, end
    out(offset:(offset+uint32(1))) = typecast(uint16(2), 'uint8');
    offset = offset + uint32(2);
    out(offset:(offset+uint32(2-1))) = uint8('mm');
    offset = offset + uint32(2);

    % polarisVolumeLimsX data type id
    if(offset > numel(out)), return, end
    out(offset) = uint8(0); % data type is double
    offset = offset + uint32(1);

    % polarisVolumeLimsX dimensions
    if(offset > numel(out)), return, end
    if(offset+uint32(1+2*1-1) > numel(out)), return, end
    out(offset) = uint8(1);
    offset = offset + uint32(1);
    out(offset:(offset+uint32(2*1-1))) = typecast(uint16(numel(bus.polarisVolumeLimsX)), 'uint8');
    offset = offset + uint32(2*1);

    % polarisVolumeLimsX data
    nBytes = uint32(8 * numel(bus.polarisVolumeLimsX));
    if nBytes > uint32(0)
        if(offset+uint32(nBytes-1) > numel(out)), return, end
        out(offset:(offset+uint32(nBytes-1))) = typecast(double(bus.polarisVolumeLimsX(:))', 'uint8')';
    end
    offset = offset + nBytes;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Serialize fixed-sized polarisVolumeLimsY
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Check input size is valid
    assert(numel(bus.polarisVolumeLimsY) == 2, 'numel(bus.polarisVolumeLimsY) must be 2');    % polarisVolumeLimsY bitFlags
    if(offset > numel(out)), return, end
    out(offset) = uint8(2);
    offset = offset + uint32(1);

    % polarisVolumeLimsY signal type
    if(offset > numel(out)), return, end
    out(offset) = uint8(4);
    offset = offset + uint32(1);

    % polarisVolumeLimsY name with prefix 
    if(offset+uint32(2+18 -1) > numel(out)), return, end
    out(offset:(offset+uint32(1))) = typecast(uint16(numel(namePrefixBytes) + 18), 'uint8');
    offset = offset + uint32(2);
    out(offset:(offset+uint32(numel(namePrefixBytes) + 18-1))) = [namePrefixBytes, uint8('polarisVolumeLimsY')];
    offset = offset + uint32(numel(namePrefixBytes) + 18);

    % polarisVolumeLimsY units
    if(offset+uint32(2+2 -1) > numel(out)), return, end
    out(offset:(offset+uint32(1))) = typecast(uint16(2), 'uint8');
    offset = offset + uint32(2);
    out(offset:(offset+uint32(2-1))) = uint8('mm');
    offset = offset + uint32(2);

    % polarisVolumeLimsY data type id
    if(offset > numel(out)), return, end
    out(offset) = uint8(0); % data type is double
    offset = offset + uint32(1);

    % polarisVolumeLimsY dimensions
    if(offset > numel(out)), return, end
    if(offset+uint32(1+2*1-1) > numel(out)), return, end
    out(offset) = uint8(1);
    offset = offset + uint32(1);
    out(offset:(offset+uint32(2*1-1))) = typecast(uint16(numel(bus.polarisVolumeLimsY)), 'uint8');
    offset = offset + uint32(2*1);

    % polarisVolumeLimsY data
    nBytes = uint32(8 * numel(bus.polarisVolumeLimsY));
    if nBytes > uint32(0)
        if(offset+uint32(nBytes-1) > numel(out)), return, end
        out(offset:(offset+uint32(nBytes-1))) = typecast(double(bus.polarisVolumeLimsY(:))', 'uint8')';
    end
    offset = offset + nBytes;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Serialize fixed-sized polarisVolumeLimsZ
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Check input size is valid
    assert(numel(bus.polarisVolumeLimsZ) == 2, 'numel(bus.polarisVolumeLimsZ) must be 2');    % polarisVolumeLimsZ bitFlags
    if(offset > numel(out)), return, end
    out(offset) = uint8(2);
    offset = offset + uint32(1);

    % polarisVolumeLimsZ signal type
    if(offset > numel(out)), return, end
    out(offset) = uint8(4);
    offset = offset + uint32(1);

    % polarisVolumeLimsZ name with prefix 
    if(offset+uint32(2+18 -1) > numel(out)), return, end
    out(offset:(offset+uint32(1))) = typecast(uint16(numel(namePrefixBytes) + 18), 'uint8');
    offset = offset + uint32(2);
    out(offset:(offset+uint32(numel(namePrefixBytes) + 18-1))) = [namePrefixBytes, uint8('polarisVolumeLimsZ')];
    offset = offset + uint32(numel(namePrefixBytes) + 18);

    % polarisVolumeLimsZ units
    if(offset+uint32(2+2 -1) > numel(out)), return, end
    out(offset:(offset+uint32(1))) = typecast(uint16(2), 'uint8');
    offset = offset + uint32(2);
    out(offset:(offset+uint32(2-1))) = uint8('mm');
    offset = offset + uint32(2);

    % polarisVolumeLimsZ data type id
    if(offset > numel(out)), return, end
    out(offset) = uint8(0); % data type is double
    offset = offset + uint32(1);

    % polarisVolumeLimsZ dimensions
    if(offset > numel(out)), return, end
    if(offset+uint32(1+2*1-1) > numel(out)), return, end
    out(offset) = uint8(1);
    offset = offset + uint32(1);
    out(offset:(offset+uint32(2*1-1))) = typecast(uint16(numel(bus.polarisVolumeLimsZ)), 'uint8');
    offset = offset + uint32(2*1);

    % polarisVolumeLimsZ data
    nBytes = uint32(8 * numel(bus.polarisVolumeLimsZ));
    if nBytes > uint32(0)
        if(offset+uint32(nBytes-1) > numel(out)), return, end
        out(offset:(offset+uint32(nBytes-1))) = typecast(double(bus.polarisVolumeLimsZ(:))', 'uint8')';
    end
    offset = offset + nBytes;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Serialize fixed-sized polarisOrigin
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Check input size is valid
    assert(numel(bus.polarisOrigin) == 3, 'numel(bus.polarisOrigin) must be 3');    % polarisOrigin bitFlags
    if(offset > numel(out)), return, end
    out(offset) = uint8(2);
    offset = offset + uint32(1);

    % polarisOrigin signal type
    if(offset > numel(out)), return, end
    out(offset) = uint8(4);
    offset = offset + uint32(1);

    % polarisOrigin name with prefix 
    if(offset+uint32(2+13 -1) > numel(out)), return, end
    out(offset:(offset+uint32(1))) = typecast(uint16(numel(namePrefixBytes) + 13), 'uint8');
    offset = offset + uint32(2);
    out(offset:(offset+uint32(numel(namePrefixBytes) + 13-1))) = [namePrefixBytes, uint8('polarisOrigin')];
    offset = offset + uint32(numel(namePrefixBytes) + 13);

    % polarisOrigin units
    if(offset+uint32(2+2 -1) > numel(out)), return, end
    out(offset:(offset+uint32(1))) = typecast(uint16(2), 'uint8');
    offset = offset + uint32(2);
    out(offset:(offset+uint32(2-1))) = uint8('mm');
    offset = offset + uint32(2);

    % polarisOrigin data type id
    if(offset > numel(out)), return, end
    out(offset) = uint8(0); % data type is double
    offset = offset + uint32(1);

    % polarisOrigin dimensions
    if(offset > numel(out)), return, end
    if(offset+uint32(1+2*1-1) > numel(out)), return, end
    out(offset) = uint8(1);
    offset = offset + uint32(1);
    out(offset:(offset+uint32(2*1-1))) = typecast(uint16(numel(bus.polarisOrigin)), 'uint8');
    offset = offset + uint32(2*1);

    % polarisOrigin data
    nBytes = uint32(8 * numel(bus.polarisOrigin));
    if nBytes > uint32(0)
        if(offset+uint32(nBytes-1) > numel(out)), return, end
        out(offset:(offset+uint32(nBytes-1))) = typecast(double(bus.polarisOrigin(:))', 'uint8')';
    end
    offset = offset + nBytes;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Serialize fixed-sized moveSpeedThresh
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Check input size is valid
    assert(numel(bus.moveSpeedThresh) == 1, 'numel(bus.moveSpeedThresh) must be 1');    % moveSpeedThresh bitFlags
    if(offset > numel(out)), return, end
    out(offset) = uint8(2);
    offset = offset + uint32(1);

    % moveSpeedThresh signal type
    if(offset > numel(out)), return, end
    out(offset) = uint8(4);
    offset = offset + uint32(1);

    % moveSpeedThresh name with prefix 
    if(offset+uint32(2+15 -1) > numel(out)), return, end
    out(offset:(offset+uint32(1))) = typecast(uint16(numel(namePrefixBytes) + 15), 'uint8');
    offset = offset + uint32(2);
    out(offset:(offset+uint32(numel(namePrefixBytes) + 15-1))) = [namePrefixBytes, uint8('moveSpeedThresh')];
    offset = offset + uint32(numel(namePrefixBytes) + 15);

    % moveSpeedThresh units
    if(offset+uint32(2+4 -1) > numel(out)), return, end
    out(offset:(offset+uint32(1))) = typecast(uint16(4), 'uint8');
    offset = offset + uint32(2);
    out(offset:(offset+uint32(4-1))) = uint8('mm/s');
    offset = offset + uint32(4);

    % moveSpeedThresh data type id
    if(offset > numel(out)), return, end
    out(offset) = uint8(0); % data type is double
    offset = offset + uint32(1);

    % moveSpeedThresh dimensions
    if(offset > numel(out)), return, end
    if(offset+uint32(1+2*1-1) > numel(out)), return, end
    out(offset) = uint8(1);
    offset = offset + uint32(1);
    out(offset:(offset+uint32(2*1-1))) = typecast(uint16(numel(bus.moveSpeedThresh)), 'uint8');
    offset = offset + uint32(2*1);

    % moveSpeedThresh data
    nBytes = uint32(8 * numel(bus.moveSpeedThresh));
    if nBytes > uint32(0)
        if(offset+uint32(nBytes-1) > numel(out)), return, end
        out(offset:(offset+uint32(nBytes-1))) = typecast(double(bus.moveSpeedThresh(:))', 'uint8')';
    end
    offset = offset + nBytes; %#ok<NASGU>

    valid = uint8(1);
end