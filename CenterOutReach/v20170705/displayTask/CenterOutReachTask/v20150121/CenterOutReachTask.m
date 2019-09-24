classdef CenterOutReachTask < DisplayTask 

    properties 
        trialFailed = false;

        center

        target

        targetActive % reference to one of the above fields

        cursor
        hold
        sound

        photobox

        commandMap % containers.Map : command string -> method handle
    end

    properties
        TargetCenter = 0;
    end

    properties
        showHold = false;
    end

    methods
        function task = CenterOutReachTask()
            task.name = 'CenterOutReachTask';
            task.showHold = false;
            task.buildCommandMap();
        end

        function initialize(task, ~)
            task.center = Circle(0, 0, 0);
            task.center.hide();
            task.dc.mgr.add(task.center);
            
            task.target = CircleTarget(0, 0, 0);
            task.target.hide();
            task.dc.mgr.add(task.target);

            task.cursor = CursorRound();
            task.cursor.hide();
            task.dc.mgr.add(task.cursor);

            task.hold = Rectangle(Inf,Inf,1,1);
            task.hold.hide();
            task.dc.mgr.add(task.hold);

            task.photobox = Photobox(task.dc.cxt);
            task.photobox.off();
            task.dc.mgr.add(task.photobox);

            task.sound = AudioFeedback();
        end

        function cleanup(task, data) %#ok<INUSD,MANU>
        end

        function update(task, data)
            if isfield(data, 'handInfo')
                handInfo = data.handInfo; 
                task.cursor.xc = handInfo.handX;
                task.cursor.yc = handInfo.handY;
                task.cursor.touching = handInfo.handTouching;
                task.cursor.seen = handInfo.handSeen;
                %task.cursor.show();
            end
        end

        function runCommand(task, command, data)
            if task.commandMap.isKey(command)
                fprintf('Running taskCommand %s\n', command);
                fn = task.commandMap(command);
                fn(data);
            else
                fprintf('Unrecognized taskCommand %s\n', command);
            end
        end

        function buildCommandMap(task)
            map = containers.Map('KeyType', 'char', 'ValueType', 'any');
            map('TaskPaused') = @task.pause;
            map('StartTask') = @task.start;
            map('InitTrial') = @task.initTrial;
            map('CenterOnset') = @task.centerOnset;
            map('CenterAcquired') = @task.centerAcquired;
            map('CenterSettled') = @task.centerSettled;
            map('CenterHeld') = @task.centerHeld;
            
            map('DelayPeriodStart') = @task.delayPeriodStart;
            map('GoCueZeroDelay') = @task.goCueZeroDelay;
            map('GoCueNonZeroDelay') = @task.goCueNonZeroDelay;
            map('MoveOnset') = @task.moveOnset;
            map('TargetShift') = @task.targetShift;
            map('TargetAcquired') = @task.targetAcquired;
            map('TargetSettled') = @task.targetSettled;
            map('TargetHeld') = @task.targetHeld;
            map('Success') = @task.success;
            map('FailureCenterFlyAway') = @task.failureCenterFlyAway;
            map('FailureTargetFlyAway') = @task.failureTargetFlyAway;
            map('ITI') = @task.iti;

            task.commandMap = map;
        end

        function pause(task, ~)
            task.center.hide();
            task.target.hide();
            task.hold.hide();
            task.cursor.hide();
            task.photobox.off();
        end

        function start(task, ~)
            %task.cursor.show();
            task.photobox.off();
        end

        function initTrial(task, data)
            task.trialFailed = false;

            %task.cursor.show();
            
            P = data.P;
            C = data.C;
            task.center.xc = C.centerX;
            task.center.yc = C.centerY;
            task.center.radius = P.centerSize/2;
            task.center.borderWidth = 0;
            task.center.borderColor = [0 0 1];
            task.center.fill = true;
            task.center.fillColor = [0 0 1];
            task.center.hide();
            
            task.hold.fill = false;
            task.hold.fillColor = task.dc.sd.red;
            task.hold.color = task.dc.sd.red;
            task.hold.borderWidth = 3;

