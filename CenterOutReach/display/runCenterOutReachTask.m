cxt = Rig1DisplayContext();

% PsychDebugWindowConfiguration

ns = NetworkShell(cxt);
ns.catchErrors = false;
ns.setTask(CenterOutReachTask());
ns.run();
