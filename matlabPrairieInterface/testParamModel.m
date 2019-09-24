imgSize = [512 512];

TwoPhotonImage = Simulink.Parameter();
TwoPhotonImage.Value = zeros(imgSize, 'uint32');
TwoPhotonImage.DataType = 'uint32';
TwoPhotonImage.CoderInfo.StorageClass = 'ExportedGlobal';

%%

model = 'LiveDisplay';
TwoPhotonImage.Value = TwoPhotonImage.Value + uint32(1);
set_param(model,'SimulationCommand','update')