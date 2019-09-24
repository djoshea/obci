classdef CenterOutReachConditionHyperparameters
    properties
        % if false, center out reach, if true, just targets
        useTargetOnly = false;
        
        centerOutTargetDirectionList = [...
                DirectionName.Right, DirectionName.UpRight, ... 
                DirectionName.Up, DirectionName.UpLeft, ...
                DirectionName.Left, DirectionName.DownLeft, ...
                DirectionName.DownRight];
            
        centerOutTargetSize = 50;
        centerOutTargetAcceptanceSize = 60;
        centerOutTargetDistance = 55;
        
        juiceDuringTargetHold = false;
        
        centerX = 0;
        centerY = -10;
        
        fracZeroDelay = 1;
        delayRangeMin = 100;
        delayRangeMax = 800;
        fracShortDelay = 0.5;
        delayRangeShortMin = 20;
        delayRangeShortMax = 400;
        delayRangeLongMin = 400;
        delayRangeLongMax = 800;

        enforceMinPeakVelocity = false;
    end 
end
