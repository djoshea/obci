function [paramValueTable, conditionRepeats] = generateConditionBlockFromRelativeFrequencies(paramValueLists, paramRelativeFrequencies)
% [paramValueTable, conditionRepeats] = generateConditionBlockFromRelativeFrequencies(paramValueLists, paramRelativeFrequencies)
% Build a condition table by combinatorial expansion of field values and
% desired frequencies of occurrence.
%
% paramValueLists is a struct with field values:
%   .param1 = [v1 v2 ...];
%   .param2 = [v1 v2 ...];
%
% paramRelativeFrequencies is a struct with field relative frequencies of 
% occurrence, which match the lengths of the corresponding fields in
% paramValueLists.
%   .param1 = [f1 f2 ...]
%   .param2 = [f1 f2 ...]; % can be different lengths from each other
%
% where .param(i) is the fraction of trials in each block that take 
% value i for param. The f# terms will be normalized to 1, such that the 
% relative ratios of each condition frequency are used.
% 
% All possible combinations of parameter settings will be used in
% constructing the conditions, with some conditions repeated multiple times
% to ensure that the relative frequencies are correct. conditionRepeats(i) is
% the number of times that conditionRepeats(i) is the number of times that
% condition i should be repeated within a block, which ensure that the
% specified relative frequencies will be achieved. conditionRepeats will be
% scaled to make each element an integer value.
% 
% See also insertConditionalConditionBlock
% 
% Author: Dan O'Shea (c) 2014 dan { at } REMOVETHISdjoshea.com
%
F = paramRelativeFrequencies;
V = paramValueLists;

if isempty(F)
    F = struct();
end

params = union(fieldnames(F), fieldnames(V));
nParams = numel(params);

nValues = nan(nParams, 1);

for iP = 1:nParams
    if ~isfield(F, params{iP}) || isempty(F.(params{iP}))
        F.(params{iP}) = ones(1, numel(V.(params{iP})));
    else
        F.(params{iP}) = scaleMakeElementsIntegers(F.(params{iP}));
    end
    
    if ~isfield(V, params{iP}) || isempty(V.(params{iP}))
        V.(params{iP}) = 1:numel(F.(params{iP}));
    end
        
    nValues(iP) = numel(F.(params{iP}));
end

nConditions = prod(nValues);
conditionRepeats = nan(nConditions, 1);

valueIdxMat = ind2subAsMat(nValues, 1:nConditions);

for iC = 1:nConditions
    rep = 1;
    for iP = 1:nParams
        idxValue = valueIdxMat(iC, iP);
        if isa(V.(params{iP}), 'function_handle')
            value = V.(params{iP});
        elseif iscell(V.(params{iP}))
            value = V.(params{iP}){idxValue};
        else
            value = V.(params{iP})(idxValue);
        end
        
        paramValueTable(iC).(params{iP}) = value;
        rep = rep * F.(params{iP})(idxValue);
    end
    
    conditionRepeats(iC) = rep;
    paramValueTable(iC).conditionId = uint16(iC);
    paramValueTable(iC).conditionRepeats = uint16(rep);
end

paramValueTable = paramValueTable';

end

function out = scaleMakeElementsIntegers(in)

    [nvec, dvec] = rat(in, 0.01);
    out = nvec ./ dvec * prod(dvec);
    out = out ./ gcdvec(out);

end

function g = gcdvec(in)
% compute the gcd of a vector of numbers
    if numel(in) > 2
        g = gcd(in(1), gcdvec(in(2:end)));
    elseif numel(in) == 2
        g = gcd(in(1), in(2));
    else
        g = in;
    end
    
end

function mat = ind2subAsMat(sz, inds)
% sz is the size of the tensor
% mat is length(inds) x length(sz) where each row contains ind2sub(sz, inds(i))
    if numel(sz) == 1
        sz = [sz 1];
    else
        sz = makecol(sz)';
    end
    
    ndims = length(sz);
    subsCell = cell(ndims, 1);

    [subsCell{:}] = ind2sub(sz, makecol(inds));

    mat = [subsCell{:}];
end

function c = makecol(in)
    c = in(:);
end