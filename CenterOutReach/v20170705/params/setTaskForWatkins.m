function setTaskForWatkins(crc)

if nargin < 1
    crc = CenterOutReachControl.getInstance();
end

crc.param.timeCenterAcquire = 10000;
crc.param.timeTargetAcquire = 10000;

crc.param.rtMax = 10000;
crc.param.rtMin = 0;
crc.rigConfig.moveSpeedThresh = 9999;
crc.rigConfig.polarisManualOffset = [0 9 0]; % y is vertical offset added to raw bead position
crc.rigConfig.polarisThreshTouchingZ = 30;

crc.param.timeTargetSettle = 50;
crc.param.timeTargetHold = 50;

crc.param.centerSize = 40;

crc.param.targetHoldWindowSize = 80;
crc.param.centerHoldWindowSize = 80;

crc.param.timeCenterHold = 1;
crc.param.timeCenterSettle = 160;

crc.param.itiFailure = 150;
crc.param.itiSuccess = 150;

crc.param.allowHandNotSeen = true; % let him put his hand down mid trial

crc.param.allowReacquireCenter = true;
crc.param.allowReacquireTarget = true;

crc.param.acceptanceWindowPadding = 6;

%% reward

crc.param.timeJuiceCenter = 50;
crc.setJuice(0); 
crc.param.targetHoldJuiceSize = 30;
crc.param.targetHoldJuiceInterval = 100;


%% update conditions

% center out targets
hp.centerOutTargetDirectionList = [...
    DirectionName.UpRight, DirectionName.UpLeft, ...
    DirectionName.DownLeft, DirectionName.DownRight];

hp.centerOutTargetSize = 55;
hp.centerOutTargetAcceptanceSize = 75;
hp.centerOutTargetDistance = 70;

hp.centerX = 0; % for 2P mode
%hp.centerX = -60; % for mOEG mode
% hp.centerX = -90; % for mOEG mode

% moved this down on 2/11/2016 when the screen moved down
hp.centerY = -10; % was -110 for all upwards targets

hp.useTargetOnly = false;
hp.juiceDuringTargetHold = false;

crc.setConditionHyperparameters(hp);

%% Update data logger

crc.setDataLoggerWatkins();

crc.param.timeCenterHold = 200;
 crc.param.timeTargetHold = 100;
