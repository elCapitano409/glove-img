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
csort = zeros(size(cprev)); 


%loop through previous circles
for ii = 1:size(cprev,1)
    [~,index] = min(dist(:,ii)); %get index of smallest distance in column ii
    csort(ii,:) = c(index,:); %set marker of min dist as circle ii 
end

end

