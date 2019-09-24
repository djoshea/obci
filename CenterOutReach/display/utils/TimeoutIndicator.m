classdef TimeoutIndicator < Oval
    properties
        vibrating = false;
        vibrateSigma = 2;
        xOffset = 0;
        yOffset = 0;
        
        blinkPeriod = 2; % sec
        blinking = false;
    end
    
    properties(SetAccess=protected)
        blinkCurrentOn = true;
        blinkLastToggle = NaN;
    end
    
    properties(Dependent)
        x1o
        x2o
        y1o
        y2o
    end
    
    methods
        function obj = TimeoutIndicator()
            obj = obj@Oval(0,0,300,300);
        end
        
        function str = describe(r)
            str = '';
        end
  
        function vibrate(r, sigma)
            if nargin >= 2
                r.vibrateSigma = sigma;
            end
            r.vibrating = true;
        end
        
        function stopVibrating(r)
            r.vibrating = false;
        end
        
        function blink(r)
            r.blinking = true;
        end
        
        function stopBlinking(r)
            r.blinking = false;
        end
        
        function x1 = get.x1o(r)
            x1 = r.xc + r.xOffset - r.width/2;
        end
        
        function y1 = get.y1o(r)
            y1 = r.yc + r.yOffset - r.height/2;
        end
        
        function x2 = get.x2o(r)
            x2 = r.xc + r.xOffset + r.width/2;
        end
        
        function y2 = get.y2o(r)
            y2 = r.yc + r.yOffset + r.height/2;
        end
        
        function update(r, mgr, sd)
            if r.blinking
                if isnan(r.blinkLastToggle)
                    r.blinkLastToggle = now;
                end
                n = now;
                if n - r.blinkLastToggle > datenum([0 0 0 0 0 r.blinkPeriod])
                    % change state
                    r.blinkCurrentOn = ~r.blinkCurrentOn;
                    r.blinkLastToggle = n;
                    %fprintf('Toggling to %d\n', r.blinkCurrentOn);
                end
            end
                 
            if r.vibrating
                r.xOffset = r.vibrateSigma * randn(1);
                r.yOffset = r.vibrateSigma * randn(1);
            else
                r.xOffset = 0;
                r.yOffset = 0;
            end
        end
        
        %  Draw Circle
        function draw(r, sd)
            if r.blinking && ~r.blinkCurrentOn
                return;
            end
            
            state = sd.saveState();
            sd.fillColor = [1 0 0];
            sd.penColor = [1 0 0];
            sd.penWidth = 1;
            sd.drawOval(r.x1o, r.y1o, r.x2o, r.y2o, true);
            sd.restoreState(state);
        end
    end
    
end

