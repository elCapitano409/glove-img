function num = circlenum(img, rad, pol, sen)
%CIRCLENUM determines amount of circles of certain radius in image

%get centers of circles
center = imfindcircles(img, rad, 'ObjectPolarity', pol,'Sensitivity',sen); %find xy position of circle

s = size(center);
num = s(1); %number of circles
end

