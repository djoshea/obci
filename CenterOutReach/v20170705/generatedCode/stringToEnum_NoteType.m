function [enumValue, valid] = stringToEnum_NoteType(str)
%#codegen
% DO NOT EDIT: Auto-generated by 
%   BusSerialize.writeEnumToStringCode('NoteType')

    valid = uint8(1);
    if isequal(uint8(str(:)), uint8('Info')')
        enumValue = NoteType.Info;
    elseif isequal(uint8(str(:)), uint8('Debug')')
        enumValue = NoteType.Debug;
    elseif isequal(uint8(str(:)), uint8('Warning')')
        enumValue = NoteType.Warning;
    elseif isequal(uint8(str(:)), uint8('Error')')
        enumValue = NoteType.Error;
    elseif isequal(uint8(str(:)), uint8('ParameterChange')')
        enumValue = NoteType.ParameterChange;
    elseif isequal(uint8(str(:)), uint8('Epoch')')
        enumValue = NoteType.Epoch;
    elseif isequal(uint8(str(:)), uint8('Meta')')
        enumValue = NoteType.Meta;
    else
        enumValue = NoteType.Info;
        valid = uint8(0);
    end
end