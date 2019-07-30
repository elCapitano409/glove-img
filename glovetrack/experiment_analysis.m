%{
%EXPERIMENT_ANALYSIS.m
%Kyle Inzunza
%}

%% video import

exp = 'Task2_wrist_trial2'; %expirement name

%closNe all waitbars if they exsist
try
    delete(findall(0));
catch
end
close all; %close windows
clc; %clear command window

disp('Loading videos...');
%comment out to save runtime
%load(exp); %load videos

manipulations = getmanframes(); %get frames that were manipulated in the expirement


%% calibrate videos videos

%get sync frames for all videos
disp('Syncing CANON...');
%sync_top = getsyncframe(vid_top);
sync_top = 1;
disp('Syncing ION CAMERA...');
%sync_side = getsyncframe(vid_side);
sync_side = 1;
disp('Syncing WEBCAM...');
%sync_webcam = getsyncframe(vid_web);
sync_webcam = 1;

%if manipulations exist adjust manipulations to sync
if ~isempty(manipulations{1})
    manipulations{1} = manipulations{1} - sync_side;
end
if ~isempty(manipulations{2})
    manipulations{2} = manipulations{2} - sync_webcam;
end

%trim videos
vid_top = vid_top(sync_top:end);
vid_side = vid_side(sync_side:end);
vid_web = vid_web(sync_webcam:end);

fnum = min([size(vid_top,2),size(vid_side,2),size(vid_web,2)]); %the shortest video's frame number is used for the global frame number

% %calibrate mask thresholds
% thres_side_w = getmaskthreshold(vid_side{1},1);
% thres_side_b = getmaskthreshold(vid_side{1},0);
% thres_top_w = getmaskthreshold(vid_top{1},1);
% thres_top_b = getmaskthreshold(vid_top{1},0);
% thres_web = getmaskthreshold(vid_web{1},1);
thres_side_w = 170;
thres_side_b = 71;
thres_top_w = 170;
thres_top_b = 71;



%% circle identification

%loop through 2 cameras
for jj = 1:2

    %change values based on camera
    if jj == 1 %side
        image = vid_side{1};
        tw = thres_side_w;
        tb = thres_side_b;
    else %top
        image = vid_top{1};
        tw = thres_top_w;
        tb = thres_top_b;
    end
    
    [cw,aw,cb,ab] = blobprops(image,tw,tb); %find markers in frame 1
    
    q = 1; %counter for area index used in two for loops 
    
    printcircles(image, cw); %print circles to user
    wmarker_num = input('How many white markers are being tracked: ');
    wmarkername = cell(wmarker_num,1); %names of whitemarkers
    wmarker = zeros(wmarker_num,2);
    
    area = zeros(1,wmarker_num + 2); %array to store px area of all markers
    
    %loop through every white marker
    for ii = 1:wmarker_num
        %loop until valid input
        while true
            temp = input(['ID #' num2str(ii) ': ']);
            
            if floor(temp) == temp && temp <= size(cw,1) && temp > 0
                wmarker(ii,:) = cw(temp,:); %record circle index
                wmarkername{ii} = input('Marker name: ','s'); %get model id for that circle
                
                area(q) = aw(temp); %save area of marker
                q = q + 1; %increase counter
                
                break; %end loop
            else
                disp('Input invalid, try again.');
            end
        end
    end
    
    %black markers
    printcircles(image, cb); %print circles to user
    k = 1; %counts how many origins have been input
    origin_name = cell(1,2); %cell array to hold names
    origin = zeros(2); %array to hold origin coordinates
    for ii = 1:2
        %loop until valid
        while true
            temp = input(['Circle of O' num2str(ii - 1) ' (if not visible/not being tracked type 0): ']);
            if temp == 0
                break; %end loop
                %check if input valid
            elseif floor(temp) == temp && temp <= size(cb,1) && temp > 0
                origin(k,:) = cb(temp,:); %record origin coordinates
                origin_name{k} = ['O' num2str(ii - 1)]; %record origin name
                k = k + 1; %increase counter
                
                area(q) = ab(temp); %save area of marker
                q = q + 1; %increase counter
                
                break; %end loop
            else
                disp('Input invalid, try again.');
            end
        end
    end
    
    
    %truncate unused parts of arrays
    origin(origin == 0) = [];
    area(area == 0) = [];
    wmarker(wmarker == 0) = [];
    origin_name(cellfun(@isempty,origin_side_name)) = [];
    
    if jj == 1 %side
        alimit_side = findarealimits(area); %find max and min area blob can be
        origin_side_name = origin_name;
        wmarkername_side = wmarkername;
        %reshape to 2 columns
        wmarker_side = reshape(wmarker,wmarker_num,2);
        origin_side = reshape(origin,k-1,2);
        
    else %top
        alimit_top = findarealimits(area); %find max and min area blob can be
        origin_top_name = origin_name;
        wmarkername_top = wmarkername;
        %reshape to two columns
        wmarker_top = reshape(wmarker,wmarker_num,2);
        origin_top = reshape(origin,k-1,2);
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
d = struct('ptop', zeros(size(wmarker_top, 1) + size(origin_top,1), fnum,2), 'mtop',[],'markernum_top', [size(wmarker_top,1), size(origin_top,1)],...
    'pside', zeros(size(wmarker_side, 1) + size(origin_side,1), fnum,2), 'mside',[],'markernum_side', [size(wmarker_side,1), size(origin_side,1)],...
    'pweb', zeros(6, fnum, 2));


