function c = idblobgrey(image,prev,al,t)
%IDBLOB matches blob in image to previous coordinat


prev = reshape(prev,1,2); %reshape prev to handle
image = overlaywebmask(image,prev); %mask around radius of last known location of marker
mask = greymask(image,t); %isolate blue

s = regionprops(mask,'centroid','area'); %get centroids of all blobs
%convert struct to 2d arrays
centroids = cat(1,s.Centroid);
a = cat(1,s.Area);

clear 's'; %delete struct

id = a > al(1) & a < al(2); %find index of all blobs in area limit
lnum = sum(id); %number of blobs within of limits

nid = ~id; %index of all blobs out of bounds

if sum(nid) ~= 0 %if there are blobs not in limits
    id2 = [nid,nid]; %account for x and y values
    centroids(id2) = []; %delete blobs out of bounds
    if(size(centroids,1) ~= 0)
        centroids = reshape(centroids, lnum, 2);
    end
end

cnum = size(centroids,1); %number of blobs found

if cnum == 1 %if only one centroid found
    c = centroids;
elseif cnum == 0 %if no centroids are found
    error('MyComponent:MissingBlob', 'Error. Cannot find blob in image.');
else %if multiple centroids found
    dist = pdist2(prev,centroids); %create array of distances
    [~,id] = min(dist); %centroid with smallest distance to previous location
    c = centroids(id,:);
end
