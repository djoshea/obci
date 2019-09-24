classdef TimeseriesBuffer < handle

    properties
        maxTimes = 1000;
    end
    
    properties(SetAccess=protected)
        dataMat % nSignals x nTime for fast read access
        times % nTime x 1 vector
        signalNames % nSignals x 1 cellstr
    end
    
    properties(Dependent)
        nSignals
        nTimes
    end
    
    methods
        function tb = TimeseriesBuffer(varargin)
            p = inputParser();
            p.addParameter('maxTimes', 1000, @isscalar);
            p.addParameter('signalNames', {}, @iscellstr);
            p.parse(varargin{:});
            tb.maxTimes = p.Results.maxTimes;
            tb.signalNames = p.Results.signalNames;
        end
        
        function n = get.nSignals(tb)
            n = size(tb.dataMat, 1);
        end
        
        function n = get.nTimes(tb)
            n = size(tb.dataMat, 2);
        end
        
        function clear(tb)
            tb.dataMat = [];
            tb.times = [];
        end
        
        function addSample(tb, time, datavec)
            if size(datavec, 1) < size(datavec, 2)
                % makecol
                datavec = datavec';
            end
            if tb.nTimes == 0
                % first timestep
                tb.times = time;
                tb.dataMat = datavec;
            elseif tb.nTimes >= tb.maxTimes
                % lose the last timestep
                tb.times = [tb.times(2:end); time];
                tb.dataMat = [tb.dataMat(:, 2:end), datavec];
            else
                tb.times = [tb.times; time];
                tb.dataMat = [tb.dataMat, datavec];
            end
        end
        
        function idx = findSignal(tb, signalName)
            [~, idx] = ismember(signalName, tb.signalNames);
        end
        
        function [ts, times] = getTimeseriesForSignal(tb, signalName)
            ts = tb.dataMat(tb.findSignal(signalName), :);
            times = tb.times;
        end
        
        function [val, time] = getLastSampleForSignal(tb, signalName)
            val = tb.dataMat(tb.findSignal(signalName), end);
            time = tb.times(end);
        end
            
    end     
end
