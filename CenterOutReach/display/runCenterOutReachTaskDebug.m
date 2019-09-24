cxt = Rig1DisplayContextDebug();

% PsychDebugWindowConfiguration

ns = NetworkShell(cxt);
ns.catchErrors = false;
ns.run();
