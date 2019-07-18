function csort = idcircles(c,cprev,cnum)
%IDCIRCLES uses distances from previous frame to id current circle

%check if previous frame contains NaN values
if sum(isnan(cprev)) ~= 0
    error('MyComponent:nullprevframe','Error. \nPrevious frame contains null values. Cannot sort using distances.');
end

%if there is less than expected number of circles
if size(c,1) < cnum
    error('MyComponent:notenoughmarkers','Error. \nMissing markers');
end


cprev = reshape(cprev,size(cprev,1),size(cprev,3)); %reorganize cprev to be in same format as c 

dist = pdist2(c,cprev); %compute distances bewteen current and previous markers
temp = sort(dist,1);
minid = [temp(1,:);1:size(cprev,1)]; %top row: min values of each col dist, bottom row: current index of each row
minid = (sortrows(minid)')'; %sort from min dist to max dist
minid = minid(2,:); %replace array with only indices

csort = zeros(size(cprev)); 

%loop through previous circles
for ii = 1:size(cprev,1)
    
    [~,index] = min(dist(:,minid(ii))); %get index of smallest distance in column ii
    csort(minid(ii),:) = c(index,:); %set marker of min dist as circle ii
    
    sdist = size(dist); %save size of distance matrix
    dist(index,:) = []; %take circle out of dist matrix
    dist = reshape(dist, sdist(1) - 1, sdist(2));
end

end

