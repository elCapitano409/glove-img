function [pw,aw] = blobprops(image)
%BLOBPROPS gets position and area for all blobs in premasked image

s = regionprops(image,'centroid','area'); %find centroid and area
pw = cat(1,s.Centroid);
aw = cat(1,s.Area);

end

