function pos = cordtrack(video)
%CORDTRACK outputs the x position of all dots on the cord for every framecs = vid2struct(fileName); %breaks video down into frames

%set circle finding presets
sen = 0.95;
rad = [6 10];
pol = 'dark';


cs = vid2struct(video); %extracts frames from video
gs = RGBstrut2grey(cs);  %converts frames to grayscale

s = size(cs);
fnum = s(2); %get number of frames

%adjust for sync
sync = findsyncframe(gs); %get frame to start recording
fnum = fnum - sync; %adjust for new size
if fnum <= 1
    error('Invalid sync frame selected.')
end
newgs = cell(size(gs));
for qq = 1:fnum
    newgs{qq} = gs{qq + sync}; %offset frames 
end
gs = newgs; %set as new matrix

%analyse first frame
center = imfindcircles(gs{1},rad,'ObjectPolarity',pol,'Sensitivity',sen);
s = size(center);
cnum = s(1); %get number of circles

pos = zeros(cnum, fnum); %matrix to hold circle positions

wb = waitbar(0, 'Analysis of frames from camera 3...')%create waitbar

%loop through frames
for ii = 1:fnum
    
    waitbar(ii/fnum); %update waitbar
    
    center = imfindcircles(gs{jj},rad, 'ObjectPolarity', pol,...
        'Sensitivity',sen); %find xy position of circles
    
    center = sortc(center); %sort matrix of circles by y value
    
    pos(:,ii) = center(:,1) %record all x positions
end

close(wb); %close waitbar

end

