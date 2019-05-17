function pos = cordtrack(video)
%CORDTRACK outputs the x position of all dots on the cord for every framecs = vid2struct(fileName); %breaks video down into frames

%set circle finding presets
sen = 0.98;
rad = [70 80];
pol = 'dark';


cs = vid2struct(video); %extracts frames from video
gs = RGBstrut2grey(cs);  %converts frames to grayscale

gs = syncad(gs); %adjust for sync;

[~,fnum] = size(gs); %get number of frames

%analyse first frame
center = imfindcircles(gs{1},rad,'ObjectPolarity',pol,'Sensitivity',sen);
s = size(center);
cnum = s(1); %get number of circles

pos = zeros(cnum, fnum); %matrix to hold circle positions

wb = waitbar(0, 'Analysis of frames from camera 3...');%create waitbar

%loop through frames
for ii = 1:fnum
    
    waitbar(ii/fnum); %update waitbar
    
    center = imfindcircles(gs{ii},rad,'ObjectPolarity',pol,'Sensitivity',sen);%find xy position of circles
    
    center = sortc(center); %sort matrix of circles by y value
    
    %TODO: create try catch to catch when too many circles are detected   
    
    pos(:,ii) = center(:,1); %record all x positions
end

close(wb); %close waitbar

end

