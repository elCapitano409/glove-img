function closest = find4closest(imcenter, g)
%FIND4CLOSEST finds the four closest circles to the center of an image 
%must be a grid of circles




%% find closest circle

[gh, gw, ~] = size(g); %get width and height of grid
d =nan * ones(gh,gw); %matrix of distances from center

%loop through rows of grid
for ii = 1:gh
    %loop through columns of grid
    for jj = 1:gw
        %check if circle exists (if it has no nan coordinates)
        if sum(isnan(g(ii,jj,:))) == 0
            d(ii,jj) = getdist(g(ii,jj,:),imcenter); %find dist between circle and center
        end
    end
end

%find indcies of circle with smallest distance
[~,idx]=min(d(:));
[circidx,circidy]=ind2sub(size(d),idx);
        

circxy = [g(circidx,circidy,1),g(circidx,circidy,2)]; %find coordinates of closest circle

%% find other three closest

closest = zeros(2,2,2); %coordinates of the four closest circles to the center

%if in the top left corner
if circxy(1) < imcenter(1) && circxy(2) > imcenter(2)
    closest(1,1,:) = circxy; %set closest circle to top left
    %fill matrix with other adjacent circles
    closest(1,2,:) = g(circidx+1,circidy,:); %top right
    closest(2,1,:) = g(circidx,circidy-1,:); %bottom left
    closest(2,2,:) = g(circidx+1,circidy-1,:); %bottom right
%     disp('top left')

%if in the top right corner
elseif circxy(1) > imcenter(1) && circxy(2) > imcenter(2)
    closest(1,2,:) = circxy; %set closest circle to top right
    %fill matrix with other adjacent circles
    closest(1,1,:) = g(circidx-1,circidy,:); %top left
    closest(2,1,:) = g(circidx-1,circidy-1,:); %bottom left
    closest(2,2,:) = g(circidx,circidy-1,:); %bottom right
%     disp('top right')

%if in the bottom left corner
elseif circxy(1) < imcenter(1) && circxy(2) < imcenter(2)
    closest(2,1,:) = circxy; %set closest circle to bottom left
    %fill matrix with other adjacent circles
    closest(1,1,:) = g(circidx,circidy+1,:); %top left
    closest(1,2,:) = g(circidx+1,circidy+1,:); %top right
    closest(2,2,:) = g(circidx+1,circidy,:); %bottom right
%     disp('bottom left')
    
%if in the bottom right corner
elseif circxy(1) > imcenter(1) && circxy(2) < imcenter(2)
    closest(2,2,:) = circxy; %set closest circle to bottom right
    %fill matrix with other adjacent circles
    closest(1,1,:) = g(circidx-1,circidy+1,:); %top left
    closest(2,1,:) = g(circidx-1,circidy,:); %bottom left
    closest(2,2,:) = g(circidx,circidy+1,:); %top right
%     disp('bottom right')

else 
    error('Problem with detecting four center circles.');
end

end