function c = deletecircles(c,cd)
%CIRCLEDELETE deletes specific circles from array

cnum = size(c,1); %number of circles in array
cdnum = size(cd,1); %number of circles that can be deleted
pxrange = 3; %the +- range that circles will be considered the same pos

for ii = 1:cdnum
    index = [c(:,1) <= cd(ii,1) + pxrange & c(:,1) >= cd(ii,1) - pxrange, c(:,2) <= cd(ii,2) + pxrange & c(:,2) >= cd(ii,2) - pxrange]; %find all individual values within range
    index = sum(index,2); %sum rows
    index = index == 2; %set true if both x and y component are true
    
    if sum(index) == 0 %if no matches were found
        continue; %skip to next circle
    end
    
    d_index = [index,index]; %horizontally concatonate vector on itself
    c(d_index) = [];%delete components
    
    cnum = cnum - sum(index); %readjust number of circles
    c = reshape(c,cnum,2);
end
end

