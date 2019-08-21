%{
%EXPERIMENT_ANALYSIS.m
%Kyle Inzunza
%}

%% video import

exp = 'Task2_wrist_trial2'; %expirement name

%close all waitbars if they exsist
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
sync_top = getsyncframe(vid_top);
disp('Syncing ION CAMERA...');
sync_side = getsyncframe(vid_side);
disp('Syncing WEBCAM...');
sync_webcam = getsyncframe(vid_web);


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

%calibrate mask thresholds
thres_side_w = getmaskthreshold(vid_side{1},1);
thres_side_b = getmaskthreshold(vid_side{1},0);
thres_top_w = getmaskthreshold(vid_top{1},1);
thres_top_b = getmaskthreshold(vid_top{1},0);
thres_web = getmaskthreshold(vid_web{1},1);


% thres_side_w = 160;
% thres_side_b = 71;
% thres_top_w = 160;
% thres_top_b = 71;




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
    origin_name(cellfun(@isempty,origin_name)) = [];
    
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
d.pweb(:,1,:) = webfindcircles(vid_web{1});

close all; %close open figures

%% remaining frames 

%loop through cameras
for kk = 1:2
    
    if kk == 1 %side camera
        wb = waitbar(0,'Analysing ION CAMERA frames...'); %start progress bar
        tw = thres_side_w;
        tb = thres_side_b;
        alimit = alimit_side;
        wnum = d.markernum_side(1); %number of white markers
        bnum = d.markernum_side(2); %number of black markers
        video = vid_side;
        p = d.pside; %position matrix
        name = d.mside; %label vector
    else %top camera
        wb = waitbar(0,'Analysing CANON CAMERA frames...'); %start progress bar
        tw = thres_top_w;
        tb = thres_top_b;
        alimit = alimit_top;
        wnum = d.markernum_top(1); %number of white markers
        bnum = d.markernum_top(2); %number of black markers
        video = vid_top;
        p = d.ptop; %position matrix
        name = d.mtop;
    end
    
    
    %frame skipping variables
    s_mode = false; 
    s_counter = 0; %amount of frames skipped
    s_frame = 3; %amount of frames to be skipped
    
    
    for ii = 2:fnum %loop through remaining frames
        waitbar(ii/fnum); %update progress bar
        
        if isman(ii,manipulations) %check if frame ii is a manipulation frame
            p(:,ii,:) = nan*ones(size(p(:,1,:))); %write whole frame as not a number
            continue; %skip this loop interation
        end
        
        %skipping frames
        if s_mode && s_counter < s_frame
            s_counter = s_counter + 1;
            
            p(:,ii,:) = nan*ones(size(p(:,1,:))); %write whole frame as not a number
            continue; %go to next loop iteration
            
        end
        
        
        prevwc = p(1:wnum,ii-1,:); %postion of all previous frame white markers
        prevbc = p(wnum+1:end,ii-1,:); %postion of all previous frame black markers
        
        image = video{ii}; %store image
        
        if sum(sum(isnan(prevwc))) ~= 0 || sum(sum(isnan(prevbc))) ~= 0 %if previous frame contains NaN
            try
                p(:,ii,:) = usridblobs(image,tw,tb,name);
                
            catch ME
                if strcmpi(ME.identifier, 'MyComponent:WrongFrame')
                    s_counter = 0; %reset skip counter
                    continue; %go to next loop iteration
                else
                    rethrow(ME);
                end
            end
            %reset skip
            s_counter = 0;
            s_mode = false;
            continue; %go to next loop iteration
        end 
        
        try
            
            for jj = 1:wnum %loop through white markers
                p(jj,ii,:) = idblob(image, prevwc(jj,:,:),'bright',tw,alimit);
            end
            
            for jj = 1:bnum %loop through black markers
                p(jj + wnum,ii,:) = idblob(image, prevbc(jj,:,:),'dark',tb,alimit);
            end
            
        catch ME
            if strcmp(ME.identifier, 'MyComponent:MissingBlob') %if blob can't be found
                p(:,ii,:) = nan * ones(size(p(:,1,:))); %write whole frame as NaN
                s_mode = true;
            else
                rethrow(ME);
            end
        end
        
    end
    
    if kk == 1 %side camera
        d.pside = p;
    else %top camera
        d.ptop = p;
    end
    
    close(wb); %close progress bar
    clear 'p'; %delete temp pos matrix
end
close all; %close open figures

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

%format and write data to files
writematrix(formatdata(d.mside,d.pside), [exp '_side.xls']);
writematrix(formatdata(d.mtop,d.ptop), [exp '_top.xls']);
writematrix(formatdata({'Cord1','Cord2','Cord3','Cord4','Cord5','Cord6'},d.pweb), [exp '_web.xls']);

disp(['Processing of ' expname ' complete.']);





