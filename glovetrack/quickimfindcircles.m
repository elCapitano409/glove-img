function quickimfindcircles(im, rad, sen)
%QUICKIMFINDCIRCLES searches for circles in bright and dark polarity and
%outputs results to calibrate radius and sensitivity

%search for black and white circles
[cw,rw] = imfindcircles(im,rad,'ObjectPolarity','bright','Sensitivity',sen);
[cb,rb] = imfindcircles(im,rad,'ObjectPolarity','dark','Sensitivity',sen);

imshow(im); %display image

viscircles(cw,rw,'Color','b'); %display white circles
viscircles(cb,rb,'Color','g'); %display black circles
end

