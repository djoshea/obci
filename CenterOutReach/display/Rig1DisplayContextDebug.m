classdef Rig1DisplayContextDebug < Rig1DisplayContext

    methods
        function cxt = Rig1DisplayContextDebug()
            cxt = cxt@Rig1DisplayContext();

            cxt.cs = MouseOnlyGUIScaledCoordSystem(cxt.cs, 0);
            cxt.screenIdx = 0;

            cxt.name = 'rig1-displayPC-debugPartial';
            cxt.screenRect = [1920/2 1080/2 1920 1080];
        end
    end
end