%{
%EXPERIMENT_ANALYSIS.m
%Kyle Inzunza
%} 

% %% video import
% 
% %generate file names
expname = 'Task2_wrist_trial2'; %name of expirement
% vid_top_name = strcat(expname,'_top');
vid_side_name = strcat(expname,'_side_trim');
% vid_webcam_name = strcat(expname,'_webcam');
% 
% %import videos as a cell array of greyscale frames
% vid_top = RGBstrut2grey(vid2struct(vid_top_name)); 
vid_side = RGBstrut2grey(vid2struct(vid_side_name)); 
% vid_webcam = RGBstrut2grey(vid2struct(vid_webcam_name)); 
% 
% %get video resolutions
% top_res = size(vid_top{1});
% side_res = size(vid_side{1});
% webcam_res = size(vid_webcam{1});

manipulations = getmanframes(); %get frames that were manipulated in the expirement


%% sync videos

%get sync frames for all videos
% sync_top = getsyncframe(vid_top);
sync_side = getsyncframe(vid_side);
% sync_webcam = getsyncframe(vid_webcam);

%trim videos
% vid_top = vid_top(sync_top:end);
vid_side = vid_side(sync_side:end);
% vid_webcam = vid_webcam(sync_webcam:end);

% fnum = min([size(vid_top,2),size(vid_side,2),size(vid_webcam,2)]); %the shortest video's frame number is used for the global frame number
fnum = size(vid_side,2); %temp

%% circle identification side view

%find circles in frame 1
%radii and sensitivity has to be manually calibrated
rad_side = [6 10];
sen_side = 0.95;
c_side_w = imfindcircles(vid_side{1}, rad_side, 'ObjectPolarity', 'bright','Sensitivity',sen_side);
c_side_b = imfindcircles(vid_side{1}, rad_side, 'ObjectPolarity', 'dark','Sensitivity',sen_side);

%white markers
printcircles(vid_side{1}, c_side_w); %print circles to user
wmarker_num = input('How many white markers are being tracked: ');
wmarkerid_side = zeros(wmarker_num,1); %id numbers of white markers
wmarkername_side = cell(wmarker_num,1); %names of whitemarkers

%loop through every marker
for ii = 1:wmarker_num
    %loop until valid input
    while true
        temp = input(['ID #' num2str(ii) ': ']);
        
        %has not been input before
        if sum(ismember(wmarkerid_side,temp)) ~= 0
            disp('ID has alread been input.');
        %is an integer
        %is within the bounds    
        elseif floor(temp) == temp && temp <= size(c_side_w,1) && temp > 0
            wmarkerid_side(ii) = temp; %record circle index
            wmarkername_side{ii} = input('Marker name: ','s'); %get model id for that circle
            break; %end loop
        else
            disp('Input invalid, try again.');
        end
    end
end

%black markers
origin_side = zeros(1,2); %placeholder to store origin indecies
printcircles(vid_side{1}, c_side_b); %print circles to user
for ii = 1:2
    %loop until valid
    while true
        temp = input(['Circle of O' num2str(ii) ' (if not visible/not being tracked type 0): ']);
        if temp == 0
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
wmarkerid_top = zeros(wmarker_num,1); %id numbers of white markers
wmarkername_top = cell(wmarker_num,1); %names of whitemarkers

%loop through every marker
for ii = 1:wmarker_num
    %loop until valid input
    while true
        temp = input(['ID #' num2str(ii) ': ']);
        %has not been input before
        if sum(ismember(wmarkerid_top,temp)) ~= 0
            disp('ID has alread been input.');
        %is an integer
        %is within the bounds
        elseif floor(temp) == temp && temp <= size(c_top_w,1) && temp > 0
            wmarkerid_top(ii) = temp; %record circle index
            wmarkername_top{ii} = input('Marker name: ','s'); %get model id for that circle
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
        temp = input(['Circle of O' num2str(ii) ' (if not visible/not being tracked type "N"): '],'s');
        %compare string ignore case
        if temp==0
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

