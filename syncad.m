function newgs = syncad(gs)
%SYNCAD adjusts array of images to start at the falling edge of sync event

[~,fnum] = size(gs); %get number of frames

sync = findsyncframe(gs); %get frame to start recording
fnum = fnum - sync; %adjust for new size
if fnum <= 1
    error('Invalid sync frame selected.');
end
newgs = cell(1,fnum);
for qq = 1:fnum
    newgs{qq} = gs{qq + sync - 1}; %offset frames 
end


