function [C, repeats] = buildConditions(hp)

%% Condition Hyperparameters
% define defaults here, then override them with the hyper-parameters
% passed
assert(isa(hp, 'CenterOutReachConditionHyperparameters'));

%% Common condition info

f = struct();
v = struct();

% meta parameters
v.fracZeroDelay = hp.fracZeroDelay;
v.delayRangeMin = hp.delayRangeMin;
v.delayRangeMax = hp.delayRangeMax;
v.fracShortDelay = hp.fracShortDelay;
v.delayRangeShortMin = hp.delayRangeShortMin;
v.delayRangeShortMax = hp.delayRangeShortMax;
v.delayRangeLongMin = hp.delayRangeLongMin;
v.delayRangeLongMax = hp.delayRangeLongMax;

v.enforceMinPeakVelocity = uint8(hp.enforceMinPeakVelocity);

% center location for non-center out reaches
v.centerX = hp.centerX;
v.centerY = hp.centerY;
v.delayNominal = 0;

% target location/shape specification
v.targetX = 0;
v.targetY = 0;
v.targetDistance = hp.centerOutTargetDistance;
v.targetDirectionName = DirectionName.None; % for all non center out reaches
v.targetSize = hp.centerOutTargetSize;
v.targetAcceptanceSize = hp.centerOutTargetAcceptanceSize;

v.hasCenterTouch = ~hp.useTargetOnly;

v.juiceDuringTargetHold = hp.juiceDuringTargetHold;

if v.hasCenterTouch
    v.trialCategory = TrialCategory.CenterOut;
else
    v.trialCategory = TrialCategory.TargetOnly;
end
v.hasImaging = uint8(0);

% generate initial condition tree with only one condition
C = generateConditionBlockFromRelativeFrequencies(v, f);

% split into 8 targets
match = struct('trialCategory', [TrialCategory.CenterOut, TrialCategory.TargetOnly]);
vMatch = struct('targetDirectionName', hp.centerOutTargetDirectionList);
C = insertConditionalConditionBlock(C, match, vMatch, 'preserveRelativeFrequencies', false);

% assign targetDirection based on targetDirectionName
match = struct();
vMatch = struct('targetDirection', @(c) c.targetDirectionName.getAngleFromPosX());
C = insertConditionalConditionBlock(C, match, vMatch);

% position the targetX and targetY accordingly
match = struct('trialCategory', [TrialCategory.CenterOut, TrialCategory.TargetOnly]);
vMatch = struct('targetX', @(c) c.centerX + c.targetDistance * cos(c.targetDirection), ...
                'targetY', @(c) c.centerY + c.targetDistance * sin(c.targetDirection));
C = insertConditionalConditionBlock(C, match, vMatch);

%% Add condition metadata

function s = buildConditionDescription(c)
    switch c.trialCategory
        case [TrialCategory.CenterOut]
            s = sprintf('CenterOut %s', char(c.targetDirectionName));
        case [TrialCategory.TargetOnly]
            s = sprintf('TargetOnly %s', char(c.targetDirectionName));
        otherwise
            s = 'Unknown';
    end
end
         
for iC = 1:numel(C)
    C(iC).conditionDesc = buildConditionDescription(C(iC));
end

% Add condition Ids
for iC = 1:numel(C)
    C(iC).conditionId = uint16(iC);
end
 
% Strip off condition repeats field and replace with conditionProportion
% field
repeats = [C.conditionRepeats];
% repeats(4) = 0;
C = rmfield(C, 'conditionRepeats');
for iC = 1:numel(C)
    C(iC).conditionProportion = double(repeats(iC)) / sum(repeats);
end

end

