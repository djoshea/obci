classdef GalvoMode < Simulink.IntEnumType
    enumeration
        Galvo(0)
        Spiral(1)
        Resonant(2)
    end
    
    methods(Static)
        function v = getDefaultValue()
            v = GalvoMode.Galvo;
        end
        
        function tf = addClassNameToEnumNames()
			tf = false;
		end
    end
end
