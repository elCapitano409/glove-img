function s=vid2struct(video_file)
%VID2STRUCT converts a video into a struct of RGB frames
filename = fullfile(pwd,[video_file,'.mp4']); % video to load
wb = waitbar(0,'Loading the file...');                      % show progress bar
v = VideoReader(filename);                                  % create VideoReader object

d = v.Duration;                                             % get duration
s = cell(1,floor(v.Duration*v.FrameRate));
k = 1;                                                      % initialize counter
while hasFrame(v)                                           % while object has frame
   f = readFrame(v);                                       % read the frame
   s{k} = rgb2gray(f);
   k = k + 1;                                              % increment counter
   waitbar(v.CurrentTime/d)                                % update progress bar
end

close(wb)                                                   % close progress bar
end

