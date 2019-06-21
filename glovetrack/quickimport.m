function [gs_side,gs_top,gs_web] = quickimport(exp)
%QUICKIMPORT imports all three videos with expirement name with the purpose
%of calibrating the find circle algorithm

%concatonate names onto expirement name
vid_top_name = strcat(exp,'_top_trim');
vid_side_name = strcat(exp,'_side_trim');
vid_webcam_name = strcat(exp,'_web_trim');

%import videos as a cell array of greyscale frames
gs_top = vid2struct(vid_top_name); 
gs_side = vid2struct(vid_side_name); 
gs_web = vid2struct(vid_webcam_name); 
end

