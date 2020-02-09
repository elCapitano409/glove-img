%{
%EXPERIMENT_ANALYSIS.m
%Kyle Inzunza
%}

%only for glove video


%% video import

%exp = 'blue_index'; %expirement name

%close all waitbars if they exsist
try
    delete(findall(0));
catch
end
close all; %close windows
clc; %clear command window

disp('Loading videos...');
%comment out to save runtime
%tic;
%load(exp); %load bluescale video
%toc

%keep original function for simplicity
manipulations = getmanframes(); %get frames that were manipulated in the expirement


%% calibrate videos 

%TODO: fix this to single joint

%get sync frames for all videos
disp('Syncing wearable video...');
sync_top = getsyncframe(vid);
% disp('Syncing WEBCAM...');
% sync_webcam = getsyncframegrey(web);


% %if manipulations exist adjust manipulations to sync
% if ~isempty(manipulations{1})
%     manipulations{1} = manipulations{1} - sync_side;
% end
% if ~isempty(manipulations{2})
%     manipulations{2} = manipulations{2} - sync_top;
% end
% if ~isempty(manipulations{3})
%     manipulations{3} = manipulations{3} - sync_webcam;
% end
% 
%trim videos
%vid = vid(sync_top:end);
% web = web(sync_webcam:end);
% vid_side = vid_side(sync_side:end);
% vid_web = vid_web(sync_webcam:end);
% 
%[~,fnum] = min([size(vid,2),size(web,2)]);%the shortest video's frame number is used for the global frame number
fnum = size(vid,2);
%% circle identification


image = vid(1);
image_g = rgb2gray(cat(3,image.r,image.g,image.b));

[c,a] = blobprops(rgbmask(image,'b')); %find markers in frame 1

q = 1; %counter for area index used in two for loops

printcircles(image_g, c); %print circles to user
marker_num = input('How many markers are being tracked: ');
markername = cell(marker_num,1); %names of markers
marker = zeros(marker_num,2); %array to store marker positions
area = zeros(1,marker_num + 2); %array to store px area of all markers

%loop through every marker
for ii = 1:marker_num
    %loop until valid input
    while true
        temp = input(['ID #' num2str(ii) ': ']);
        
        if floor(temp) == temp && temp <= size(c,1) && temp > 0
            marker(ii,:) = c(temp,:); %record circle index
            markername{ii} = input('Marker name: ','s'); %get model id for that circle
            
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


   


%% sort identified circles

%data structure
%ptop -> position top camera -> (circle,frame,xy)
%mtop -> map of circle index to marker name -> (id)
%pside -> position side camera -> (circle,frame,xy)
%mside -> map of circle index to marker name -> (id)
%pweb -> position webcam -> (circle,frame,xy)

%new data structure initialization
d = struct('p', zeros(marker_num, fnum,2),'name',[]);


%populate name array
d.name = markername;

%populate first frame of position data
d.p(:,1,:) = marker;

close all; %close open figures

%% remaining frames

%wearable video


wb = waitbar(0,'Analysing frames...'); %start progress bar


%frame skipping variables
s_mode = false;
s_counter = 0; %amount of frames skipped
s_frame = 1; %amount of frames to be skipped


for ii = 2:fnum %loop through remaining frames
    waitbar(ii/fnum); %update progress bar
    
    if isman(ii,1,manipulations) %check if frame ii is a manipulation frame
        d.p(:,ii,:) = nan*ones(size(d.p(:,1,:))); %write whole frame as not a number
        continue; %skip this loop interation
    end
    
    %skipping frames
    if s_mode && s_counter < s_frame
        s_counter = s_counter + 1;
        
        d.p(:,ii,:) = nan*ones(size(d.p(:,1,:))); %write whole frame as not a number
        continue; %go to next loop iteration
        
    end
    
    if sum(sum(isnan(d.p(1:marker_num,ii-1,:)))) == 0
        prevc = d.p(1:marker_num,ii-1,:); %postion of all previous frame white markers
    end
    
    image = vid(ii); %store image
    
%     if sum(sum(isnan(prevc))) ~= 0  %if previous frame contains NaN
%         
%         
%         try
%             %d.p(:,ii,:) = usridblobs(image,tw,tb,name);
%             
%         catch ME
%             if strcmpi(ME.identifier, 'MyComponent:WrongFrame')
%                 s_counter = 0; %reset skip counter
%                 continue; %go to next loop iteration
%             else
%                 rethrow(ME);
%             end
% %         end
% %reset skip
% s_counter = 0;
% s_mode = false;
% continue; %go to next loop iteration
% end
    
    try
        
        for jj = 1:marker_num %loop through  markers
            d.p(jj,ii,:) = idblob(image, prevc(jj,:,:), alimit);
        end
        
    catch ME
        if strcmp(ME.identifier, 'MyComponent:MissingBlob') %if blob can't be found
            d.p(:,ii,:) = nan * ones(size(d.p(:,1,:))); %write whole frame as NaN
            %s_mode = true;
        else
            rethrow(ME);
        end
    end
    
end

close(wb); %close progress bar

close all; %close open figures


% %do webcam stuff in other another script
% %% remaining frame (webcam)
% 
% wb = waitbar(0,'Analysing webcam frames...'); %start progress bar
% 
% %loop through remaining frames
% for ii = 2:fnum
%     
%     waitbar(ii/fnum); %update progress bar
%     
%     %check if manipulation frame
%     if isman(ii,manipulations)
%         d.pweb(:,ii,:) = nan*ones(6,2); %write the whole frame as not a number
%         continue; %go to next iteration of loop
%     end
%     
%     d.pweb(:,ii,:,thres_web) = webfindcircles(vid_web{ii}); %get marker positions
%     
% end



% %% write data
% 
% %for now do everything from copy pasting to excel
% %format and write data to files
% 
% %downsample data
% d.pside = dsample30to25(d.pside);
% d.pweb = dsample30to25(d.pweb);
% 
% %save data to excel
% writematrix(formatdata(d.mside,d.pside), [exp '_side.xls']);
% writematrix(formatdata(d.mtop,d.ptop), [exp '_top.xls']);
% writematrix(formatdata({'Cord1','Cord2','Cord3','Cord4','Cord5','Cord6'},d.pweb), [exp '_web.xls']);
% 
% save expresults.mat d %save data to .mat
% 
% disp(['Processing of ' expname ' complete.']);





