function Cout = modifyDynamicConditionAttributes(C, randUnifSource)
%#codegen

    % randUnifSource will contain standard uniformly distributed numbers [0, 1]

    % make delay period piece-wise uniformly distributed

    Cout = C;
    val = randUnifSource(1);

    if val < C.fracZeroDelay % zero delay
        Cout.delayNominal = 0;

    elseif val < C.fracZeroDelay + C.fracShortDelay % short delay
        % restore to 0:1 range
        val = (val - C.fracZeroDelay) / C.fracShortDelay;

        % shift to min:max range
        Cout.delayNominal = val * (C.delayRangeShortMax - C.delayRangeShortMin) + C.delayRangeShortMin;

    else % long delay
        % restore to 0:1 range
        val = (val - C.fracZeroDelay - C.fracShortDelay) / (1.0 - C.fracZeroDelay - C.fracShortDelay);

        % shift to min:max range
        Cout.delayNominal = val * (C.delayRangeLongMax - C.delayRangeLongMin) + C.delayRangeLongMin;

    end

end
