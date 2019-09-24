cxt = Rig1DisplayContext();

ns = NetworkShell(cxt);
ns.setTask(PolarisCalibrateTask());

ns.run();