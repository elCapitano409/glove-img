function csort = idcircles(c,cprev)
%IDCIRCLES uses distances from previous frame to id current circle

%check if previous frame contains NaN values
if sum(isnan(cprev)) ~= 0
    error('MyComponent:nullprevframe','Error. \nPrevious frame contains null values. Cannot sort using distances.');
end

cprev = reshape(cprev,size(cprev,1),size(cprev,3)); %reorganize cprev to be in same format as c 

try
dist = pdist2(c,cprev); %compute distances bewteen current and previous markers
catch ME
    disp('error');
end
csort = zeros(size(cprev)); 

%if there is less than expected number of circles
if size(c,2) < size(cprev,2)
    error('MyComponent:notenoughmarkers','Error. \nMissing markers');
end

%loop through previous circles
for ii = size(cprev,1)
    [~,index] = min(dist(:,ii)); %get index of smallest distance in column ii
    csort(ii,:) = c(index,:); %set marker of min dist as circle ii 
end

end

