function setTaskForXavierTraining(crc)

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

p.centerSize = 40;

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

hp.centerOutTargetSize = 50; % 95
hp.centerOutTargetAcceptanceSize = 16; % 105
hp.centerOutTargetDistance = 60;

hp.centerX = 120; % for 2P mode
%hp.centerX = -60; % for mOEG mode
% hp.centerX = -90; % for mOEG mode

% moved this down on 2/11/2016 when the screen moved down
hp.centerY = -40; % was -110 for all upwards targets

hp.useTargetOnly = true; % if true, pinball task; if false, center out task

hp.juiceDuringTargetHold = false;

 
%% 20170213- switching to center then target

hp.useTargetOnly = false;

p.timeTargetSettle = 150;
p.timeTargetHold = 200;
hp.centerOutTargetSize = 70;

p.centerSize = 70;
p.timeCenterHold = 120;
p.timeCenterSettle = 150;
p.timeJuiceCenter = 40;
p.timeJuice = 260;

p.timeCenterAcquire = 10000; % ms
p.timeTargetAcquire = 2000;

p.targetHoldWindowSize = 30;
p.centerHoldWindowSize = 30;

%% 20170214- switching to center then target

hp.useTargetOnly = false;

p.timeTargetSettle = 250;
p.timeTargetHold = 250;
hp.centerOutTargetSize = 40;

p.centerSize = 40;
p.timeCenterHold = 250;
p.timeCenterSettle = 250;
p.timeJuiceCenter = 20;
p.timeJuice = 310;

p.timeCenterAcquire = 6000; % ms
p.timeTargetAcquire = 1000;

p.targetHoldWindowSize = 20;
p.centerHoldWindowSize = 20;

hp.centerOutTargetDistance = 80;

%% 20170215

hp.useTargetOnly = false;

p.timeTargetSettle = 250;
p.timeTargetHold = 300;
hp.centerOutTargetSize = 30;

p.centerSize = 40;
p.timeCenterHold = 250;
p.timeCenterSettle =250;
p.timeJuiceCenter = 10;
p.timeJuice = 350;

p.timeCenterAcquire = 6000; % ms
p.timeTargetAcquire = 1000;

p.targetHoldWindowSize = 20;
p.centerHoldWindowSize = 20;

hp.centerOutTargetDistance = 90;

%% 20170216

hp.useTargetOnly = false;

p.timeTargetSettle = 250;
p.timeTargetHold = 300;
hp.centerOutTargetSize = 30;

p.centerSize = 40;
p.timeCenterHold = 300;
p.timeCenterSettle =250;
p.timeJuiceCenter = 10;
p.timeJuice = 350;

p.timeCenterAcquire = 6000; % ms
p.timeTargetAcquire = 1000;

p.targetHoldWindowSize = 20;
p.centerHoldWindowSize = 20;

hp.centerOutTargetDistance = 90;


%% 20170217, allowReaquireCenter/Target are both 0. 

hp.useTargetOnly = false;

p.timeTargetSettle = 300;
p.timeTargetHold = 300;
hp.centerOutTargetSize = 30;

p.centerSize = 30;
p.timeCenterHold = 300;
p.timeCenterSettle =300;
p.timeJuiceCenter = 0;
p.timeJuice = 350;

p.timeCenterAcquire = 5000; % ms
p.timeTargetAcquire = 1000;

p.targetHoldWindowSize = 10;
p.centerHoldWindowSize = 20;

p.allowReacquireCenter=0;
p.allowReacquireTarget=0;

hp.centerOutTargetDistance = 90;

%% 20170221

hp.useTargetOnly = false;

p.timeTargetSettle = 300;
p.timeTargetHold = 300;
hp.centerOutTargetSize = 30;

p.centerSize = 30;
p.timeCenterHold = 250;
p.timeCenterSettle =300;
p.timeJuiceCenter = 0;
p.timeJuice = 300;

p.timeCenterAcquire = 5000; % ms
p.timeTargetAcquire = 1000;

p.targetHoldWindowSize = 10;
p.centerHoldWindowSize = 20;

p.allowReacquireCenter=0;
p.allowReacquireTarget=0;
p.allowHandNotSeen=1;

