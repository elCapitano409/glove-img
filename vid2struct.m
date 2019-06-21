function s=vid2struct(video_file)
%VID2STRUCT converts a video into a struct of RGB frames
filename = fullfile(pwd,[video_file,'.mp4']); % video to load
wb = waitbar(0,'Loading the file...');                      % show progress bar
v = VideoReader(filename);                                  % create VideoReader object
w = v.Width;                                                % get width
h = v.Height;                                               % get height
d = v.Duration;                                             % get duration
% s = struct('cdata',zeros(h,w,'uint8'),'colormap',[]);  % struct to hold frames
s = cell(1,floor(v.Duration*v.FrameRate));
k = 1;                                                      % initialize counter
while hasFrame(v)                                           % while object has frame
   f = readFrame(v);                                       % read the frame
%    s(k).cdata = rgb2gray(f); %  = imrotate(f,90);                    % rotate frame as needed
   %s(k).gdata = f(:,:,2);
   s{k} = rgb2gray(f);
   k = k + 1;                                              % increment counter
   waitbar(v.CurrentTime/d)                                % update progress bar
end
% v.CurrentTime = 18;                                         % set current time
% f = readFrame(v);                                           % get the frame
close(wb)                                                   % close progress bar
% % axes                                                        % create axes
% % imshow(f)                                                   % show the frame
% % title('Final Gesture Frame')                                  % add title
% save(fullfile(pwd,[video_file,'.mat']),'v','s');

% fps = v.FrameRate;                                          % get frame rate
% startTime = 0.04;                                             % in seconds
% endTime = 8;                                               % in seconds
% speed =  1;                                               % play back speed
% startFrame = floor(startTime * fps);                        % starting frame
% endFrame = floor(endTime * fps);                            % ending frame
% curAxes = axes;                                             % create axes
% hImage = imshow(s(startFrame).cdata,'Parent',curAxes);                      % create hande
% curAxes.XLim = [0 hImage.XData(2)];
% curAxes.YLim = [0 hImage.YData(2)];
% title('Gesture Video')                                        % add title
% for k = startFrame + 1:endFrame                             % loop over others
%     set(hImage,'CData',s(k).cdata);                         % update underlying data
%     pause(1/(fps*speed));                                   % pause for specified speed
% end
%
% clear hImage

end

