function createMicroscopeBuses(codePath)

% places the generated code for this bus in my subfolder, will be restored
% below
if nargin < 1
    codePath = fullfile(fileparts(mfilename('fullpath')), 'generatedCode');
end
oldCodePath = BusSerialize.setGeneratedCodePath(codePath);

import BusSerialize.SignalSpec;

% create MicroscopeStateBus
info = struct();
info.saveBase = SignalSpec.ParamStringVariable('', 200);
info.saveLeaf = SignalSpec.ParamStringVariable('', 200);
info.saveCounter = SignalSpec.Param(uint16(0));
info.objective = SignalSpec.ParamStringVariable('', 50);
info.objectiveMag = SignalSpec.Param(0);
info.objectiveNA = SignalSpec.Param(0);
info.orbitalPitch = SignalSpec.Param(0, 'degrees');
info.orbitalYaw = SignalSpec.Param(0, 'degrees');
info.scopeX = SignalSpec.Param(0, 'um');
info.scopeY = SignalSpec.Param(0, 'um');
info.scopeZ = SignalSpec.Param(0, 'um');
info.pmtGainGaAsP1 = SignalSpec.Param(0, 'V');
info.pmtGainGaAsP2 = SignalSpec.Param(0, 'V');
info.pmtGainLightGuide = SignalSpec.Param(0, 'V');
info.pockels = SignalSpec.Param(0, 'V');
% the image in matlab is dim Y x dim X
info.pixelSizeX = SignalSpec.Param(0, 'um');
info.pixelSizeY = SignalSpec.Param(0, 'um');
info.pixelsX = SignalSpec.Param(0, 'pixels');
info.pixelsY = SignalSpec.Param(0, 'pixels');
info.galvoMode = SignalSpec.ParamEnum('GalvoMode');
info.laserWavelength = SignalSpec.Param(0, 'nm');
info.dwellTime = SignalSpec.Param(0, 'us');
info.frameRate = SignalSpec.Param(0, 'Hz');

info.cameraIsAcquiring = SignalSpec.ParamBoolean(false);
info.cameraRelativePath = SignalSpec.ParamStringVariable('', 200);
info.cameraFileShort = SignalSpec.ParamStringVariable('', 200);
info.cameraFileCounter = SignalSpec.Param(uint16(0));
info.mOEGLedMode = SignalSpec.ParamEnum('LedMode');
BusSerialize.createBusBaseWorkspace('MicroscopeStateBus', info);
clear info;

BusSerialize.updateCodeForEnums({'LedMode', 'GalvoMode'});
BusSerialize.updateCodeForBuses({'MicroscopeStateBus'});

% restore the previous code path
if ~isempty(oldCodePath)
    BusSerialize.setGeneratedCodePath(oldCodePath);
end

end