hp.centerOutTargetDistance = 90;

%% 20170222

hp.useTargetOnly = false;

p.timeTargetSettle = 300;
p.timeTargetHold = 300;
hp.centerOutTargetSize = 30;

p.centerSize = 30;
p.timeCenterHold = 250;
p.timeCenterSettle =300;
p.timeJuiceCenter = 0;
p.timeJuice = 300;

p.timeCenterAcquire = 5000; % ms
p.timeTargetAcquire = 1000;

p.targetHoldWindowSize = 10;
p.centerHoldWindowSize = 20;

p.allowReacquireCenter=0;
p.allowReacquireTarget=0;
p.allowHandNotSeen=1;

hp.centerOutTargetDistance = 90;

%% 20170223

hp.useTargetOnly = false;

p.timeTargetSettle = 300;
p.timeTargetHold = 300;
hp.centerOutTargetSize = 20;

p.centerSize = 20;
p.timeCenterHold = 300;
p.timeCenterSettle =300;
p.timeJuiceCenter = 0;
p.timeJuice = 300;

p.timeCenterAcquire = 5000; % ms
p.timeTargetAcquire = 1000;

p.targetHoldWindowSize = 10;
p.centerHoldWindowSize = 20;

p.allowReacquireCenter=1;
p.allowReacquireTarget=0;
p.allowHandNotSeen=1;

hp.centerOutTargetDistance = 90;
%% 20170224

hp.useTargetOnly = false;

p.timeTargetSettle = 300;
p.timeTargetHold = 300;
hp.centerOutTargetSize = 20;

p.centerSize = 20;
p.timeCenterHold = 300;
p.timeCenterSettle =300;
p.timeJuiceCenter = 0;
p.timeJuice = 400;

p.timeCenterAcquire = 3000; % ms
p.timeTargetAcquire = 1000;

p.targetHoldWindowSize = 10;
p.centerHoldWindowSize = 10;

p.allowReacquireCenter=0;
p.allowReacquireTarget=0;
p.allowHandNotSeen=1;

hp.centerOutTargetDistance = 100;
%% 20170227

hp.useTargetOnly = false;

p.timeTargetSettle = 300;
p.timeTargetHold = 300;
hp.centerOutTargetSize = 20;

p.centerSize = 20;
p.timeCenterHold = 300;
p.timeCenterSettle =300;
p.timeJuiceCenter = 0;
p.timeJuice = 350;

p.timeCenterAcquire = 3000; % ms
p.timeTargetAcquire = 1000;

p.targetHoldWindowSize = 10;
p.centerHoldWindowSize = 10;

p.allowReacquireCenter=0;
p.allowReacquireTarget=0;
p.allowHandNotSeen=0;

hp.centerOutTargetDistance = 90;

p.rtMin = 100;
p.rtMax = 500;
%% 20170228

hp.useTargetOnly = false;

p.timeTargetSettle = 300;
p.timeTargetHold = 300;
hp.centerOutTargetSize = 20;

p.centerSize = 20;
p.timeCenterHold = 300;
p.timeCenterSettle =300;
p.timeJuiceCenter = 0;
p.timeJuice = 350;

p.timeCenterAcquire = 3000; % ms
p.timeTargetAcquire = 1000;

p.targetHoldWindowSize = 10;
p.centerHoldWindowSize = 10;

p.allowReacquireCenter=1;
p.allowReacquireTarget=0;
p.allowHandNotSeen=0;

hp.centerOutTargetDistance = 90;

p.rtMin = 0;
p.rtMax = 800;
%% 20170301

hp.useTargetOnly = false;

p.timeTargetSettle = 300;
p.timeTargetHold = 200;
hp.centerOutTargetSize = 20;

p.centerSize = 20;
p.timeCenterHold = 200;
p.timeCenterSettle =300;
p.timeJuiceCenter = 0;
p.timeJuice = 350;

p.timeCenterAcquire = 3000; % ms
p.timeTargetAcquire = 1000;

p.targetHoldWindowSize = 20;
p.centerHoldWindowSize = 20;

p.allowReacquireCenter=1;
p.allowReacquireTarget=0;
p.allowHandNotSeen=1;