%data structure
%ptop -> position top camera -> (circle,frame,xy)
%mtop -> map of circle index to marker name -> (id)
%pside -> position side camera -> (circle,frame,xy)
%mside -> map of circle index to marker name -> (id)
%pweb -> position webcam -> (circle,frame,xy)
% d = struct('ptop', zeros(size(wmarkerid_top, 1) + sum(origin_top ~= 0), fnum,2), 'mtop', cell(1, size(wmarkerid_top,1) + sum(origin_top ~= 0)),...
%     'pside', zeros(size(wmarkerid_side, 1) + sum(origin_side ~= 0), fnum,2), 'mside', cell(1, size(wmarkerid_side, 1)+ sum(origin_side ~= 0)),...
%     'pweb', zeros(6, fnum, 2)); 

%new data structure initialization
d = struct('ptop', zeros(size(wmarkerid_top, 1) + sum(origin_top ~= 0), fnum,2), 'mtop',{},'markernum_top', [size(wmarkerid_top,1), sum(origin_top ~= 0)],...
    'pside', zeros(size(wmarkerid_side, 1) + sum(origin_side ~= 0), fnum,2), 'mside',{}, [size(wmarkerid_side,1), sum(origin_top ~= 0)],...
    'pweb', zeros(6, fnum, 2)); 


%populate map arrays

%cell array to store origin names
originname_top = {'O1';'O2'};
originname_side = {'O1';'O2'};

%indices of origins that don't exist
delete_o_side = find(origin_side == 0);
delete_o_top = find(origin_top == 0);

%delete elements at indices
originname_side(delete_o_side) = [];
originname_top(delete_o_top) = [];
origin_side(delete_o_side) = [];
origin_top(delete_o_top) = [];

%vertically concatonate the arrays
d.mside = [wmarkername_side;origin_side];
d.mtop = [wmarkername_top;originname_top];

%populate first frame of position data 

%loop through white markers
for ii = 1:d.markernum_side(1)
    d.pside(ii,1,:) = c_side_w(wmarkerid_side(ii),:); %set position of circle ii in frame 1
end
for ii = 1:d.markernum_top(1)
    d.ptop(ii,1,:) = c_top_w(wmarkerid_top(ii),:); %set position of circle ii in frame 1
end

%loop through black markers if they are found
if d.markernum_side(2) ~= 0
    for ii = 1:d.markernum_side(2)
        d.pside(ii + d.markernum_side(1),1,:) = c_side_b(origin_side(ii),:); %set position
    end
end
if d.markernum_top(2) ~= 0
    for ii = 1:d.markernum_top(2)
        d.pside(ii + d.markernum_top(1),1,:) = c_top_b(origin_top(ii),:); %set position
    end
end

d.pweb(:,1,:) = webfindcircles(vid_web{1}); %write webcam marker position for initial frame


%% remaining frames (side)

%loop through remaining frames
for ii = 2:fnum
    prevwc = d.pside(1:d.markernum_side(1),ii-1,:); %postion of all previous frame white markers
    prevbc = d.pside(d.markernum_side(1)+1:end,ii-1,:); %postion of all previous frame black markers
    
    maskedim_white = overlaycirclemask(vid_side{ii},prevwc); %overlay mask on current frame from positions of white markers in previous frame 
    maskedim_blk = overlaycirclemask(vid_side{ii},prevbc); %overlay mask on current frame from positions of black markers in previous frame 
    
    cw = imfindcircles(maskedim, rad_side, 'ObjectPolarity', 'bright','Sensitivity',sen_side); %get center of white circles in image
    cb = imfindcircles(maskedim, rad_side, 'ObjectPolarity', 'dark','Sensitivity',sen_side); %get center of black circles in image       
    
    try
        cw = idcircles(cw,prevwc);%identify white circles
        cb = idcircles(cb,prevbc);%identify black circles
    %some circles are not visible
    catch
        d.pside(:,ii,:) = nan*ones(size(d.pside(:,1,:))); %write the whole frame as not a number
    end
        
end


%% remaining frames (top)

%% remaining frame (webcam)

