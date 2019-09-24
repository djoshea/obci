function [signalIdStart, signalIdStop] = initFetchSRTSignal(block, signalLabel)

tg = slrt;
ids = tg.getsignalidsfromlabel(signalLabel);

if isempty(ids)
    error(message('FetchSRTSignal:SignalNotFound', ['Could not find signal id for signal ' signalLabel]));
end

signalIdStart = min(ids);
signalIdStop = max(ids);
