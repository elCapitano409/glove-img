function boolean = isman(frame,view,manipulations)
%ISMAN checks if given frame is a frame that involves manipulation

framerate = [25,30,30]; %framerates of cameras


%if there are no manipulations in either video feed
if isempty(manipulations{1}) && isempty(manipulations{2}) && isempty (manipulations{3})
    boolean = false;
else
    
    if view ~= 1 && view ~=2 && view ~= 3 %validate argument
        error('MyComponent:InvalidCameraView', "Error. \nInvalid camera view.");
    end
    
    
    boolean = false; %boolean that states if frame is a manipulation frame
    flag = false; %boolean if loop should break
    %loop through feeds
    for ii = size(manipulations,1)
        m = manipulations{ii}; %matrix that stores manipulation timestamps

        %loop through manipulations
        for jj = size(m,1)
            %if frame is within manipulation timestamp jj
            if (frame/framerate(view))*framerate(ii) >= m(jj,1) && (frame/framerate(view))*framerate(ii) <= m(jj,2)
                boolean = true; 
                flag = true;
                break;
            end
        end
        %if nested loop was brokem
        if flag
            break;
        end
    end
end
end

