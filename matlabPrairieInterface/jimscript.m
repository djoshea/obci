%% Set up PV server
pl = actxserver('PrairieLink.Application');
pl.Connect();
pl.SendScriptCommands('-lbs "true" "15"'); %Note that this could change the performance of PV.
streamFig = 99;
imageHistory = 5;
xDom = 512;
yDom = 512;
previousFrames = zeros(xDom,yDom,imageHistory);

%% Run image stream.  Keep re-running
for repeats = 1:1000
    A = pl.GetImage_2(2,xDom,yDom);
    A = mat2gray(A);
    previousFrames(:,:,end+1) = A;
    previousFrames = previousFrames(:,:,(end-imageHistory):end);
    meanA = mean(previousFrames,3);
    meanA = imadjust(meanA);
    figure(streamFig)
    image(meanA);
end

%% Close PV server
pl.Disconnect()