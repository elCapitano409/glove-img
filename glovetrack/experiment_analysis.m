%{
%EXPERIMENT_ANALYSIS.m
%Kyle Inzunza
%} 

%% video import

%generate file names
expname = 'asdf'; %name of expirement
vid_top_name = strcat(expname,'_top');
vid_side_name = strcat(expname,'_side');
vid_webcam_name = strcat(expname,'_webcam');

%import videos as a cell array of greyscale frames
vid_top = RGBstrut2grey(vid2struct(vid_top_name)); 
vid_side = RGBstrut2grey(vid2struct(vid_side_name)); 
vid_webcam = RGBstrut2grey(vid2struct(vid_webcam_name)); 

%get video resolutions
top_res = size(vid_top{1});
side_res = size(vid_side{1});
webcam_res = size(vid_webcam{1});

%% sync videos

%top video

%side video
mon_res = [3 10]; %montage for resolution
time = input('What time does the light turn off in the side video?: '); %prompt user for input

offset = 0; %offset to timestamp
flag = true; %boolean to continue loop
while flag
    montage(vid_side((time + offset)*60:(time + offset)*60)+30,'Size',mon_res); %display 30 images
    %+ moves the montage forward half a second
    %- moves the montage backword half a second
    userin = input('Chose sync frame (or + to go forward,- to backword)');
    
    if()
end


%bottom video
