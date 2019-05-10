function dist = refdist(img)
%REFDIST outputs the amount of pixels per meter using the known distance
%between reference holes on the table

center = imfindcircles(img, [10 14], 'ObjectPolarity','dark','Sensitivity',0.96); %find position of all reference circles

s =
objmindist(cen)
end