%             yellow = [255 238 0] / 255;
%             yellowFill = [255 246 120] / 255;
            red = [1 0 0];
            redFill = [1 0.5 0.5];
            
            task.target.xc = C.targetX;
            task.target.yc = C.targetY;
            task.target.radius = C.targetSize/2; 
            %task.target.contourWidth = 3;
            %task.target.contourColor = [0.3 1 0.3];
            task.target.vibrateSigma = P.delayVibrateSigma;
            task.target.borderWidth = 1;
            task.target.borderColor = [0 0 1];
            task.target.fillColor = [0 0 1];
            task.target.hide();
            task.target.normal();
            
            task.target = task.target;
            
            task.photobox.off();
        end

        function centerOnset(task, ~)
            task.center.show();
            
            task.dc.log('Center Onset');
        end

        function centerAcquired(task, ~)
            task.center.borderWidth = 1;
            task.center.borderColor = [0 0 1];
            task.dc.log('Center Acquired');
        end

        function centerUnacquire(task, ~)
            %task.center.unacquire();
            task.dc.log('Center Unacquired');
        end

        function centerSettled(task, data) %#ok<INUSD>
%             P = data.P;
%             trialData = data.trialData;
%             if task.showHold
%                 task.hold.xc = trialData.holdX;
%                 task.hold.yc = trialData.holdY;
%                 task.hold.width = P.holdWindow;
%                 task.hold.height = P.holdWindow;
%                 task.hold.fill = false;
%                 task.hold.show();
%             end
            task.dc.log('Center Settled');
        end

        function centerHeld(task, ~)
            %task.center.success();
            task.hold.fill = true;
            task.dc.log('Center Held');
        end


        function delayPeriodStart(task, data)
            C = data.C;
            task.target.contour();
            task.target.vibrate();
            task.target.show();  
            task.photobox.on();

            task.dc.log('Delay Period Start');
        end

        function goCueZeroDelay(task, data)
            C = data.C;
            task.hold.hide();
            task.center.hide();
            task.target.stopVibrating();
            task.target.fillIn();
            task.target.show();            

            task.photobox.flash();
            task.dc.log('Go Cue Zero Delay');
        end

        function goCueNonZeroDelay(task, data)
            C = data.C;
            task.hold.hide();
            task.center.hide();
            
            task.target.fillIn();
            task.target.stopVibrating();
            task.target.show();
            task.photobox.off();

            task.dc.log('Go Cue');
        end

        function moveOnset(task, ~)
            task.dc.log('Move Onset');
        end


        function targetAcquired(task, ~)
            %task.target.acquire();
            task.dc.log('Target Acquired');
        end

        function targetSettled(task, data) %#ok<INUSD>
%             P = data.P;
%             trialData = data.trialData;
%             if task.showHold
%                 task.hold.xc = trialData.holdX;
%                 task.hold.yc = trialData.holdY;
%                 task.hold.width = P.holdWindow;
%                 task.hold.height = P.holdWindow;
%                 task.hold.fill = false;
%                 task.hold.show();
%             end
            task.dc.log('Target Settled');
        end

        function targetHeld(task, ~)
            %task.hold.fill = true;
            task.dc.log('Center Held');
        end

        function success(task, data) %#ok<INUSD>
            %task.target.success();
            
            %TD = data.trialData;

            task.sound.playSuccess();
            %rewardToneOff = double(TD.rewardTonePulseInterval - TD.rewardTonePulseLength);
            %task.sound.playTonePulseTrain(TD.rewardTonePulseHz, double(TD.rewardTonePulseLength), ...
            %    rewardToneOff, double(TD.rewardTonePulseReps));
            
            task.photobox.off();
        end


        function failureCenterFlyAway(task, data)
            C = data.C;
            task.trialFailed = true;

            task.center.hide();

            task.target.contour();
            task.target.stopVibrating();
            task.target.flyAway(task.cursor.xc, task.cursor.yc);
            task.hold.hide();
            task.sound.playFailure();
            task.photobox.off();
        end

        function failureTargetFlyAway(task, data)
            C = data.C;
            task.trialFailed = true;

            task.center.hide();

            task.target.contour();
            task.target.stopVibrating();
            task.target.flyAway(task.cursor.xc, task.cursor.yc);

            task.hold.hide();
            task.sound.playFailure();
            task.photobox.off();
        end

        function iti(task, ~)
            task.center.hide();
            task.hold.hide();
            task.target.hide();
            task.photobox.off();
        end
    end
end
