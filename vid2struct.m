function s=vid2struct(video_file)
%VID2STRUCT converts a video into a cell array of grayscale frame
filename = fullfile(pwd,[video_file,'.mp4']); % video to load
wb = waitbar(0,'Loading the file...');                     
v = VideoReader(filename);                                  

d = v.Duration;                                             
s = cell(1,floor(v.Duration*v.FrameRate));
k = 1;                                                      
while hasFrame(v)                                           
   f = readFrame(v);                                       
   s{k} = rgb2gray(f);
   k = k + 1;                                              
   waitbar(v.CurrentTime/d)                                
end

close(wb)                                                   
end

