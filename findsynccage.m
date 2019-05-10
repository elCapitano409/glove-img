function cage = findsynccage(frame)
%FINDREFCAGE finds the coordinates that contains the sync LED

center = imfindcircles(frame,[80 100], 'ObjectPolarity', 'dark',...
    'Sensitivity',0.98); %get circle coordinates

cage = zeros(2); %matrix to store 

s = size(center);
cnum = s(1); %get number of circles

%if there is not enough circles to do analysis
if(cnum < 2)
    error('Problem with detecting sync cage.')
end

cage(1,1) = min(center(:,1)); %set min x coordinate as x1
cage(1,2) = max(center(:,1)); %set max x coordinate as x2
cage(2,1) = min(center(:,2)); %set min y coordinate as y1
cage(2,2) = max(center(:,2)); %set min y coordinate as y2

end

