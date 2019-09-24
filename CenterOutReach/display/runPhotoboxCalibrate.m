cxt = Rig1DisplayContext();

PsychDebugWindowConfiguration

ns = NetworkShell(cxt);
ns.setTask(TestPhotodiodeTask());
ns.run();
