function [enumValue, valid] = stringToEnum_HandSource(str)
%#codegen
% DO NOT EDIT: Auto-generated by 
%   BusSerialize.writeEnumToStringCode('HandSource')

    valid = uint8(1);
    if isequal(uint8(str(:)), uint8('Mouse')')
        enumValue = HandSource.Mouse;
    elseif isequal(uint8(str(:)), uint8('Polaris')')
        enumValue = HandSource.Polaris;
    elseif isequal(uint8(str(:)), uint8('Haptic')')
        enumValue = HandSource.Haptic;
    else
        enumValue = HandSource.Mouse;
        valid = uint8(0);
    end
end