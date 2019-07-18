function status = isuniquecircles(c)
%HASDOUBLECIRCLES returns if all the circles in the array have unique coordinates 

status = true; %status if all the circles are unique
cnum = size(c,1); %number of circles

%if there are circles in array
if cnum ~= 0
    for ii = 1:cnum %loop through circles
        index = [c(:,1) == c(ii,1), c(:,2) == c(ii,2)]; %boolean array if xy values are equal
        index = sum(index,2); %add rows
        index = index == 2; %if the sum is equal to 2
        if sum(index) > 1 %if there is more than one instance of circle ii
            status = false; %the circles are not unique
            break; %end loop
        end
    end
end
end

