function [xy,id] = find1closest(imcenter,g)
%FIND1CLOSEST outputs the coordinates and index of the circle closest to
%the center

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

%find index of circle with smallest distance
[~,idx]=min(d(:));
[circidx,circidy] =ind2sub(size(d),idx);
        
xy = [g(circidx,circidy,1),g(circidx,circidy,2)]; %find coordinates of closest circle
id = [circidx,circidy]; %set index

end