%populate map arrays
%vertically concatonate the arrays
d.mside = [wmarkername_side;origin_side_name'];
d.mtop = [wmarkername_top;origin_top_name'];

%populate first frame of position data
d.pside(:,1,:) = [wmarker_side;origin_side];
d.ptop(:,1,:) = [wmarker_top;origin_top];

%{
%loop through white markers
for ii = 1:d.markernum_side(1)
    d.pside(ii,1,:) = c_side_w(wmarker_side(ii),:); %set position of circle ii in frame 1
end
for ii = 1:d.markernum_top(1)
    d.ptop(ii,1,:) = c_top_w(wmarkerid_top(ii),:); %set position of circle ii in frame 1
end

%loop through black markers if they are found
if d.markernum_side(2) ~= 0
    for ii = 1:d.markernum_side(2)
        d.pside(ii + d.markernum_side(1),1,:) = origin_side(ii,:); %set position
    end
end
if d.markernum_top(2) ~= 0
    for ii = 1:d.markernum_top(2)
        d.ptop(ii+ d.markernum_top(1),1,:) = origin_top(ii,:); %set position
    end
end
%}
d.pweb(:,1,:) = webfindcircles(vid_web{1}); %write webcam marker position for initial frame

close all; %close open figures

%% remaining frames (side)

wb = waitbar(0,'Analysing ION CAMERA frames...'); %start progress bar
wnum = d.markernum_side(1); %number of white markers
bnum = d.markernum_side(2); %number of black markeres

%mask thresholds
tw = thres_side_w;
tb = thres_side_b;

for ii = 2:fnum %loop through remaining frames
    waitbar(ii/fnum); %update progress bar
        
    if isman(ii,manipulations) %check if frame ii is a manipulation frame
        d.pside(:,ii,:) = nan*ones(size(d.pside(:,1,:))); %write the whole frame as not a number
        continue; %skip this loop interation
    end
    
    prevwc = d.pside(1:wnum,ii-1,:); %postion of all previous frame white markers
    prevbc = d.pside(wnum+1:end,ii-1,:); %postion of all previous frame black markers
    
    if sum(sum(isnan(prevwc))) ~= 0 || sum(sum(isnan(prevbc))) ~= 0 %if previous frame contains NaN
        %TODO: add user re identification
    end
    
    image = vid_side{ii}; %store image
    
    for jj = 1:wnum %loop through white markers
        d.pside(jj,ii,:) = idblob(image, prevwc(jj,:,:),'bright',tw);
    end
    
    for jj = 1:bnum %loop through black markers
        d.pside(jj + wnum,ii,:) = idblob(image, prevbc(jj,:,:),'dark',tb);
    end
    
end

close(wb); %close progress bar
close all; %close open figures

%% remaining frames (top)

wb = waitbar(0,'Analysing CANON CAMERA frames...'); %start progress bar

%loop through remaining frames
for ii = 2:fnum
    waitbar(ii/fnum); %update progress bar
    
    %check if frame needs to be skipped
    if skip_mode && skip_counter < frame_skip
        skip_counter = skip_counter+1; 
        d.ptop(:,ii,:) = nan*ones(size(d.ptop(:,1,:))); %write skipped frame as not a number
        continue; %go to next iteration
    else
        %reset skip variables
        skip_mode = false;
        skip_counter = 0;
    end
    
    %check if frame ii is a manipulation frame
    if isman(ii,manipulations)
        d.ptop(:,ii,:) = nan*ones(size(d.ptop(:,1,:))); %write the whole frame as not a number
        continue; %skip this loop interation
    end
    
    prevwc = d.ptop(1:d.markernum_top(1),ii-1,:); %postion of all previous frame white markers
    prevbc = d.ptop(d.markernum_top(1)+1:end,ii-1,:); %postion of all previous frame black markers
    
    %if previous frame contained doens't contain NaN
    if sum(sum(isnan(prevwc))) == 0 && sum(sum(isnan(prevbc))) == 0
        
        maskedim_white = overlaycirclemask(vid_top{ii},prevwc); %overlay mask on current frame from positions of white markers in previous frame
        maskedim_blk = overlaycirclemask(vid_top{ii},prevbc); %overlay mask on current frame from positions of black markers in previous frame
        
        cw = imfindcircles(maskedim_white, rad_top, 'ObjectPolarity', 'bright','Sensitivity',sen_top); %get center of white circles in image
        cb = imfindcircles(maskedim_blk, rad_top, 'ObjectPolarity', 'dark','Sensitivity',sen_top + 0.03); %get center of black circles in image
        
        cb = deletecircles(cb, ignorec); %get rid of any optical table dots
        
        try
            cw = idcircles(cw,prevwc,d.markernum_top(1));%identify white circles
            cb = idcircles(cb,prevbc,d.markernum_top(2));%identify black circles
            
            d.ptop(:,ii,:) = [cw;cb]; %save circle positions
            
        catch ME
            switch ME.identifier
                %some circles are not visible
                case 'MyComponent:notenoughmarkers'
                    disp(['Circles missing on CANON at frame ' num2str(ii)]);
                    d.ptop(:,ii,:) = nan*ones(size(d.ptop(:,1,:))); %write the whole frame as not a number
                    missing_counter = missing_counter + 1;
                
                %previous case was written all as nan
                case 'MyComponent:nullprevframe'
                    disp("Error. \nProblem with if statement.");%if this error was thrown it passed the if statment that should stop nan values
                    rethrow(ME);
                 %not expected error
                otherwise
                    rethrow(ME); %rethrow exception
            end
        end
        
    elseif missing_counter <= missing_limit && ~usr_id_mode %if the program needs to reid missing circles 
        missing_counter = missing_counter + 1; %add one to missing counter
        
        %get last known positions of circles
        prevwc = d.ptop(1:d.markernum_top(1),ii-missing_counter,:); %white markers
        prevbc = d.ptop(d.markernum_top(1)+1:end,ii-missing_counter,:); %black markers

        
%         %mask current frame images with previous circles
%         try
%             maskedim_white = overlaycirclemask(vid_side{ii},prevwc); %white markers
%             maskedim_blk = overlaycirclemask(vid_side{ii},prevbc); %black markers
%         catch ME
%             rethrow(ME);
%         end
        
        cw = imfindcircles(vid_top{ii}, rad_top, 'ObjectPolarity', 'bright','Sensitivity',sen_top); %get center of white circles in image
        cb = imfindcircles(vid_top{ii}, rad_top, 'ObjectPolarity', 'dark','Sensitivity',sen_top); %get center of black circles in image
        
        try
            cw = idcircles(cw,prevwc,d.markernum_top(1));%identify white circles
            cb = idcircles(cb,prevbc,d.markernum_top(2));%identify black circles
            
            d.ptop(:,ii,:) = [cw;cb]; %save circle positions
            missing_counter = 0; %reset counter
            
        catch ME
            switch ME.identifier
                %some circles are not visible
                case 'MyComponent:notenoughmarkers'
                    disp(['Circles missing on CANON at frame ' num2str(ii)]);
                    d.ptop(:,ii,:) = nan*ones(size(d.ptop(:,1,:))); %write the whole frame as not a number
                %previous case was written all as nan
                case 'MyComponent:nullprevframe'
                    disp("Error. \nProblem with if statement.");%if this error was thrown it passed the if statment that should stop nan values
                    rethrow(ME)
                    %not expected error
                otherwise
                    rethrow(ME); %rethrow exception
            end
        end
    else %if the user needs to reid the circles
        usr_id_mode = true; %turn on user id mode
        missing_counter = 0; %reset missing counter
        try
            cw = imfindcircles(vid_top{ii}, rad_top, 'ObjectPolarity', 'bright','Sensitivity',sen_top); %get center of white circles in image
            cb = imfindcircles(vid_top{ii}, rad_top, 'ObjectPolarity', 'dark','Sensitivity',sen_top); %get center of black circles in image
            
            d.ptop(:,ii,:) = usridcircles(vid_top{ii},cw,cb,d.mtop); %get user to re-identify markers
        catch ME
            switch ME.identifier
                %all circles are still not visible in frame
                case 'MyComponent:wrongframe'
                    d.ptop(:,ii,:) = nan*ones(size(d.ptop(:,1,:))); %write the whole frame as not a number
                    skip_mode = true; %turn on skip mode to skip next n frames
                    continue; %go to next iteration of loop
                otherwise
                    rethrow(ME);
            end
        end
        usr_id_mode = false; %block can only be completed when user inputs correct values
    end
end

close(wb); %close progress bar

%% remaining frame (webcam)

wb = waitbar(0,'Analysing webcam frames...'); %start progress bar

%loop through remaining frames
for ii = 2:fnum
    
    waitbar(ii/fnum); %update progress bar
    
    %check if manipulation frame
    if isman(ii,manipulations)
        d.pweb(:,ii,:) = nan*ones(6,2); %write the whole frame as not a number
        continue; %go to next iteration of loop
    end
    
    
    try
        d.pweb(:,ii,:) = webfindcircles(vid_web{ii}); %get marker positions
    catch ME
        switch ME.identifier
            case 'MyComponent:blocked'
                d.pweb(:,ii,:) = nan*ones(6,2); %write the whole frame as not a number
                disp(['Circles missing on WEBCAM at frame ' num2str(ii)]);
            case 'MyComponent:watchDog'
                d.pweb(:,ii,:) = nan*ones(6,2); %write the whole frame as not a number
                disp(['Too many circles on WEBCAM at frame ' num2str(ii)]);
                imshow(vid_web{ii}); %display current frame
            otherwise
                rethrow(ME); %error was not resolved
        end
    end
end

close(wb); %close progress bar

%% write data

%concatonate headers onto data
data_side = [d.mside';num2cell(d.pside)];
data_top = [d.mtop';num2cell(d.ptop)];
data_web = [{'Cord1','Cord2','Cord3','Cord4','Cord5','Cord6'},num2cell(d.pweb)];

%write data to files
writematrix(data_side, [expname '_side.xls']);
writematrix(data_top, [expname '_top.xls']);
writematrix(data_web, [expname '_web.xls']);







