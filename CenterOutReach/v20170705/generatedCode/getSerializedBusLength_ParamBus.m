function outSize = getSerializedBusLength_ParamBus(bus, namePrefix)
%#codegen
% DO NOT EDIT: Auto-generated by 
%   BusSerialize.writeGetSerializedBusLengthCode('ParamBus')

    if nargin < 2, namePrefix = uint8(''); end
    namePrefixBytes = uint8(namePrefix(:))';
    outSize = uint32(0);
    % element timeImagingStartBeforeTargetOnset
    outSize = outSize + uint32(1); % bit flags
    outSize = outSize + uint32(1); % signal type
    outSize = outSize + uint32(2 + numel(namePrefixBytes) + 33); % for name (including prefix)
    outSize = outSize + uint32(2 + 2); % for units
    outSize = outSize + uint32(1); % for data type id
    outSize = outSize + uint32(1 + 2*1); % for dimensions
    outSize = outSize + uint32(4 * numel(bus.timeImagingStartBeforeTargetOnset)); % for timeImagingStartBeforeTargetOnset data 

    % element timeCenterAcquire
    outSize = outSize + uint32(1); % bit flags
    outSize = outSize + uint32(1); % signal type
    outSize = outSize + uint32(2 + numel(namePrefixBytes) + 17); % for name (including prefix)
    outSize = outSize + uint32(2 + 2); % for units
    outSize = outSize + uint32(1); % for data type id
    outSize = outSize + uint32(1 + 2*1); % for dimensions
    outSize = outSize + uint32(4 * numel(bus.timeCenterAcquire)); % for timeCenterAcquire data 

    % element timeCenterSettle
    outSize = outSize + uint32(1); % bit flags
    outSize = outSize + uint32(1); % signal type
    outSize = outSize + uint32(2 + numel(namePrefixBytes) + 16); % for name (including prefix)
    outSize = outSize + uint32(2 + 2); % for units
    outSize = outSize + uint32(1); % for data type id
    outSize = outSize + uint32(1 + 2*1); % for dimensions
    outSize = outSize + uint32(4 * numel(bus.timeCenterSettle)); % for timeCenterSettle data 

    % element timeCenterHold
    outSize = outSize + uint32(1); % bit flags
    outSize = outSize + uint32(1); % signal type
    outSize = outSize + uint32(2 + numel(namePrefixBytes) + 14); % for name (including prefix)
    outSize = outSize + uint32(2 + 2); % for units
    outSize = outSize + uint32(1); % for data type id
    outSize = outSize + uint32(1 + 2*1); % for dimensions
    outSize = outSize + uint32(4 * numel(bus.timeCenterHold)); % for timeCenterHold data 

    % element rtMin
    outSize = outSize + uint32(1); % bit flags
    outSize = outSize + uint32(1); % signal type
    outSize = outSize + uint32(2 + numel(namePrefixBytes) + 5); % for name (including prefix)
    outSize = outSize + uint32(2 + 2); % for units
    outSize = outSize + uint32(1); % for data type id
    outSize = outSize + uint32(1 + 2*1); % for dimensions
    outSize = outSize + uint32(4 * numel(bus.rtMin)); % for rtMin data 

    % element rtMax
    outSize = outSize + uint32(1); % bit flags
    outSize = outSize + uint32(1); % signal type
    outSize = outSize + uint32(2 + numel(namePrefixBytes) + 5); % for name (including prefix)
    outSize = outSize + uint32(2 + 2); % for units
    outSize = outSize + uint32(1); % for data type id
    outSize = outSize + uint32(1 + 2*1); % for dimensions
    outSize = outSize + uint32(4 * numel(bus.rtMax)); % for rtMax data 

    % element timeTargetAcquire
    outSize = outSize + uint32(1); % bit flags
    outSize = outSize + uint32(1); % signal type
    outSize = outSize + uint32(2 + numel(namePrefixBytes) + 17); % for name (including prefix)
    outSize = outSize + uint32(2 + 2); % for units
    outSize = outSize + uint32(1); % for data type id
    outSize = outSize + uint32(1 + 2*1); % for dimensions
    outSize = outSize + uint32(4 * numel(bus.timeTargetAcquire)); % for timeTargetAcquire data 

    % element timeTargetSettle
    outSize = outSize + uint32(1); % bit flags
    outSize = outSize + uint32(1); % signal type
    outSize = outSize + uint32(2 + numel(namePrefixBytes) + 16); % for name (including prefix)
    outSize = outSize + uint32(2 + 2); % for units
    outSize = outSize + uint32(1); % for data type id
    outSize = outSize + uint32(1 + 2*1); % for dimensions
    outSize = outSize + uint32(4 * numel(bus.timeTargetSettle)); % for timeTargetSettle data 

    % element timeTargetHold
    outSize = outSize + uint32(1); % bit flags
    outSize = outSize + uint32(1); % signal type
    outSize = outSize + uint32(2 + numel(namePrefixBytes) + 14); % for name (including prefix)
    outSize = outSize + uint32(2 + 2); % for units
    outSize = outSize + uint32(1); % for data type id
    outSize = outSize + uint32(1 + 2*1); % for dimensions
    outSize = outSize + uint32(4 * numel(bus.timeTargetHold)); % for timeTargetHold data 

    % element timeJuice
    outSize = outSize + uint32(1); % bit flags
    outSize = outSize + uint32(1); % signal type
    outSize = outSize + uint32(2 + numel(namePrefixBytes) + 9); % for name (including prefix)
    outSize = outSize + uint32(2 + 2); % for units
    outSize = outSize + uint32(1); % for data type id
    outSize = outSize + uint32(1 + 2*1); % for dimensions
    outSize = outSize + uint32(4 * numel(bus.timeJuice)); % for timeJuice data 

    % element timeJuiceCenter
    outSize = outSize + uint32(1); % bit flags
    outSize = outSize + uint32(1); % signal type
    outSize = outSize + uint32(2 + numel(namePrefixBytes) + 15); % for name (including prefix)
    outSize = outSize + uint32(2 + 2); % for units
    outSize = outSize + uint32(1); % for data type id
    outSize = outSize + uint32(1 + 2*1); % for dimensions
    outSize = outSize + uint32(4 * numel(bus.timeJuiceCenter)); % for timeJuiceCenter data 

    % element timeJuiceDecodeSuccess
    outSize = outSize + uint32(1); % bit flags
    outSize = outSize + uint32(1); % signal type
    outSize = outSize + uint32(2 + numel(namePrefixBytes) + 22); % for name (including prefix)
    outSize = outSize + uint32(2 + 2); % for units
    outSize = outSize + uint32(1); % for data type id
    outSize = outSize + uint32(1 + 2*1); % for dimensions
    outSize = outSize + uint32(4 * numel(bus.timeJuiceDecodeSuccess)); % for timeJuiceDecodeSuccess data 

    % element timeRewardFeedback
    outSize = outSize + uint32(1); % bit flags
    outSize = outSize + uint32(1); % signal type
    outSize = outSize + uint32(2 + numel(namePrefixBytes) + 18); % for name (including prefix)
    outSize = outSize + uint32(2 + 2); % for units
    outSize = outSize + uint32(1); % for data type id
    outSize = outSize + uint32(1 + 2*1); % for dimensions
    outSize = outSize + uint32(4 * numel(bus.timeRewardFeedback)); % for timeRewardFeedback data 

    % element timeFailureFeedback
    outSize = outSize + uint32(1); % bit flags
    outSize = outSize + uint32(1); % signal type
    outSize = outSize + uint32(2 + numel(namePrefixBytes) + 19); % for name (including prefix)
    outSize = outSize + uint32(2 + 2); % for units
    outSize = outSize + uint32(1); % for data type id
    outSize = outSize + uint32(1 + 2*1); % for dimensions
    outSize = outSize + uint32(4 * numel(bus.timeFailureFeedback)); % for timeFailureFeedback data 

    % element itiSuccess
    outSize = outSize + uint32(1); % bit flags
    outSize = outSize + uint32(1); % signal type
    outSize = outSize + uint32(2 + numel(namePrefixBytes) + 10); % for name (including prefix)
    outSize = outSize + uint32(2 + 2); % for units
    outSize = outSize + uint32(1); % for data type id
    outSize = outSize + uint32(1 + 2*1); % for dimensions
    outSize = outSize + uint32(4 * numel(bus.itiSuccess)); % for itiSuccess data 

    % element itiFailure
    outSize = outSize + uint32(1); % bit flags
    outSize = outSize + uint32(1); % signal type
    outSize = outSize + uint32(2 + numel(namePrefixBytes) + 10); % for name (including prefix)
    outSize = outSize + uint32(2 + 2); % for units
    outSize = outSize + uint32(1); % for data type id
    outSize = outSize + uint32(1 + 2*1); % for dimensions
    outSize = outSize + uint32(4 * numel(bus.itiFailure)); % for itiFailure data 

    % element repeatUntilSuccess
    outSize = outSize + uint32(1); % bit flags
    outSize = outSize + uint32(1); % signal type
    outSize = outSize + uint32(2 + numel(namePrefixBytes) + 18); % for name (including prefix)
    outSize = outSize + uint32(2 + 0); % for units
    outSize = outSize + uint32(1); % for data type id
    outSize = outSize + uint32(1 + 2*1); % for dimensions
    outSize = outSize + uint32(1 * numel(bus.repeatUntilSuccess)); % for repeatUntilSuccess data 

    % element delayVibrateSigma
    outSize = outSize + uint32(1); % bit flags
    outSize = outSize + uint32(1); % signal type
    outSize = outSize + uint32(2 + numel(namePrefixBytes) + 17); % for name (including prefix)
    outSize = outSize + uint32(2 + 2); % for units
    outSize = outSize + uint32(1); % for data type id
    outSize = outSize + uint32(1 + 2*1); % for dimensions
    outSize = outSize + uint32(8 * numel(bus.delayVibrateSigma)); % for delayVibrateSigma data 

    % element purgatoryTime
    outSize = outSize + uint32(1); % bit flags
    outSize = outSize + uint32(1); % signal type
    outSize = outSize + uint32(2 + numel(namePrefixBytes) + 13); % for name (including prefix)
    outSize = outSize + uint32(2 + 2); % for units
    outSize = outSize + uint32(1); % for data type id
    outSize = outSize + uint32(1 + 2*1); % for dimensions
    outSize = outSize + uint32(4 * numel(bus.purgatoryTime)); % for purgatoryTime data 

    % element purgatoryConsecutiveNoStarts
    outSize = outSize + uint32(1); % bit flags
    outSize = outSize + uint32(1); % signal type
    outSize = outSize + uint32(2 + numel(namePrefixBytes) + 28); % for name (including prefix)
    outSize = outSize + uint32(2 + 0); % for units
    outSize = outSize + uint32(1); % for data type id
    outSize = outSize + uint32(1 + 2*1); % for dimensions
    outSize = outSize + uint32(2 * numel(bus.purgatoryConsecutiveNoStarts)); % for purgatoryConsecutiveNoStarts data 

    % element centerSize
    outSize = outSize + uint32(1); % bit flags
    outSize = outSize + uint32(1); % signal type
    outSize = outSize + uint32(2 + numel(namePrefixBytes) + 10); % for name (including prefix)
    outSize = outSize + uint32(2 + 2); % for units
    outSize = outSize + uint32(1); % for data type id
    outSize = outSize + uint32(1 + 2*1); % for dimensions
    outSize = outSize + uint32(8 * numel(bus.centerSize)); % for centerSize data 

    % element centerHoldWindowSize
    outSize = outSize + uint32(1); % bit flags
    outSize = outSize + uint32(1); % signal type
    outSize = outSize + uint32(2 + numel(namePrefixBytes) + 20); % for name (including prefix)
    outSize = outSize + uint32(2 + 2); % for units
    outSize = outSize + uint32(1); % for data type id
    outSize = outSize + uint32(1 + 2*1); % for dimensions
    outSize = outSize + uint32(8 * numel(bus.centerHoldWindowSize)); % for centerHoldWindowSize data 

    % element targetHoldWindowSize
    outSize = outSize + uint32(1); % bit flags
    outSize = outSize + uint32(1); % signal type
    outSize = outSize + uint32(2 + numel(namePrefixBytes) + 20); % for name (including prefix)
    outSize = outSize + uint32(2 + 2); % for units
    outSize = outSize + uint32(1); % for data type id
    outSize = outSize + uint32(1 + 2*1); % for dimensions
    outSize = outSize + uint32(8 * numel(bus.targetHoldWindowSize)); % for targetHoldWindowSize data 

    % element acceptanceWindowPadding
    outSize = outSize + uint32(1); % bit flags
    outSize = outSize + uint32(1); % signal type
    outSize = outSize + uint32(2 + numel(namePrefixBytes) + 23); % for name (including prefix)
    outSize = outSize + uint32(2 + 2); % for units
    outSize = outSize + uint32(1); % for data type id
    outSize = outSize + uint32(1 + 2*1); % for dimensions
    outSize = outSize + uint32(8 * numel(bus.acceptanceWindowPadding)); % for acceptanceWindowPadding data 

    % element distanceTowardsTargetThresh
    outSize = outSize + uint32(1); % bit flags
    outSize = outSize + uint32(1); % signal type
    outSize = outSize + uint32(2 + numel(namePrefixBytes) + 27); % for name (including prefix)
    outSize = outSize + uint32(2 + 0); % for units
    outSize = outSize + uint32(1); % for data type id
    outSize = outSize + uint32(1 + 2*1); % for dimensions
    outSize = outSize + uint32(8 * numel(bus.distanceTowardsTargetThresh)); % for distanceTowardsTargetThresh data 

    % element velocityTowardsTargetThresh
    outSize = outSize + uint32(1); % bit flags
    outSize = outSize + uint32(1); % signal type
    outSize = outSize + uint32(2 + numel(namePrefixBytes) + 27); % for name (including prefix)
    outSize = outSize + uint32(2 + 0); % for units
    outSize = outSize + uint32(1); % for data type id
    outSize = outSize + uint32(1 + 2*1); % for dimensions
    outSize = outSize + uint32(8 * numel(bus.velocityTowardsTargetThresh)); % for velocityTowardsTargetThresh data 

    % element threshAcceleration
    outSize = outSize + uint32(1); % bit flags
    outSize = outSize + uint32(1); % signal type
    outSize = outSize + uint32(2 + numel(namePrefixBytes) + 18); % for name (including prefix)
    outSize = outSize + uint32(2 + 8); % for units
    outSize = outSize + uint32(1); % for data type id
    outSize = outSize + uint32(1 + 2*1); % for dimensions
    outSize = outSize + uint32(8 * numel(bus.threshAcceleration)); % for threshAcceleration data 

    % element decelerationThreshRatio
    outSize = outSize + uint32(1); % bit flags
    outSize = outSize + uint32(1); % signal type
    outSize = outSize + uint32(2 + numel(namePrefixBytes) + 23); % for name (including prefix)
    outSize = outSize + uint32(2 + 0); % for units
    outSize = outSize + uint32(1); % for data type id
    outSize = outSize + uint32(1 + 2*1); % for dimensions
    outSize = outSize + uint32(8 * numel(bus.decelerationThreshRatio)); % for decelerationThreshRatio data 

    % element reaccelerationThreshDelta
    outSize = outSize + uint32(1); % bit flags
    outSize = outSize + uint32(1); % signal type
    outSize = outSize + uint32(2 + numel(namePrefixBytes) + 25); % for name (including prefix)
    outSize = outSize + uint32(2 + 8); % for units
    outSize = outSize + uint32(1); % for data type id
    outSize = outSize + uint32(1 + 2*1); % for dimensions
    outSize = outSize + uint32(8 * numel(bus.reaccelerationThreshDelta)); % for reaccelerationThreshDelta data 

    % element minPeakVelocityTowardsTarget
    outSize = outSize + uint32(1); % bit flags
    outSize = outSize + uint32(1); % signal type
    outSize = outSize + uint32(2 + numel(namePrefixBytes) + 28); % for name (including prefix)
    outSize = outSize + uint32(2 + 6); % for units
    outSize = outSize + uint32(1); % for data type id
    outSize = outSize + uint32(1 + 2*1); % for dimensions
    outSize = outSize + uint32(8 * numel(bus.minPeakVelocityTowardsTarget)); % for minPeakVelocityTowardsTarget data 

    % element targetHoldJuiceSize
    outSize = outSize + uint32(1); % bit flags
    outSize = outSize + uint32(1); % signal type
    outSize = outSize + uint32(2 + numel(namePrefixBytes) + 19); % for name (including prefix)
    outSize = outSize + uint32(2 + 2); % for units
    outSize = outSize + uint32(1); % for data type id
    outSize = outSize + uint32(1 + 2*1); % for dimensions
    outSize = outSize + uint32(8 * numel(bus.targetHoldJuiceSize)); % for targetHoldJuiceSize data 

    % element targetHoldJuiceInterval
    outSize = outSize + uint32(1); % bit flags
    outSize = outSize + uint32(1); % signal type
    outSize = outSize + uint32(2 + numel(namePrefixBytes) + 23); % for name (including prefix)
    outSize = outSize + uint32(2 + 2); % for units
    outSize = outSize + uint32(1); % for data type id
    outSize = outSize + uint32(1 + 2*1); % for dimensions
    outSize = outSize + uint32(8 * numel(bus.targetHoldJuiceInterval)); % for targetHoldJuiceInterval data 

    % element allowHandNotSeen
    outSize = outSize + uint32(1); % bit flags
    outSize = outSize + uint32(1); % signal type
    outSize = outSize + uint32(2 + numel(namePrefixBytes) + 16); % for name (including prefix)
    outSize = outSize + uint32(2 + 0); % for units
    outSize = outSize + uint32(1); % for data type id
    outSize = outSize + uint32(1 + 2*1); % for dimensions
    outSize = outSize + uint32(1 * numel(bus.allowHandNotSeen)); % for allowHandNotSeen data 

    % element allowReacquireCenter
    outSize = outSize + uint32(1); % bit flags
    outSize = outSize + uint32(1); % signal type
    outSize = outSize + uint32(2 + numel(namePrefixBytes) + 20); % for name (including prefix)
    outSize = outSize + uint32(2 + 0); % for units
    outSize = outSize + uint32(1); % for data type id
    outSize = outSize + uint32(1 + 2*1); % for dimensions
    outSize = outSize + uint32(1 * numel(bus.allowReacquireCenter)); % for allowReacquireCenter data 

    % element allowReacquireTarget
    outSize = outSize + uint32(1); % bit flags
    outSize = outSize + uint32(1); % signal type
    outSize = outSize + uint32(2 + numel(namePrefixBytes) + 20); % for name (including prefix)
    outSize = outSize + uint32(2 + 0); % for units
    outSize = outSize + uint32(1); % for data type id
    outSize = outSize + uint32(1 + 2*1); % for dimensions
    outSize = outSize + uint32(1 * numel(bus.allowReacquireTarget)); % for allowReacquireTarget data 

    % element frameSkipTime
    outSize = outSize + uint32(1); % bit flags
    outSize = outSize + uint32(1); % signal type
    outSize = outSize + uint32(2 + numel(namePrefixBytes) + 13); % for name (including prefix)
    outSize = outSize + uint32(2 + 2); % for units
    outSize = outSize + uint32(1); % for data type id
    outSize = outSize + uint32(1 + 2*1); % for dimensions
    outSize = outSize + uint32(8 * numel(bus.frameSkipTime)); % for frameSkipTime data 

    % element frameIntegrationTime
    outSize = outSize + uint32(1); % bit flags
    outSize = outSize + uint32(1); % signal type
    outSize = outSize + uint32(2 + numel(namePrefixBytes) + 20); % for name (including prefix)
    outSize = outSize + uint32(2 + 2); % for units
    outSize = outSize + uint32(1); % for data type id
    outSize = outSize + uint32(1 + 2*1); % for dimensions
    outSize = outSize + uint32(8 * numel(bus.frameIntegrationTime)); % for frameIntegrationTime data 

    % element imageDecoderTraining
    outSize = outSize + uint32(1); % bit flags
    outSize = outSize + uint32(1); % signal type
    outSize = outSize + uint32(2 + numel(namePrefixBytes) + 20); % for name (including prefix)
    outSize = outSize + uint32(2 + 0); % for units
    outSize = outSize + uint32(1); % for data type id
    outSize = outSize + uint32(1 + 2*1); % for dimensions
    outSize = outSize + uint32(1 * numel(bus.imageDecoderTraining)); % for imageDecoderTraining data 

    % element resetImageDecoder
    outSize = outSize + uint32(1); % bit flags
    outSize = outSize + uint32(1); % signal type
    outSize = outSize + uint32(2 + numel(namePrefixBytes) + 17); % for name (including prefix)
    outSize = outSize + uint32(2 + 0); % for units
    outSize = outSize + uint32(1); % for data type id
    outSize = outSize + uint32(1 + 2*1); % for dimensions
    outSize = outSize + uint32(1 * numel(bus.resetImageDecoder)); % for resetImageDecoder data 

    % element imageDecoderDebugDisplayMode
    outSize = outSize + uint32(1); % bit flags
    outSize = outSize + uint32(1); % signal type
    outSize = outSize + uint32(2 + numel(namePrefixBytes) + 28); % for name (including prefix)
    outSize = outSize + uint32(2 + 0); % for units
    outSize = outSize + uint32(1); % for data type id
    outSize = outSize + uint32(1 + 2*1); % for dimensions
    outSize = outSize + uint32(1 * numel(bus.imageDecoderDebugDisplayMode)); % for imageDecoderDebugDisplayMode data 

    % element conditionsToDecode
    outSize = outSize + uint32(1); % bit flags
    outSize = outSize + uint32(1); % signal type
    outSize = outSize + uint32(2 + numel(namePrefixBytes) + 18); % for name (including prefix)
    outSize = outSize + uint32(2 + 4); % for units
    outSize = outSize + uint32(1); % for data type id
    outSize = outSize + uint32(1 + 2*1); % for dimensions
    outSize = outSize + uint32(1 * numel(bus.conditionsToDecode)); % for conditionsToDecode data 


end