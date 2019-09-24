home = char(java.lang.System.getProperty('user.home'));
root = fullfile(home, 'code');

sWarn = warning('OFF', 'MATLAB:rmpath:DirNotFound');
rmpath(genpath(fullfile(root, 'rig1\tasks\')));
addpath(fullfile(root, 'rig1\tasks'));
addpath(genpath(fullfile(root, 'rig1\tasks\CenterOutReach\v20170705')));
% addpath(genpath(fullfile(root, 'rig1\tasks\CenterOutReach\v20160208')));
addpath(genpath(fullfile(root, 'rig1\bruker')));
addpath(genpath(fullfile(root, 'rig1\mOEG')));
addpath(genpath(fullfile(root, 'rig1\xpc')));
addpath(genpath(fullfile(root, 'matudp')));

warning(sWarn);

addpath(fullfile(root, 'rig1\tasks'));


