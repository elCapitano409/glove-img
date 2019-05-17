%{
%FITTINGCALIBRATION.m
%Kyle Inzunza
%} 

%% collect and parse video data

gs = RGBstrut2grey(vid2struct('IONX0058')); %import video and convert to frames

c = imfindcircles(gs{1},[7 18], 'ObjectPolarity','dark','Sensitivity',.90); %get circle positions
csort = gridc(c); %sort circles into grid

%% get distances

[ih, iw] = size(im); %get width and height of image
imcenter = [round(iw/2),round(ih/2)]; %get xy coordinates of center

truepx = findaxisoffset(find4closest(imcenter,csort),imcenter); %find the true distance between pixels

[cxy,cid] = find1closest(imcenter, csort); %get position and index of circle closest to the center

