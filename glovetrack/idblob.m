function c = idblob(image,prev,al)
%IDBLOB matches blob in image to previous coordinat

savedim = image; % delete later 

step = 5; %amount to change threshold
prev = reshape(prev,1,2); %reshape prev to handle
image = overlaycirclemask(image,prev); %mask around radius of last known location of marker

mask = rgbmask(image,'b'); %isolate blue
mask = bwareaopen(mask, 6); %fill all holes less than 6 px

while true %loop until broken

    s = regionprops(mask,'centroid','area'); %get centroids of all blobs
    %convert struct to 2d arrays
    centroids = cat(1,s.Centroid); 
    a = cat(1,s.Area);
    
    clear 's'; %delete struct
    
    %TODO: delete elements not within limits
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
        
    
    if cnum < 1 %if no blobs found
        if polarity == 0
           t = t + step; %adjust threshold
           mask = image < t; %mask image from new threshold
           
        else
           t = t - step; %adjust threshold
           mask = image > t; %mask image from new threshold
        end
        
        disp(['t = ' num2str(t)]); %for troubleshooting, delete later
        montage([image, savedim]);
        
        if t <= 20 || t >= 240
            error('MyComponent:MissingBlob', 'Error. Cannot find blob in image.');
        end
        
    else
        break; %end loop
    end
end



if cnum == 1 %if only one centroid found
    c = centroids;
else %if multiple centroids found
    dist = pdist2(prev,centroids); %create array of distances
    [~,id] = min(dist); %centroid with smallest distance to previous location
    c = centroids(id,:);
end

