function s = vid2structRGB(video_file)
%VID2STRUCTRGB converts video into cell array of frame the red, blue, and green channels.




filename = fullfile(pwd,[video_file,'.mp4']); % video to load
wb = waitbar(0,'Loading the file...');                      % show progress bar
v = VideoReader(filename);                                  % create VideoReader object
w = v.Width;                                                % get width
h = v.Height;                                               % get height
d = v.Duration;                                             % get duration
n = floor(v.Duration*v.FrameRate);                          % get number of frames
s = struct('r',cell(1,n),'g',cell(1,n),'b',cell(1,n));      % allocate structure
k = 1;                                                      % initialize counter
while hasFrame(v)                                           % while object has frame
   f = readFrame(v);                                        % read the frame
   s(k).r = reshape(f(:,:,1),[h w]);                        % save specific colour channel 
   s(k).g = reshape(f(:,:,2),[h w]);
   s(k).b = reshape(f(:,:,3),[h w]);
   k = k + 1;                                               % increment counter
   waitbar(v.CurrentTime/d)                                 % update progress bar
end

close(wb)                                                   % close progress bar
end



