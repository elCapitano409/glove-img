function added = findappear(oldc, newc)
%FINDMISS finds index of circle that has appeared between frames
%programmed assuming only one circle has appeared in between frames

dmin = 20; %max distance that circles can move between frames

s1 = size(oldc); %s1(1) -> number of circles in frame n-1
s2 = size(newc); %s2(1) -> number of circles in frame n

d = zeros(s1(1),s2(1)); % distances between each new circle and old circle

%rows -> old circles
%columns -> new circles

%loop through rows
for ii = 1:s1(1)
    %loop through columns
    for jj = 1:s2(1)
        d(ii,jj) = getdist(oldc(ii,:),newc(jj,:)); %find distance between circles
    end
end


%loop through rows (newc)
for kk = 1:s2(1)
    %loop through column (oldc)
    ishere = 0; %boolean of if circle kk is visible in frame n
    for ll = 1:s1(1) 
        
        %if element is equal to zero it is missing and will be skipped
        if d(kk,ll) == 0
            break;
        end
        %if one of the distances is less than the min
        if d(kk,ll) < dmin 
            ishere = 1; 
            break;
        end
    end
    
    %checks if that circle is missing
    if ishere == 1
        break;
    else
        added = ll; %record index of missing circle
        break;
    end
end

end

