classdef Rig1DisplayContext < DisplayContext

    methods
        function cxt = Rig1DisplayContext()
            cxt.cs = ShiftScaleCoordSystem.buildCenteredForScreenSize(1, 'pixelPitch', 0.3113);

            cxt.name = 'rig1displayPC';

            % network communication with xpc target
            cxt.networkReceivePort = 10001; % must match whatever the send udp block on the target is set to
            cxt.networkTargetIP = '192.168.50.255'; % broadcast udp to the target
            cxt.networkTargetPort = 10002; % doesn't matter, xpc receives on all ports
            
            cxt.photoboxPositions.xc = -250;
            cxt.photoboxPositions.yc = 120; % higher means higher on screen
            cxt.photoboxPositions.radius = 12.5;
        end
    end
end
 