hp.centerOutTargetDistance = 90;

p.rtMin = 0;
p.rtMax = 800;

%% 20170301 adding delay period training

rigConfig.moveSpeedThresh = 100; % will go to 40 eventually
p.rtMin = 100;
p.delayVibrateSigma = 40;
hp.fracZeroDelay = 0.5;
hp.fracShortDelay = 0.5;
hp.delayRangeShortMin = 20;
hp.delayRangeShortMax = 400;

%% 20170302

hp.useTargetOnly = false;

p.timeTargetSettle = 300;
p.timeTargetHold = 150;
hp.centerOutTargetSize = 20;

p.centerSize = 20;
p.timeCenterHold = 150;
p.timeCenterSettle =200;
p.timeJuiceCenter = 0;
p.timeJuice = 300;

p.timeCenterAcquire = 3000; % ms
p.timeTargetAcquire = 1000;

p.targetHoldWindowSize = 20;
p.centerHoldWindowSize = 20;

p.allowReacquireCenter=1;
p.allowReacquireTarget=0;
p.allowHandNotSeen=1;

hp.centerOutTargetDistance = 90;

p.rtMin = 100;
p.rtMax = 800;


rigConfig.moveSpeedThresh = 100; % will go to 40 eventually
p.delayVibrateSigma = 60; % sould go down
hp.fracZeroDelay = 0.0;
hp.fracShortDelay = 1.0;
hp.delayRangeShortMin = 20;
hp.delayRangeShortMax = 400;
p.targetHoldWindowSize = 25;
p.timeTargetSettle = 200;
p.timeTargetHold = 200;
p.acceptanceWindowPadding = 12;
%% 20170303

hp.useTargetOnly = false;

p.timeTargetSettle = 300;
p.timeTargetHold = 150;
hp.centerOutTargetSize = 20;

p.centerSize = 20;
p.timeCenterHold = 150;
p.timeCenterSettle =200;
p.timeJuiceCenter = 0;
p.timeJuice = 300;

p.timeCenterAcquire = 3000; % ms
p.timeTargetAcquire = 1000;

p.targetHoldWindowSize = 20;
p.centerHoldWindowSize = 20;

p.allowReacquireCenter=1;
p.allowReacquireTarget=0;
p.allowHandNotSeen=1;

hp.centerOutTargetDistance = 90;

p.rtMin = 100;
p.rtMax = 800;


rigConfig.moveSpeedThresh = 100; % will go to 40 eventually
p.delayVibrateSigma = 60; % sould go down
hp.fracZeroDelay = 0;
hp.fracShortDelay = 1;
hp.delayRangeShortMin = 20;
hp.delayRangeShortMax = 400;
p.targetHoldWindowSize = 25;
p.timeTargetSettle = 200;
p.timeTargetHold = 200;
p.acceptanceWindowPadding = 12;

%% 20170313

hp.useTargetOnly = false;

p.timeTargetSettle = 300;
p.timeTargetHold = 150;
hp.centerOutTargetSize = 20;

p.centerSize = 20;
p.timeCenterHold = 150;
p.timeCenterSettle =200;
p.timeJuiceCenter = 0;
p.timeJuice = 300;

p.timeCenterAcquire = 3000; % ms
p.timeTargetAcquire = 1000;

p.targetHoldWindowSize = 20;
p.centerHoldWindowSize = 20;

p.allowReacquireCenter=1;
p.allowReacquireTarget=0;
p.allowHandNotSeen=1;

hp.centerOutTargetDistance = 90;

p.rtMin = 100;
p.rtMax = 800;


rigConfig.moveSpeedThresh = 100; % will go to 40 eventually
p.delayVibrateSigma = 50; % sould go down
hp.fracZeroDelay = 0;
hp.fracShortDelay = 1;
hp.delayRangeShortMin = 20;
hp.delayRangeShortMax = 400;
p.targetHoldWindowSize = 25;
p.timeTargetSettle = 200;
p.timeTargetHold = 200;
p.acceptanceWindowPadding = 12;

%% 20170314

hp.useTargetOnly = false;

p.timeTargetSettle = 300;
p.timeTargetHold = 150;
hp.centerOutTargetSize = 20;

