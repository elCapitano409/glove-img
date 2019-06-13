%{
%EXPERIMENT_ANALYSIS.m
%Kyle Inzunza
%} 

% %% video import
% 
% %generate file names
% expname = 'asdf'; %name of expirement
% vid_top_name = strcat(expname,'_top');
% vid_side_name = strcat(expname,'_side');
% vid_webcam_name = strcat(expname,'_webcam');
% 
% %import videos as a cell array of greyscale frames
% vid_top = RGBstrut2grey(vid2struct(vid_top_name)); 
% vid_side = RGBstrut2grey(vid2struct(vid_side_name)); 
% vid_webcam = RGBstrut2grey(vid2struct(vid_webcam_name)); 
% 
% %get video resolutions
% top_res = size(vid_top{1});
% side_res = size(vid_side{1});
% webcam_res = size(vid_webcam{1});

%% sync videos

%get sync frames for all videos
sync_top = getsyncframe(vid_top);
sync_side = getsyncframe(vid_side);
sync_webcam = getsyncframe(vid_webcam);

%trim videos
vid_top = vid_top(sync_top:end);
vid_side = vid_side(sync_side:end);
vid_webcam = vid_webcam(sync_webcam:end);

fnum = min([size(vid_top,2),size(vid_side,2),size(vid_webcam,2)]); %the shortest video's frame number is used for the global frame number

%% circle identification side view

%find circles in frame 1
%radii and sensitivity has to be manually calibrated
c_side_w = imfindcircles(vid_side{1}, [1 3], 'ObjectPolarity', 'bright','Sensitivity',.95);
c_side_b = imfindcircles(vid_side{1}, [1 3], 'ObjectPolarity', 'dark','Sensitivity',.95);

%white markers
printcircles(vid_sid{1}, c_side_w); %print circles to user
wmarker_num = input('How many white markers are being tracked: ');
wmarkerid_side = cell(wmarker_num,2); %cell array to hold id of white markers

%loop through every marker
for ii = 1:wmarker_num
    %loop until valid input
    while true
        temp = input(['ID #' num2str(ii) ': ']);
        %validate input:
        %is an integer
        %is within the bounds
        if floor(temp) == temp && temp <= size(c_side_w,1) && temp > 0
            wmarkerid_side{ii,1} = temp; %record circle index
            wmarkerid_side{ii,2} = input('Input model ID: '); %get model id for that circle
            break; %end loop
        else
            disp('Input invalid, try again.');
        end
    end
end

%black markers
origin_side = zeros(1,2); %placeholder to store origin indecies
printcircles(vid_sid{1}, c_side_b); %print circles to user
for ii = 1:2
    %loop until valid
    while true
        temp = input(['Circle of O' num2str(ii) ' (if not visible/not being tracked type "N"): ']);
        %compare string ignore case
        if strcmpi(temp, 'N')
            origin_side(ii) = 0; %zero placerholder
            break; %end loop
        %check if input valid
        elseif floor(temp) == temp && temp <= size(c_side_b,1) && temp > 0
            origin_side(ii) = temp; %record input as origin index
            break; %end loop
        else
            disp('Input invalid, try again.');
        end
    end
end


%% circle identification top view

%find circles in frame 1
%radii and sensitivity has to be manually calibrated
c_top_w = imfindcircles(vid_top{1}, [1 3], 'ObjectPolarity', 'bright','Sensitivity',.95);
c_top_b = imfindcircles(vid_top{1}, [1 3], 'ObjectPolarity', 'dark','Sensitivity',.95);

%white markers
printcircles(vid_sid{1}, c_top_w); %print circles to user
wmarker_num = input('How many white markers are being tracked: ');
wmarkerid_top = cell(wmarker_num,2); %cell array to hold id of white markers

%loop through every marker
for ii = 1:wmarker_num
    %loop until valid input
    while true
        temp = input(['ID #' num2str(ii) ': ']);
        %validate input:
        %is an integer
        %is within the bounds
        if floor(temp) == temp && temp <= size(c_top_w,1) && temp > 0
            wmarkerid_top{ii,1} = temp; %record circle index
            wmarkerid_top{ii,2} = input('Input model ID: '); %get model id for that circle
            break; %end loop
        else
            disp('Input invalid, try again.');
        end
    end
end

%black markers
origin_top = zeros(1,2); %placeholder to store origin indecies
printcircles(vid_sid{1}, c_top_b); %print circles to user
for ii = 1:2
    %loop until valid
    while true
        temp = input(['Circle of O' num2str(ii) ' (if not visible/not being tracked type "N"): ']);
        %compare string ignore case
        if strcmpi(temp, 'N')
            origin_top(ii) = 0; %zero placerholder
            break; %end loop
        %check if input valid
        elseif floor(temp) == temp && temp <= size(c_top_b,1) && temp > 0
            origin_top(ii) = temp; %record input as origin index
            break; %end loop
        else
            disp('Input invalid, try again.');
        end
    end
end

%% sort identified circles

d = struct('ptop',zeros(size(wmarkerid_top,1),fnum,2),'mtop',zeros(1,size(wmarkerid_top,1)),...
   'pside',zeros(size(wmarkerid_side,1),fnum,2)),'mside',zeros(1,size(wmarkerid_side,1)),'pweb',zeros(6,fnum,2); 
