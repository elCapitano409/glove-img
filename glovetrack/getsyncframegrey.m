function sync = getsyncframegrey(gs)
%GETSYNCFRAME New version of function to identify the sync frame that
%checks in grayscale

f_max = 250; %maximum number of frames to search

intensity = zeros(1,f_max); %vector to hold average light intensity
threshold = 252;
wb = waitbar(0,'Syncing video...');%start progress bar


%loop through images
for ii = 1:f_max
    
    %WORK IN PROGRESS
    waitbar(ii/f_max); %update progress bar
%     mask = rgb2gray(cat(3,s(ii).r,s(ii).g,s(ii).b)) > threshold; %copy image to mask
    mask = gs{ii} > threshold;
    intensity(ii) = mean2(mask); %get mean intensity of mask
end


intensity_deriv = gradient(intensity);%get gradient of the light intensity
[~,sync] = min(intensity_deriv); %sync frame is frame with largest negative change in intensity

close(wb); %close waitbar
end


