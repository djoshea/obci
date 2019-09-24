classdef PerturbationStrength < Simulink.IntEnumType
    enumeration
        None(-1)
        Normal(1)
        
        Half(2)
        Double(3)
        OnePointFive(4)
    end
    
    methods(Static)
        function v = getDefaultValue()
            v = PerturbationStrength.None;
        end
        
        function tf = addClassNameToEnumNames()
			tf = true;
		end
    end
    
    methods
        function gain = getGain(d)
            switch d
                case PerturbationStrength.None
                    gain = 0;
                case PerturbationStrength.Normal
                    gain = 1;
                case PerturbationStrength.Half
                    gain = 0.5;
                case PerturbationStrength.Double
                    gain = 2;
                case PerturbationStrength.OnePointFive
                    gain = 1.5;
                otherwise
                    gain = NaN;
            end
        end 
    end
    
end
