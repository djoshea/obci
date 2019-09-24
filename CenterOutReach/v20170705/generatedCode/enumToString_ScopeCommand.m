function [str, valid] = enumToString_ScopeCommand(enumValue)
%#codegen
% DO NOT EDIT: Auto-generated by 
%   BusSerialize.writeEnumToStringCode('ScopeCommand')

    valid = uint8(1);
    coder.varsize('str', [1 21], [false true]);
    if ischar(enumValue), str = enumValue; valid = uint8(1); return; end
    switch enumValue
        case ScopeCommand.NextTrial
            str = uint8('NextTrial');
        case ScopeCommand.StartImagingOnTrigger
            str = uint8('StartImagingOnTrigger');
        case ScopeCommand.StartTrialImaging
            str = uint8('StartTrialImaging');
        case ScopeCommand.EndTrialImaging
            str = uint8('EndTrialImaging');
        case ScopeCommand.StopImaging
            str = uint8('StopImaging');
        otherwise
            str = uint8('NextTrial');
            valid = uint8(0);
    end
end