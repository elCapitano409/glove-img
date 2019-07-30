function printcircles(frame,c)
%PRINTCIRCLES prints all of the cirlces onto the image with index next to
%it

cnum = size(c,1); %get number of circles;
r = 2 * ones(1,cnum);

imshow(frame); %display image
viscircles(c,r,'Color','b'); %display circles

%loop through circles
for ii = 1:cnum
    text(c(ii,1),c(ii,2),['\leftarrow' num2str(ii)],'Color','g'); %write text to image at circle location
end
end

