function bus = initializeBus_DecoderBus()
%#codegen
% DO NOT EDIT: Auto-generated by 
%   BusSerialize.writeInitializeBusCode('DecoderBus')

    bus.decoderUpdate = uint8(0);
    bus.decodeConditionId = uint16(0);
    bus.conditionPredictionLikelihood = double([0;0;0;0]);
    coder.varsize('bus.classifierInfo', 300, true);
    bus.classifierInfo = zeros([0 1], 'uint8');

end