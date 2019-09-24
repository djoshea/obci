classdef LedMode < Simulink.IntEnumType
    enumeration
        Off(0)
        CW405(1)
        CW470(2)
        Alternating405_470(4)
    end
    
    methods(Static)
        function v = getDefaultValue()
            v = LedMode.Off;
        end
        
        function tf = addClassNameToEnumNames()
			tf = true;
		end
    end
    
    methods
        function [status470, status405] = getLedStatus(m)
            status470 = false;
            status405= false;
            switch m
                case LedMode.Off
                
                case LedMode.CW405
                    status405 = true;
                    
                case LedMode.CW470
                    status470 = true;
                  
                case LedMode.Alternating405_470
                    status470 = true;
                    status405 = true;
            end
        end
        
        function str = getFileSuffixString(m)
            switch m
                case LedMode.Off
                    str = 'ledsOff';
                    
                case LedMode.CW405
                    str = 'led405cw';
                    
                case LedMode.CW470
                    str = 'led470cw';
                  
                case LedMode.Alternating405_470
                    str = 'ledsAlernating405_470';
                    
                otherwise
                    error('Unknown LedMode');
            end
        end
            
    end
    
end
