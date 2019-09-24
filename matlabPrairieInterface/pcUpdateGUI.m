function pcUpdateGUI(image, updateRate)
    pc = PrairieControl.getInstance();
    pc.updateImage(image);
    pc.liveDisplayUpdateRate = updateRate;
    pc.updateGuiLiveDisplayInfo();
end