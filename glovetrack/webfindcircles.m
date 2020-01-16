function [c,n] = webfindcircles(image,t)
%WEBFINDCIRCLES finds the circles in an image from the webcam and sorts it
%by y value

al = [1600,2200]; %area limits
ol = [0.65,1.1]; %circularity limits


while(true)
    mask = image > t; %mask image due to brightness threshold
    mask = bwareaopen(mask,al(1)-100); %get rid of holes
    s = regionprops(mask,'centroid','area','circularity'); %get centroids of all blobs
    %convert struct to 2d arrays
    c = cat(1,s.Centroid);
    a = cat(1,s.Area);
    o = cat(1,s.Circularity);
    
    
    id = a <= al(2) & o >= ol(1) & o <= ol(2); %get index of all blobs within area and circularity limits
    idc = [id,id]; %copy to make two columns
    
    c = c(idc); %save blobs within limits
    n = size(c,1)/2;
    
    try
        c = reshape(c, [6,2]); %reshape to 6x2
        c = sortrows(c,2); %sort circles by thier y value
        break; %will run until there are only 6 blobs
        
    catch %if wrong number of elements
        if(t < 90)
            c = nan*ones(6,2);
            break;
        else
            t = t - 15; %reduce threshold and rerun program
        end
    end
end

end