p.centerSize = 20;
p.timeCenterHold = 150;
p.timeCenterSettle =200;
p.timeJuiceCenter = 0;
p.timeJuice = 350;

p.timeCenterAcquire = 3000; % ms
p.timeTargetAcquire = 1000;

p.targetHoldWindowSize = 20;
p.centerHoldWindowSize = 20;

p.allowReacquireCenter=1;
p.allowReacquireTarget=0;
p.allowHandNotSeen=1;

hp.centerOutTargetDistance = 90;

p.rtMin = 100;
p.rtMax = 800;


rigConfig.moveSpeedThresh = 100; % will go to 40 eventually
p.delayVibrateSigma = 50; % sould go down
hp.fracZeroDelay = 0;
hp.fracShortDelay = 1;
hp.delayRangeShortMin = 20;
hp.delayRangeShortMax = 500;
p.targetHoldWindowSize = 25;
p.timeTargetSettle = 200;
p.timeTargetHold = 300;
p.acceptanceWindowPadding = 12;

%% 20170316

hp.useTargetOnly = false;

p.timeTargetSettle = 300;
p.timeTargetHold = 150;
hp.centerOutTargetSize = 20;

p.centerSize = 20;
p.timeCenterHold = 150;
p.timeCenterSettle =200;
p.timeJuiceCenter = 0;
p.timeJuice = 350;

p.timeCenterAcquire = 3000; % ms
p.timeTargetAcquire = 1000;

p.targetHoldWindowSize = 20;
p.centerHoldWindowSize = 20;

p.allowReacquireCenter=1;
p.allowReacquireTarget=0;
p.allowHandNotSeen=1;

hp.centerOutTargetDistance = 90;

p.rtMin = 100;
p.rtMax = 800;


rigConfig.moveSpeedThresh = 100; % will go to 40 eventually
p.delayVibrateSigma = 50; % sould go down
hp.fracZeroDelay = 0;
hp.fracShortDelay = 1;
hp.delayRangeShortMin = 20;
hp.delayRangeShortMax = 500;
p.targetHoldWindowSize = 25;
p.timeTargetSettle = 200;
p.timeTargetHold = 300;
p.acceptanceWindowPadding = 12;

%% 20170317

hp.useTargetOnly = false;

p.timeTargetSettle = 300;
p.timeTargetHold = 150;
hp.centerOutTargetSize = 20;

p.centerSize = 20;
p.timeCenterHold = 150;
p.timeCenterSettle =200;
p.timeJuiceCenter = 0;
p.timeJuice = 350;

p.timeCenterAcquire = 3000; % ms
p.timeTargetAcquire = 1000;

p.targetHoldWindowSize = 20;
p.centerHoldWindowSize = 20;

p.allowReacquireCenter=1;
p.allowReacquireTarget=0;
p.allowHandNotSeen=1;

hp.centerOutTargetDistance = 90;

p.rtMin = 100;
p.rtMax = 800;


rigConfig.moveSpeedThresh = 100; % will go to 40 eventually
p.delayVibrateSigma = 60; % sould go down
hp.fracZeroDelay = 0;
hp.fracShortDelay = 1;
hp.delayRangeShortMin = 20;
hp.delayRangeShortMax = 500;
p.targetHoldWindowSize = 25;
p.timeTargetSettle = 200;
p.timeTargetHold = 300;
p.acceptanceWindowPadding = 12;

%% 20170318

hp.useTargetOnly = false;

p.timeTargetSettle = 300;
p.timeTargetHold = 150;
hp.centerOutTargetSize = 20;

p.centerSize = 20;
p.timeCenterHold = 150;
p.timeCenterSettle =200;
p.timeJuiceCenter = 0;
p.timeJuice = 350;

p.timeCenterAcquire = 3000; % ms
p.timeTargetAcquire = 1000;

p.targetHoldWindowSize = 20;
p.centerHoldWindowSize = 20;

p.allowReacquireCenter=1;
p.allowReacquireTarget=0;
p.allowHandNotSeen=1;

hp.centerOutTargetDistance = 90;

p.rtMin = 100;
p.rtMax = 800;


