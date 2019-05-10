function conv = findrefdist(frame)
%FINDREFDIST finds the conversion of pixels per meter using motion table
%reference circles

dhole = 10; %the distance in meters between two holes

[center, rad] = imfindcircles(frame, [10 25], 'ObjectPolarity', 'dark',...
    'Sensitivity',.95); %find position of all circles


h = viscircles(center, rad, 'Color','b');

s = size(center);
cnum = s(1); %number of circles

if cnum == 0
    error('No reference circles found');
end

seed = center(1,:); %set first circle as seed

dists = zeros(cnum - 1, 1); %distances of every circle to seed circle

%loop through every circle except seed
for ii = 2:cnum
    dists(ii-1) = getdist(seed, center(ii)); %find distance between seed and circle
end

d = min(dists); %finds the smallest distance between the two circles in px

conv = d/dhole; %converts number to meters

end

