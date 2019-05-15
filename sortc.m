function scirc = sortc(circ)
%SORTC sorts circles on thier y coordinate

scirc = zeros(size(circ)); %matrix to store sorted coordinates

circy = sort(circ(:,2)); %save all y sorted in ascending order

s = size(circ);
cnum = s(1);%get number of circles

%loop through y vector
for ii = 1:cnum
    %loop through circles
    for jj = 1:cnum
        %if the y values match
        if circy(ii) == circ(jj,2)
            scirc(ii,:) = circ(jj,:); %add sorted circle
            break; %sort next circle
        end
    end

end