rigConfig.moveSpeedThresh = 100; % will go to 40 eventually
p.delayVibrateSigma = 60; % sould go down
hp.fracZeroDelay = 0;
hp.fracShortDelay = 1;
hp.delayRangeShortMin = 20;
hp.delayRangeShortMax = 500;
p.targetHoldWindowSize = 25;
p.timeTargetSettle = 200;
p.timeTargetHold = 300;
p.acceptanceWindowPadding = 12;

%% 20170324

hp.useTargetOnly = false;

p.timeTargetSettle = 300;
p.timeTargetHold = 150;
hp.centerOutTargetSize = 20;

p.centerSize = 20;
p.timeCenterHold = 150;
p.timeCenterSettle =200;
p.timeJuiceCenter = 0;
p.timeJuice = 380;

p.timeCenterAcquire = 3000; % ms
p.timeTargetAcquire = 1000;

p.targetHoldWindowSize = 20;
p.centerHoldWindowSize = 20;

p.allowReacquireCenter=1;
p.allowReacquireTarget=0;
p.allowHandNotSeen=1;

hp.centerOutTargetDistance = 100;

p.rtMin = 100;
p.rtMax = 800;


rigConfig.moveSpeedThresh = 100; % will go to 40 eventually
p.delayVibrateSigma = 70; % sould go down
hp.fracZeroDelay = 0;
hp.fracShortDelay = 1;
hp.delayRangeShortMin = 20;
hp.delayRangeShortMax = 500;
p.targetHoldWindowSize = 25;
p.timeTargetSettle = 200;
p.timeTargetHold = 300;
p.acceptanceWindowPadding = 12;

%% 20170327

hp.useTargetOnly = false;

p.timeTargetSettle = 300;
p.timeTargetHold = 150;
hp.centerOutTargetSize = 20;

p.centerSize = 20;
p.timeCenterHold = 150;
p.timeCenterSettle =200;
p.timeJuiceCenter = 0;
p.timeJuice = 350;

p.timeCenterAcquire = 3000; % ms
p.timeTargetAcquire = 1000;

p.targetHoldWindowSize = 30;
p.centerHoldWindowSize = 30;

p.allowReacquireCenter=1;
p.allowReacquireTarget=0;
p.allowHandNotSeen=1;

hp.centerOutTargetDistance = 90;

p.rtMin = 100;
p.rtMax = 800;


rigConfig.moveSpeedThresh = 100; % will go to 40 eventually
p.delayVibrateSigma = 70; % sould go down
hp.fracZeroDelay = 0;
hp.fracShortDelay = 1;
hp.delayRangeShortMin = 20;
hp.delayRangeShortMax = 400;
p.targetHoldWindowSize = 25;
p.timeTargetSettle = 200;
p.timeTargetHold = 300;
p.acceptanceWindowPadding = 12;

%% 20170328

hp.useTargetOnly = false;

p.timeTargetSettle = 300;
p.timeTargetHold = 150;
hp.centerOutTargetSize = 25;

p.centerSize = 25;
p.timeCenterHold = 150;
p.timeCenterSettle =200;
p.timeJuiceCenter = 0;
p.timeJuice = 400;

p.timeCenterAcquire = 3000; % ms
p.timeTargetAcquire = 1000;

p.targetHoldWindowSize = 30;
p.centerHoldWindowSize = 30;

p.allowReacquireCenter=1;
p.allowReacquireTarget=0;
p.allowHandNotSeen=1;

hp.centerOutTargetDistance = 100;

p.rtMin = 100;
p.rtMax = 800;


rigConfig.moveSpeedThresh = 100; % will go to 40 eventually
p.delayVibrateSigma = 70; % sould go down
hp.fracZeroDelay = 0;
hp.fracShortDelay = 1;
hp.delayRangeShortMin = 20;
hp.delayRangeShortMax = 500;
p.targetHoldWindowSize = 25;
p.timeTargetSettle = 200;
p.timeTargetHold = 300;
p.acceptanceWindowPadding = 12;

%% 20170329

hp.useTargetOnly = false;

p.timeTargetSettle = 300;
p.timeTargetHold = 150;
hp.centerOutTargetSize = 25;

