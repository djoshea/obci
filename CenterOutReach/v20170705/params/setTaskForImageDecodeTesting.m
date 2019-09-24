function setTaskForImageDecodeTesting(crc)

if nargin < 1
    crc = CenterOutReachControl.getInstance();
end

p = crc.param;
rigConfig = crc.rigConfig;
hp = crc.hp;

%%

rigConfig = crc.rigConfig;
rigConfig.moveSpeedThresh = 9999; % how fast he's moving before it registers as moving (mm/s); 40 is reasonable
rigConfig.polarisManualOffset = [0 9 0]; % add this to raw bead position (mm) to get hand position
rigConfig.polarisThreshTouchingZ = 40; % how close must the bead be to the screen to register as a touch (mm).
crc.rigConfig = rigConfig;
%%

p.timeCenterAcquire = 10000; % ms
p.timeTargetAcquire = 10000;

p.rtMax = 10000;
p.rtMin = 0;

p.timeTargetSettle = 80;
p.timeTargetHold = 80;

p.centerSize = 80;

p.targetHoldWindowSize = 80;
p.centerHoldWindowSize = 80;

p.timeCenterHold = 80;
p.timeCenterSettle = 80;

p.itiFailure = 150;
p.itiSuccess = 300;

p.allowHandNotSeen = true; % let him put his hand down mid trial

p.allowReacquireCenter = true;
p.allowReacquireTarget = true;

p.acceptanceWindowPadding = 6;

%% reward

p.timeJuiceCenter = 50;
p.targetHoldJuiceSize = 30;
p.targetHoldJuiceInterval = 100;

%% update conditions



% center out targets
hp.centerOutTargetDirectionList = [...
    DirectionName.UpRight, DirectionName.UpLeft, ...
    DirectionName.DownLeft, DirectionName.DownRight];

hp.centerOutTargetSize = 200; % 95
hp.centerOutTargetAcceptanceSize = 120; % 105
hp.centerOutTargetDistance = 60;

hp.centerX = 120; % for 2P mode
%hp.centerX = -60; % for mOEG mode
% hp.centerX = -90; % for mOEG mode

% moved this down on 2/11/2016 when the screen moved down
hp.centerY = -40; % was -110 for all upwards targets

hp.useTargetOnly = true; % if true, pinball task; if false, center out task

hp.juiceDuringTargetHold = false;


%% 20170616

hp.useTargetOnly = false;

p.timeTargetSettle = 100;
p.timeTargetHold = 100;
hp.centerOutTargetSize = 50;

p.centerSize = 30;
p.timeCenterHold = 50;
p.timeCenterSettle =50;
p.timeJuiceCenter = 0;
p.timeJuice = 150;

p.timeCenterAcquire = 3000; % ms
p.timeTargetAcquire = 900;

p.targetHoldWindowSize = 20;
p.centerHoldWindowSize = 20; % can go down to 10

p.allowReacquireCenter=0;
p.allowReacquireTarget=0;
p.allowHandNotSeen=0;

hp.centerOutTargetDistance = 10;

p.rtMin = 180; 
p.rtMax = 800;


rigConfig.moveSpeedThresh = 60; % will go to 40 eventually
p.delayVibrateSigma = 3; % should go down
hp.fracZeroDelay = 0.1;
hp.fracShortDelay = 0.9;
hp.delayRangeShortMin = 10;      
hp.delayRangeShortMax = 100;
p.targetHoldWindowSize = 40;
p.timeTargetSettle = 400;
p.timeTargetHold = 10;
p.acceptanceWindowPadding = 12;
%% Update data logger
crc.rigConfig = rigConfig;
crc.param = p;
crc.setConditionHyperparameters(hp);

