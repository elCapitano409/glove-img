function sync = getsyncframe(gs)
%GETSYNCFRAME New version of function to identify the sync frame 

%image resolution
% [h,w] = size(gs{1});

imnum = size(gs,2);

% bw = cell(size(gs)); %cell array to hold black white frames
m = cell(size(gs));%cell array to hold mask
intensity = zeros(1,size(gs,2)); %vector to hold average light intensity

wb = waitbar(0,'Syncing video...');%start progress bar

%loop through images
for ii = 1:imnum
    
    waitbar(ii/imnum); %update progress bar
    
    m{ii} = gs{ii} >= getsyncthreshold(gs{1}); %mask that only shows pixels with intensity 250 or higher
    intensity(ii) = mean2(m{ii}); %get mean intensity of mask
end


% %top right corner
% if strcmp(corner,'tr')
%     for ii = 1:size(gs,2)
%         bw{ii} = imbinarize(gs{ii}); %convert to black white
%         
%         temp = bw{ii};
%         intensity(ii) = mean2(temp(0:h/2,w/2:w)); %get average intensity of image
%     end
% %top left corner
% elseif strcmp(corner,'tl')
%     for ii = 1:size(gs,2)
%         bw{ii} = imbinarize(gs{ii}); %convert to black white
%         
%         temp = bw{ii};
%         intensity(ii) = mean2(temp(0:h/2,0:w/2)); %get average intensity of image
%     end
% %bottom right corner
% elseif strcmp(corner,'br')
%     for ii = 1:size(gs,2)
%         bw{ii} = imbinarize(gs{ii}); %convert to black white
%         
%         temp = gs{ii};
%         intensity(ii) = mean2(temp(h/2:h,w/2:w)); %get average intensity of image
%     end
% %bottom left corner
% elseif strcmp(corner,'bl')
%     for ii = 1:size(gs,2)
%         bw{ii} = imbinarize(gs{ii}); %convert to black white
%         
%         temp = bw{ii};
%         intensity(ii) = mean2(temp(h/2:h,0:w/2)); %get average intensity of image
%     end
% %bottom half
% elseif strcmp(corner,'b')
%     for ii = 1:size(gs,2)
%         bw{ii} = imbinarize(gs{ii}); %convert to black white
%         
%         temp = bw{ii};
%         intensity(ii) = mean2(temp(h/2:h,:)); %get average intensity of image
%     end
% %top half
% elseif strcmp(corner,'t')
%     for ii = 1:size(gs,2)
%         bw{ii} = imbinarize(gs{ii}); %convert to black white
%         
%         temp = bw{ii};
%         intensity(ii) = mean2(temp(0:h/2,:)); %get average intensity of image
%     end
% end



intensity_deriv = gradient(intensity);%get gradient of the light intensity
[~,sync] = min(intensity_deriv); %sync frame is frame with largest negative change in intensity

close(wb); %close waitbar
end


