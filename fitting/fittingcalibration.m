%{
%FITTINGCALIBRATION.m
%Kyle Inzunza
%} 

%% collect and parse video data

video = 'IONX0058';
gs = RGBstrut2grey(vid2struct(video)); %import video and convert to frames

c = imfindcircles(gs{1},[7 18], 'ObjectPolarity','dark','Sensitivity',.90); %get circle positions
csort = gridc(c); %sort circles into grid

%% get distances

[ih, iw] = size(gs{1}); %get width and height of image
imcenter = [round(iw/2),round(ih/2)]; %get xy coordinates of center

truepx = findtpx(find4closest(imcenter,csort),imcenter); %find the true distance between pixels

[cxy,cid] = find1closest(imcenter, csort); %get position and index of circle closest to the center

%% make true position grid

gridt = ones(size(csort)); %matrix same dimensions as other grid

gridt(:,cid(2),1) = gridt(:,cid(2),1)*cxy(1); %set seed column x
gridt(cid(1),:,2) = gridt(cid(1),:,2)*cxy(2); %set seed row y

cidx = cid(2);
cidy = cid(1);

%% colrow method for true grid

%loop through columns
for ii = 1:floor((size(csort,2))/2)
    
    %positive direction
    gridt(:,cidx+ii,1) = gridt(:,cidx+ii,1)*(cxy(1)+truepx*ii); %set whole column as value
    %negative direction
    gridt(:,cidx-ii,1) = gridt(:,cidx-ii,1)*(cxy(1)-truepx*ii); %set whole column as value
end


%loop through rows
for ii = 1:floor((size(csort,1))/2)
    
    %positive direction
    gridt(cidy+ii,:,2) = gridt(cidy+ii,:,2)*(cxy(2)+truepx*ii); %set whole row as value
    %negative direction
    gridt(cidy-ii,:,2) = gridt(cidy-ii,:,2)*(cxy(2)-truepx*ii); %set whole row as value
    
end

%% rotation correction

closest = find4closest(imcenter, csort); %find the four circles closest to the center
v1 = [closest(1,2,1)-closest(1,1,1),closest(1,2,2)-closest(1,1,2)]; %vector from the top left corner to top right corner
v2 = [closest(2,2,1)-closest(2,1,1),closest(2,2,2)-closest(2,1,2)]; %vector from bottom left corner to bottom right
u = [0 1]; %vector along x axis

a1 = findangle(v1,u); %get angle1
a2 = findangle(v2,u); %get angle2
a = 2*pi - (a1 + a2)/2; %get average of angles and change direction

rot = [cos(a), -sin(a); sin(a), cos(a)]; %rotation matrix

%subtract the origin
csort(:,:,1) = csort(:,:,1) - imcenter(1);
csort(:,:,2) = csort(:,:,2) - imcenter(2);

%rotate true position matrix
%loop through rows
for ii = 1:size(gridt,1)
    %loop through columns
    for jj = 1:size(gridt,2)
        pos = gridt(ii,jj,:); %extract xy position of coordinate
        gridt(ii,jj,:) = rot*pos(:); %rotate position and record in matrix
    end
end

%add the origin back
csort(:,:,1) = csort(:,:,1) + imcenter(1);
csort(:,:,2) = csort(:,:,2) + imcenter(2);

%% generate polynomial

xtrue = zeros(size(c,1),1); %vector of all x coordinates in assumed reality
ytrue = zeros(size(c,1),1); %vector of all y coordinates in assumed reality
xdis = zeros(size(c,1),1); %vector of all x coordinates in distorted frame
ydis = zeros(size(c,1),1); %vector of all y coordinates in distorted frame

counter = 0; %counts the amount of values written

%loop through rows
for ii = 1:size(csort,1)
    for jj = 1:size(csort,2)
        %check if circle exists
        if sum(isnan(csort(ii,jj,:))) == 0
            counter = counter + 1; 
            %write values to vectors
            xtrue(counter) = gridt(ii,jj,1);
            ytrue(counter) = gridt(ii,jj,2);
            xdis(counter) = csort(ii,jj,1);
            ydis(counter) = csort(ii,jj,2);
        end
    end
end


sfx = fit([xdis, ydis],xtrue,'cubicinterp'); %surface fit to find x reality
sfy = fit([xdis, ydis],ytrue,'cubicinterp'); %surface fit to find y reality

tic;
a = sfx(500,500);
b = sfy(500,500);
toc;

%save surfaces
save cal1 sfx sfy;