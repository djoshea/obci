function bus = initializeBus_TrialDataBus()
%#codegen
% DO NOT EDIT: Auto-generated by 
%   BusSerialize.writeInitializeBusCode('TrialDataBus')

    bus.taskRunning = uint8(0);
    bus.rt = uint32(0);
    bus.rtNominal = uint32(0);
    bus.delay = uint32(0);
    bus.iti = uint32(0);
    bus.holdXCenter = double(0);
    bus.holdYCenter = double(0);
    bus.holdXTarget = double(0);
    bus.holdYTarget = double(0);
    bus.targetXCurrent = double(0);
    bus.targetYCurrent = double(0);
    bus.targetSizeCurrent = double(0);
    bus.targetAcceptanceSizeCurrent = double(0);
    bus.timeInitTrial = uint32(0);
    bus.timeGoCueCommand = uint32(0);
    bus.timeGoCue = uint32(0);
    bus.timeTargetOnsetCommand = uint32(0);
    bus.timeTargetOnset = uint32(0);
    bus.timeMove = uint32(0);
    bus.moveOnsetThreshOccurred = uint8(0);
    bus.isTouchingCenter = uint8(0);
    bus.isTouchingTarget = uint8(0);
    bus.isHoldingCenter = uint8(0);
    bus.isHoldingTarget = uint8(0);
    bus.distanceTowardsTarget = double(0);
    bus.velocityTowardsTarget = double(0);
    bus.accelerationTowardsTarget = double(0);
    bus.lateralDistance = double(0);
    bus.lateralVelocity = double(0);
    bus.lateralAcceleration = double(0);
    bus.peakVelocityTowardsTarget = double(0);
    bus.peakVelocityTowardsTargetTooLow = uint8(0);
    bus.peakAccelerationTowardsTarget = double(0);
    bus.deceleratedBelowThresh = uint8(0);
    bus.postPeakMinAccelerationTowardsTarget = double(0);
    bus.success = uint8(0);
    bus.substantiveFailure = uint8(0);
    bus.getNewTrialParams = uint8(0);
    bus.failureCode = TaskState.TaskPaused;
    bus.consecutiveNoStarts = uint16(0);
    bus.purgatoryTimeRemaining = uint32(0);
    bus.inPurgatory = uint8(0);
    bus.juiceTimeTotal = uint32(0);
    bus.juiceNumDrops = uint16(0);
    bus.juiceDropSize = uint16(0);
    bus.juiceDropInterval = uint16(0);
    bus.juiceDropsRemaining = uint16(0);
    bus.timeFailureFeedback = uint32(0);
    bus.imagingThisTrial = uint8(0);
    bus.useNextFrame = uint8(0);
    bus.decodeComplete = uint8(0);
    bus.decodeSuccess = uint8(0);
    bus.isDecodeCondition = uint8(0);

end