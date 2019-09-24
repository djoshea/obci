cxt = Rig1DisplayContext();

ns = NetworkShell(cxt);
ns.setTask(TestPhotodiodeTask());
ns.run();