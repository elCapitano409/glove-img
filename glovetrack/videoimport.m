function videoimport(exp)
%VIDEOIMPORT imports videos of certain expirement and saves them as a .mat
%file

%concatonate names onto expirement name
vid_top_name = strcat(exp,'_top_trim');
vid_side_name = strcat(exp,'_side_trim');
vid_webcam_name = strcat(exp,'_web_trim');

%import videos as a cell array of greyscale frames
vid_top = vid2struct(vid_top_name); 
vid_side = vid2struct(vid_side_name); 
vid_web = vid2struct(vid_webcam_name); 

tic; %start timer
save([exp '.mat'],'vid_top','vid_side','vid_web','-v7.3'); %save three videos
toc; %end timer
end

