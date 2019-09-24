function RigInfo = buildRigInfoCommon()
%% Define RigInfo struct

% Microscope VLAN
RigInfo.network.scopeVLAN.pciBus = 10;
RigInfo.network.scopeVLAN.pciSlot = 0;
RigInfo.network.scopeVLAN.sourceIP = '192.168.20.2';
RigInfo.network.scopeVLAN.sourcePort = 10002;
RigInfo.network.scopeVLAN.broadcastIP = '192.168.20.7';
RigInfo.network.scopeVLAN.destPort = 10001;
RigInfo.network.scopeVLAN.broadcastMac = 'ff:ff:ff:ff:ff:ff';
RigInfo.network.scopeVLAN.receiveFromIP = '192.168.20.7';
RigInfo.network.scopeVLAN.destIP = '192.168.20.7';
RigInfo.network.scopeVLAN.receiveAtPort = 10002;
RigInfo.network.scopeVLAN.ethernetId = 2;

% IOLAN Serial VLAN
RigInfo.network.serialVLAN.pciBus = 12;
RigInfo.network.serialVLAN.pciSlot = 0;
RigInfo.network.serialVLAN.sourceIP = '192.168.70.2';
RigInfo.network.serialVLAN.sourcePort = 10200;
RigInfo.network.serialVLAN.broadcastIP = '192.168.70.255';
RigInfo.network.serialVLAN.destPort = 10201;
RigInfo.network.serialVLAN.receiveAtPort = 10202;
RigInfo.network.serialVLAN.receiveFromIP = '192.168.70.8';
RigInfo.network.serialVLAN.broadcastMac = 'ff:ff:ff:ff:ff:ff';
RigInfo.network.serialVLAN.ethernetId = 7;

% Acclerometer VLAN
RigInfo.network.accelerometerVLAN.pciBus = NaN;
RigInfo.network.accelerometerVLAN.pciSlot = NaN;
RigInfo.network.accelerometerVLAN.sourceIP = '192.168.80.2';
RigInfo.network.accelerometerVLAN.sourcePort = 10002;
RigInfo.network.accelerometerVLAN.broadcastIP = '192.168.80.255';
RigInfo.network.accelerometerVLAN.destPort = 10001;
RigInfo.network.accelerometerVLAN.broadcastMac = 'ff:ff:ff:ff:ff:ff';
RigInfo.network.accelerometerVLAN.ethernetId = NaN;

% Display VLAN
RigInfo.network.displayVLAN.pciBus = 11;
RigInfo.network.displayVLAN.pciSlot = 0;
RigInfo.network.displayVLAN.sourceIP = '192.168.50.2';
RigInfo.network.displayVLAN.sourcePort = 10000;
RigInfo.network.displayVLAN.broadcastIP = '192.168.50.255';
RigInfo.network.displayVLAN.receiveFromIP = '192.168.50.3';
RigInfo.network.displayVLAN.receiveAtPort = 25000;
RigInfo.network.displayVLAN.destPort = 10001;
RigInfo.network.displayVLAN.broadcastMac = 'ff:ff:ff:ff:ff:ff';
RigInfo.network.displayVLAN.ethernetId = 5;

% DataLogger VLAN
RigInfo.network.dataLoggerVLAN.pciBus = 9;
RigInfo.network.dataLoggerVLAN.pciSlot = 0;
RigInfo.network.dataLoggerVLAN.sourceIP = [192 168 40 2];
RigInfo.network.dataLoggerVLAN.sourcePort = 20002;
RigInfo.network.dataLoggerVLAN.broadcastIP = [192 168 40 255];
RigInfo.network.dataLoggerVLAN.receiveFromIP = '0.0.0.0';
RigInfo.network.dataLoggerVLAN.receiveAtPort = 29001;
RigInfo.network.dataLoggerVLAN.destPort = 29000;
RigInfo.network.dataLoggerVLAN.broadcastMac = 'ff:ff:ff:ff:ff:ff';
RigInfo.network.dataLoggerVLAN.ethernetId = 3;

% added polaris to separate bar so that it slides with the screen
RigInfo.polarisCalibration.origin = [-24.8 -462 33.8];

% sliding over on 6/26/2015 to use with stereotax
% RigInfo.polarisCalibration.origin = [-6.5 -448.2 34.6];

RigInfo.polarisCalibration.limsX = [-302 275];
RigInfo.polarisCalibration.limsY = [-600 -250];
RigInfo.polarisCalibration.limsZ = [20 260];
RigInfo.polarisCalibration.manualOffset = [0 5 0];


