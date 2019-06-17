function csort = idcircles(c,cprev)
%IDCIRCLES uses distances from previous frame to id current circles

dist = pdist2(c,cprev); %compute distances bewteen current and previous markers
csort = zeros(size(cprev)); 

%if there is less than expected number of circles
if size(c,2) < size(cprev,2)
    error('Missing markers');
end

%loop through previous circles
for ii = size(cprev,1)
    [~,index] = min(dist(:,ii)); %get index of smallest distance in column ii
    csort(ii,:) = c(index,:); %set marker of min dist as circle ii 
end

end

