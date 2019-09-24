%% Load BlockInfoBus
% fprintf('Running libConditions_Initialize()...\n');
if ~exist('BlockInfoBus', 'var')
    blockInfo.nTrialsRemaining = uint16(0);
    blockInfo.nBlocksCompleted = uint16(0);
    createBusBaseWorkspace('BlockInfoBus', blockInfo);
end