p.centerSize = 25;
p.timeCenterHold = 150;
p.timeCenterSettle =200;
p.timeJuiceCenter = 0;
p.timeJuice = 400;

p.timeCenterAcquire = 3000; % ms
p.timeTargetAcquire = 1000;

p.targetHoldWindowSize = 30;
p.centerHoldWindowSize = 30;

p.allowReacquireCenter=1;
p.allowReacquireTarget=0;
p.allowHandNotSeen=1;

hp.centerOutTargetDistance = 100;

p.rtMin = 10;
p.rtMax = 800;


rigConfig.moveSpeedThresh = 100; % will go to 40 eventually
p.delayVibrateSigma = 50; % sould go down
hp.fracZeroDelay = 0;
hp.fracShortDelay = 1;
hp.delayRangeShortMin = 20;
hp.delayRangeShortMax = 600;
p.targetHoldWindowSize = 25;
p.timeTargetSettle = 200;
p.timeTargetHold = 300;
p.acceptanceWindowPadding = 12;

%% 20170329

hp.useTargetOnly = false;

p.timeTargetSettle = 300;
p.timeTargetHold = 150;
hp.centerOutTargetSize = 25;

p.centerSize = 25;
p.timeCenterHold = 150;
p.timeCenterSettle =200;
p.timeJuiceCenter = 0;
p.timeJuice = 350;

p.timeCenterAcquire = 3000; % ms
p.timeTargetAcquire = 1000;

p.targetHoldWindowSize = 30;
p.centerHoldWindowSize = 30;

p.allowReacquireCenter=1;
p.allowReacquireTarget=0;
p.allowHandNotSeen=1;

hp.centerOutTargetDistance = 100;

p.rtMin = 10;
p.rtMax = 800;


rigConfig.moveSpeedThresh = 100; % will go to 40 eventually
p.delayVibrateSigma = 50; % sould go down
hp.fracZeroDelay = 0;
hp.fracShortDelay = 1;
hp.delayRangeShortMin = 20;
hp.delayRangeShortMax = 600;
p.targetHoldWindowSize = 25;
p.timeTargetSettle = 200;
p.timeTargetHold = 300;
p.acceptanceWindowPadding = 12;

%% 20170402

hp.useTargetOnly = false;

p.timeTargetSettle = 300;
p.timeTargetHold = 150;
hp.centerOutTargetSize = 30;

p.centerSize = 30;
p.timeCenterHold = 150;
p.timeCenterSettle =200;
p.timeJuiceCenter = 0;
p.timeJuice = 400;

p.timeCenterAcquire = 3000; % ms
p.timeTargetAcquire = 1000;

p.targetHoldWindowSize = 30;
p.centerHoldWindowSize = 30;

p.allowReacquireCenter=1;
p.allowReacquireTarget=0;
p.allowHandNotSeen=1;

hp.centerOutTargetDistance = 100;

p.rtMin = 10;
p.rtMax = 800;


rigConfig.moveSpeedThresh = 100; % will go to 40 eventually
p.delayVibrateSigma = 30; % sould go down
hp.fracZeroDelay = 0;
hp.fracShortDelay = 1;
hp.delayRangeShortMin = 200;
hp.delayRangeShortMax = 600;
p.targetHoldWindowSize = 25;
p.timeTargetSettle = 200;
p.timeTargetHold = 300;
p.acceptanceWindowPadding = 12;

%% 20170402

hp.useTargetOnly = false;

p.timeTargetSettle = 300;
p.timeTargetHold = 150;
hp.centerOutTargetSize = 30;

p.centerSize = 30;
p.timeCenterHold = 150;
p.timeCenterSettle =200;
p.timeJuiceCenter = 0;
p.timeJuice = 500;

p.timeCenterAcquire = 3000; % ms
p.timeTargetAcquire = 1000;

p.targetHoldWindowSize = 30;
p.centerHoldWindowSize = 30;

p.allowReacquireCenter=1;
p.allowReacquireTarget=0;
p.allowHandNotSeen=1;

hp.centerOutTargetDistance = 100;

p.rtMin = 10;
p.rtMax = 800;


