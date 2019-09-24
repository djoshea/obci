classdef PerturbationTiming < Simulink.IntEnumType
    enumeration
        None(-1)
        Thresh(0)
        ThreshPlus20(20)
        ThreshPlus25(25)
        ThreshPlus30(30)
        ThreshPlus35(35)
        ThreshPlus40(40)
        ThreshPlus45(45)
        ThreshPlus50(50)
        ThreshPlus55(55)
        ThreshPlus60(60)
        ThreshPlus65(65)
        ThreshPlus70(70)
        ThreshPlus75(75)
        ThreshPlus80(80)
        ThreshPlus90(90)
        ThreshPlus100(100)
        ThreshPlus125(125)
        ThreshPlus150(150)
    end
    
    methods(Static)
        function v = getDefaultValue()
            v = PerturbationTiming.None;
        end
        
        function tf = addClassNameToEnumNames()
			tf = true;
		end
    end
    
    methods
        function timing = getTiming(d)
            timing = double(d);
        end 
    end
    
end
