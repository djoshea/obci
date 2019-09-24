function image = pcGetImage()
    persistent pc;
    if isempty(pc)
        pc = PrairieControlSimulink.getInstance();
    end
    image = pc.getImage();
end