rigConfig.moveSpeedThresh = 100; % will go to 40 eventually
p.delayVibrateSigma = 20; % sould go down
hp.fracZeroDelay = 0.1;
hp.fracShortDelay = 0.9;
hp.delayRangeShortMin = 200;
hp.delayRangeShortMax =  400;
p.targetHoldWindowSize = 25;
p.timeTargetSettle = 200;
p.timeTargetHold = 300;
p.acceptanceWindowPadding = 12;

%% 201704024

hp.useTargetOnly = false;

p.timeTargetSettle = 300;
p.timeTargetHold = 150;
hp.centerOutTargetSize = 30;

p.centerSize = 30;
p.timeCenterHold = 150;
p.timeCenterSettle =200;
p.timeJuiceCenter = 0;
p.timeJuice = 300;

p.timeCenterAcquire = 3000; % ms
p.timeTargetAcquire = 1000;

p.targetHoldWindowSize = 30;
p.centerHoldWindowSize = 30;

p.allowReacquireCenter=1;
p.allowReacquireTarget=0;
p.allowHandNotSeen=1;

hp.centerOutTargetDistance = 100;

p.rtMin = 10;
p.rtMax = 800;


rigConfig.moveSpeedThresh = 100; % will go to 40 eventually
p.delayVibrateSigma = 20; % sould go down
hp.fracZeroDelay = 0.1;
hp.fracShortDelay = 0.9;
hp.delayRangeShortMin = 200;
hp.delayRangeShortMax =  400;
p.targetHoldWindowSize = 25;
p.timeTargetSettle = 200;
p.timeTargetHold = 300;
p.acceptanceWindowPadding = 12;

%% 201704025

hp.useTargetOnly = false;

p.timeTargetSettle = 300;
p.timeTargetHold = 150;
hp.centerOutTargetSize = 30;

p.centerSize = 30;
p.timeCenterHold = 150;
p.timeCenterSettle =200;
p.timeJuiceCenter = 0;
p.timeJuice = 150;

p.timeCenterAcquire = 3000; % ms
p.timeTargetAcquire = 1000;

p.targetHoldWindowSize = 40;
p.centerHoldWindowSize = 40;

p.allowReacquireCenter=1;
p.allowReacquireTarget=0;
p.allowHandNotSeen=0;

hp.centerOutTargetDistance = 90;

p.rtMin = 10; 
p.rtMax = 800;


rigConfig.moveSpeedThresh = 100; % will go to 40 eventually
p.delayVibrateSigma = 3; % should go down
hp.fracZeroDelay = 0.1;
hp.fracShortDelay = 0.9;
hp.delayRangeShortMin = 10;      
hp.delayRangeShortMax = 600;
p.targetHoldWindowSize = 40;
p.timeTargetSettle = 200;
p.timeTargetHold = 300;
p.acceptanceWindowPadding = 12;
%% 20170616

hp.useTargetOnly = false;

p.timeTargetSettle = 300;
p.timeTargetHold = 150;
hp.centerOutTargetSize = 30;

p.centerSize = 30;
p.timeCenterHold = 150;
p.timeCenterSettle =200;
p.timeJuiceCenter = 0;
p.timeJuice = 150;

p.timeCenterAcquire = 3000; % ms
p.timeTargetAcquire = 900;

p.targetHoldWindowSize = 20;
p.centerHoldWindowSize = 20; % can go down to 10

p.allowReacquireCenter=0;
p.allowReacquireTarget=0;
p.allowHandNotSeen=0;

hp.centerOutTargetDistance = 90;

p.rtMin = 180; 
p.rtMax = 620;


rigConfig.moveSpeedThresh = 60; % will go to 40 eventually
p.delayVibrateSigma = 3; % should go down
hp.fracZeroDelay = 0.1;
hp.fracShortDelay = 0.9;
hp.delayRangeShortMin = 100;      
hp.delayRangeShortMax = 700;
p.targetHoldWindowSize = 40;
p.timeTargetSettle = 200;
p.timeTargetHold = 250;
p.acceptanceWindowPadding = 12;
%% Update data logger
crc.rigConfig = rigConfig;
crc.param = p;
crc.setConditionHyperparameters(hp);
crc.setDataLoggerXavier();
