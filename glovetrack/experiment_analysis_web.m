%{
%EXPERIMENT_ANALYSIS_WEB.m
%Kyle Inzunza
%}


%close all waitbars if they exsist
try
    delete(findall(0));
catch
end
close all; %close windows
clc; %clear command window

load(exp_video);
 

%sync video 
disp('Syncing WEBCAM...');
sync_webcam = getsyncframegrey(web);
web = web(sync_webcam:end);

fnum = size(web,2);
p = zeros(6,fnum,2);
t = 220; %mask threshold
skip = 10;

[c,a] = blobprops(greymask(web{1},t)); %find markers in frame 1

%get init positions
printcircles(web{1}, c); %print circles to user
marker_num = 6;
marker = zeros(marker_num,2); %array to store marker positions
area = zeros(1,marker_num + 2); %array to store px area of all markers
q = 1;
%loop through every marker
for ii = 1:marker_num
    %loop until valid input
    while true
        temp = input(['ID #' num2str(ii) ': ']);
        
        if floor(temp) == temp && temp <= size(c,1) && temp > 0
            marker(ii,:) = c(temp,:); %record circle index
            
            area(q) = a(temp); %save area of marker
            q = q + 1; %increase counter
            
            break; %end loop
        else
            disp('Input invalid, try again.');
        end
    end
end


alimit = findarealimits(area); %find max and min area blob can be
marker = reshape(marker,[marker_num,2]);
p(:,1,:) = marker;




wb = waitbar(0,'Analysing webcam videos...');

%loop through video
for ii = 2:fnum
    waitbar(ii/fnum);
    
    if sum(sum(isnan(p(:,ii-1,:)))) == 0
        prev = p(:,ii-1,:); %postion of all previous frame white markers
    end
    
    %loop through every marker
    for jj = 1:6
        try
            
            p(jj,ii,:) = idblobgrey(web{ii},prev(jj,:,:),alimit,t);
            
        catch ME
            
            p(jj,ii:ii+skip,:) = nan*ones(size(p(jj,ii:ii+skip,:)));
            
%             %write next n positions as nan
            %             p(jj,ii:ii+skip,:) = nan*ones(size(p(jj,ii:ii+skip,:)));
%             
%             [c,~] = blobprops(greymask(web{ii+skip},t)); %find markers in frame after skip
%             printcircles(web{ii+skip}, c); %print circles to user
%             %loop through every marker
%             for kk = 1:marker_num
%                 %loop until valid input
%                 while true
%                     temp = input(['ID #' num2str(ii) ': ']);
%                     
%                     if floor(temp) == temp && temp <= size(c,1) && temp > 0
%                         marker(ii,:) = c(temp,:); %record circle index
%                         break; %end loop
%                     else
%                         disp('Input invalid, try again.');
%                     end
%                 end
%             end
            
        end
    end
    
    %p(:,ii,:) = webfindcircles(web{ii},160);
    
end

c = cell(6,1);
s = size(p,2);
for ii = 1:6
    c{ii} = reshape(p(ii,:,:),s,2);
end

disp("---COMPLETE---");
% 
% m1 = reshape(p(1,:,:),fnum,2);
% m2 = reshape(p(2,:,:),fnum,2);
% m3 = reshape(p(3,:,:),fnum,2);
% m4 = reshape(p(4,:,:),fnum,2);
% m5 = reshape(p(5,:,:),fnum,2);
% m6 = reshape(p(6,:,:),fnum,2);

close(wb);