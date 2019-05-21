%{
%FITTINGCALIBRATION.m
%Kyle Inzunza
%} 

%% collect and parse video data

gs = RGBstrut2grey(vid2struct('IONX0058')); %import video and convert to frames

c = imfindcircles(gs{1},[7 18], 'ObjectPolarity','dark','Sensitivity',.90); %get circle positions
csort = gridc(c); %sort circles into grid

%% get distances

[ih, iw] = size(gs{1}); %get width and height of image
imcenter = [round(iw/2),round(ih/2)]; %get xy coordinates of center

truepx = findtpx(find4closest(imcenter,csort),imcenter); %find the true distance between pixels

[cxy,cid] = find1closest(imcenter, csort); %get position and index of circle closest to the center

%% make true position grid

gridt = nan*ones(size(csort)); %matrix same dimensions as other grid

gridt(cid(1),cid(2),:) = cxy(:); %set middle index

cidx = cid(1);
cidy = cid(2);

%% colrow method for true grid


%loop through columns
for ii = 1:(size(csort,2))
    
    %positive direction
    %loop through elements of column
    for jj = 1:size(size(csort,1))
        %check if circle exists
        try
            if sum(isnan(csort(cidx + ii,jj,:))) == 0
                gridt(cidx+ii,jj,1) = cxy(1) + ii*truepx;%set x position
            end
        catch ME
            break; %exit loop
        end
    end
    
                    
    
end

%% spiral method for true grid

% brad = 1; %distance away from center block;
% flag = true; %boolean to set loop
% %loop until fully sorted
% while flag
%     bcir = 8*bper; %set block perimeter
%     missc = 0; %counts the amount of circles that are missing from the ring
%     %top edge
%     %if a circle exists
%     if sum(isnan(csort(cidx,cidy,:))) == 0
%         gridt(cidx,cidy+brad,:) = [cxy(1), cxy(2)+truepx*brad]; %set edge coordinate
%     else
%         missc = missc + 1; %increase missing counter
%     end
%     %loop to either corner
%     for ii = 1:brad
%         %towards right(if exists)
%         if
%             gridt(cidx+ii,cidy+brad,:) = [cxy(1) + ii*truepx, cxy(2)+truepx*brad]
%         end
%     %bottom edge
%     %left edge
%     %right edge
%     brad = brad+1; %increase block radius
% end
        