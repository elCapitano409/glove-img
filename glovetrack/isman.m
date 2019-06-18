function boolean = isman(frame,manipulations)
%ISMAN checks if given frame is a frame that involves manipulation

boolean = false; %boolean that states if frame is a manipulation frame
flag = false; %boolean if loop should break
%loop through feeds
for ii = size(manipulations,1)
    m = manipulations{ii}; %matrix that stores manipulation timestamps
    
    %loop through manipulations
    for jj = size(m,1)
        %if frame is within manipulation timestamp jj
        if frame >= m(jj,1) && frame <= m(jj,2)
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

