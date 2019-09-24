function str = decodeSerializedBits(t, v)
% str = decodeSerializedBits(time, signal)
% @djoshea

assert(nargin == 2, 'Not enough input arguments. Usage: str = decodeSerializedBits(time, signal)');

% assumes 2.5 v spacer between EVERY bit
hasBit = v > 4 | v < 1;
firstSampleEachBit = diff([false; hasBit]) == 1;
bits = v(firstSampleEachBit) > 2.5';
str = sprintf('%d', bits);

nBytes = floor(numel(str) / 8);

charmat = reshape(str(1:nBytes*8), 8, [])';
charcell = mat2cell(charmat, ones(size(charmat, 1), 1), 8);
str = char(bin2dec(charcell)');

end