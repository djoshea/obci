function fetchSRTSignal(block)
%%
%% The setup method is used to set up the basic attributes of the
%% S-function such as ports, parameters, etc. Do not add any other
%% calls to the main body of the function.
%%
setup(block);

%endfunction

%% Function: setup ===================================================
%% Abstract:
%%   Set up the basic characteristics of the S-function block such as:
%%   - Input ports
%%   - Output ports
%%   - Dialog parameters
%%   - Options
%%
%%   Required         : Yes
%%   C-Mex counterpart: mdlInitializeSizes
%%
function setup(block)

% Register number of ports
block.NumInputPorts  = 0;
block.NumOutputPorts = 1;

% Setup port properties to be inherited or dynamic
% block.SetPreCompInpPortInfoToDynamic;
% block.SetPreCompOutPortInfoToDynamic;

signalIdStart = block.DialogPrm(1).Data;
signalIdStop = block.DialogPrm(2).Data;

% Override output port properties
block.OutputPort(1).Dimensions  = signalIdStop - signalIdStart + 1;
block.OutputPort(1).DatatypeID  = 0; % double
block.OutputPort(1).Complexity  = 'Real';
block.OutputPort(1).SamplingMode = 'sample';

% Register parameters
block.NumDialogPrms     = 2;

% Register sample times
%  [-1, 0]               : Inherited sample time
block.SampleTimes = [-1 0];
block.SimStateCompliance = 'DefaultSimState';

block.RegBlockMethod('Outputs', @Outputs);     % Required

%%
%% Outputs:
%%   Functionality    : Called to generate block outputs in
%%                      simulation step
%%   Required         : Yes
%%   C-MEX counterpart: mdlOutputs
%%
function Outputs(block)

coder.extrinsic('slrt');

tg = slrt;
signalIdStart = block.DialogPrm(1).Data;
signalIdStop = block.DialogPrm(2).Data;

% can only fetch 8499 bytes at a time for reasons I don't understand
idx = signalIdStart:signalIdStop;
nBytes = numel(idx);
bytesPerBlock = 8400;
nBlocks = ceil(nBytes / bytesPerBlock);
blockOffset = 0;
data = zeros(1, nBytes);
for b = 1:nBlocks
    if b == nBlocks
        idxThisBlock = (blockOffset+1):nBytes;
    else
        idxThisBlock = blockOffset + (1:bytesPerBlock);
    end
    data(idxThisBlock) = tg.getsignal(idxThisBlock+signalIdStart-1);
    blockOffset = blockOffset + bytesPerBlock;
end

block.OutputPort(1).Data = data;

%end Outputs

