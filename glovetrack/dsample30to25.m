function m = dsample30to25(m)
%DSAMPLE downsample matrix from 30hz to 25hz

s = size(m); %store original size of matrix

for jj = 1:s(2) %loop through frames
    if mod(jj,5) == 0 %if counter is multiple of 5
        m(:,jj,:) = []; %delete element
    end
end

end

