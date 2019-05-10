function missing = findmiss(oldc, newc)
%FINDMISS finds index of circle that has disapeared between frames

missing = 0;

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

counter = 1; %counts the amount of missing

%loop through rows (oldc)
for kk = 1:s1(1)
    
    %loop through column (newc)
    ishere = 0; %boolean of if circle kk is visible in frame n
    
    for ll = 1:s2(1) 
        %if one of the distances is less than the minium distance a circle
        %can move then it must be the same circle
        if d(kk,ll) < dmin
            ishere = 1;
            break;
        end
    end
    
    %checks if that circle is missing
    if ishere == 0
        missing(counter) = kk;
        counter = counter+1;
    end
end

if missing == 0
    error('Output argument not assigned.');
end

end

