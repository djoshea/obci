classdef DirectionName < Simulink.IntEnumType
    enumeration
        None(-1)
        
        Right(0)
        UpRight(45)
        Up(90)
        UpLeft(135)
        Left(180)
        DownLeft(225)
        Down(270)
        DownRight(315)
        
        Center(-10)
    end
    
    methods(Static)
        function v = getDefaultValue()
            v = DirectionName.None;
        end
        
        function tf = addClassNameToEnumNames()
			tf = true;
		end
    end
    
    methods
        function theta = getAngleFromPosX(d)
            switch d
                case DirectionName.Right
                    theta = 0;
                case DirectionName.UpRight
                    theta = pi/4;
                case DirectionName.Up
                    theta = pi/2;
                case DirectionName.UpLeft
                    theta = 3*pi/4;
                case DirectionName.Left
                    theta = pi;
                case DirectionName.DownLeft
                    theta = 5*pi/4;
                case DirectionName.Down
                    theta = 3*pi/2;
                case DirectionName.DownRight
                    theta = 7*pi/4;
                otherwise
                    theta = NaN;
            end
        end 
    end
    
end
