%{
% CAMERA1.m
% Kyle Inzunza
%}


%video download and frame isolation
fileName = 'IONX0016';

s = vid2struct(fileName); %breaks video down into frames
gs = RGBstrut2grey(s);  %access elements of gs with gs{a}


%find circle position
rad = [90 120]; %radius range of circles
pol = 'dark'; %object polarity
sen = .95; %search sensitivity

default = -1; %default value if the circle is not found
a = size(gs); 
fnum = a(2); %number of frames
cnum = circlenum(gs{1},rad,pol,sen); %number of circles

visf = zeros(cnum); %stores last frame circle was visible

%position -> (circle, frame, xyz coordinate)
%x = 1
%y = 2
%z = 3
pos = zeros(cnum,fnum,3); %populate position matrix

tic;
%loop through frames
for jj = 1:fnum
    center = imfindcircles(gs{jj},[90 120], 'ObjectPolarity', pol,...
    'Sensitivity',sen); %find xy position of circle

    missh = 0; %how many missing circles have been handled
    %loop through circles
    for ii = 1:cnum
        %if first frame
        if jj == 1
            pos(ii,jj,1) = center(ii,1); %set x
            pos(ii,jj,2) = center(ii,2); %set y
        else
            a = size (center);
            if a(2) == cnum
                %the circle that is shortest distance from circle ii in previous
                %frame is treated as circle ii
                icirc = objmindist(pos(ii,jj-1,:),center,'xy'); %find circle of min dist
           
                pos(ii,jj,1) = center(icirc(1),1); %set x
                pos(ii,jj,2) = center(icirc(1),2); %set y
            end
        end
    end

end
toc;
