function [pw,aw,pb,ab] = blobprops(image,tw,tb)
%BLOBPROPS gets position and area for all black and white blobs in image

for ii = 1:2 %loop twice for both polarities
    if ii == 1 %bright
        mask = image > tw; %mask image
    else %dark
        mask = image < tb; %mask image
    end
    
    %fill holes
    mask = imfill(mask, 'holes');
    mask = bwareaopen(mask, 6);
    
    s = regionprops(mask,'centroid','area'); %find centroid and area
    
    if ii == 1 %bright
        pw = cat(1,s.Centroid);
        aw = cat(1,s.Area);
    else %dark
        pb = cat(1,s.Centroid);
        ab = cat(1,s.Area);
    end
    
end


end

