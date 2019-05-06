%{
% CAMERA1.m
% Kyle Inzunza
%}


%video download and frame isolation
fileName = 'IONX0023';

s = vid2struct(fileName); %breaks video down into frames
gs = RGBstrut2grey(s);  %access elements of gs with gs{a}


%find circle position
rad = [70 95]; %radius range of circles
pol = 'dark'; %object polarity
sen = .95; %search sensitivity


default = -1; %default value if the circle is not found
a = size(gs); 
fnum = a(2); %number of frames
cnum = circlenum(gs{1},rad,pol,sen); %number of circles
expc = cnum; %expected number of circles

expdist = zeros(cnum); %initial distances between circles
cirmiss = []; %vector of circles that are currently missing
countmiss = 0; %counter of circles that are missing

isvisible = ones(cnum,1); %array of booleans, of if circle is visible

%position -> (circle, frame, xyz coordinate)
%x = 1
%y = 2
%z = 3
pos = zeros(cnum,fnum,3); %populate position matrix

wb = waitbar(0,'Analysing frames...'); %start progress bar 

tic;
%loop through frames
for jj = 1:fnum
    center = imfindcircles(gs{jj},rad, 'ObjectPolarity', pol,...
    'Sensitivity',sen); %find xy position of circle
   
    %check if there are more circles than in the initial frame 
    s = size(center);
    if s(1) > cnum
        disp(jj)
        disp(s(1))
        error('Unexpected circle appeared.');
    %check if circles have dissapeared
    elseif s(1) < expc
        indexm = findmiss(pos(:,jj,:),center); %find all circles that have dissapeared
        a = size(indexm);
        %loop through vector
        for qq = 1:a(1)
            countmiss = countmiss+1;
            cirmiss(countmiss) = indexm(qq);%add index of missing circle to vector
        end
            
    %check if circles have appeared
    elseif s(1) > expc
        %only one circle was missing
        if size(cirmiss) == 1
            %create matrix of circles that are in frame
            cnew = zeros(s(1),2);
            for hh = 1:s(1)
                if hh ~= cirmiss(1)
                    cnew(hh,:) = 
                
            appearindex = 
            pos(cmiss(1),jj,:) = 
        else
            error('More than one circle was missing. This case was not accounted for.');
        end
            
    end
    
    %loop through circles
    for ii = 1:cnum
        %if first frame
        if jj == 1
            pos(ii,jj,1) = center(ii,1); %set x
            pos(ii,jj,2) = center(ii,2); %set y
            
            
        %if not first frame
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
    
    %if first frame
    if jj == 1
        %populate distance array
        %loop through columns
        for aa = 1:cnum
            %loop through rows
            for bb = 1:cnum
                expdist(aa,bb) = getdist(pos(aa,1,:),pos(bb,1,:)); %set value as dist 
            end
        end
    end

end
toc;
close(wb); %close progress bar
