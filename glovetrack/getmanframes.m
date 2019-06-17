function manipulations = getmanframes()
%GETMANFRAMES prompts user for time stamps of manipulations and returns
%them as frame values

manipulations = cell(2,1); %array to store manipulation timestamps

%loop through 2 camera views 
for ii = 1:2

    %display feed name to user
    if ii == 1
        disp('---IONCAMERA---');
    elseif ii == 2
        disp('---WEBCAM---');
    end
    
    counter = 1; %counts the amount of manipulations
    m = zeros(100,2);% array to hold frame values of maniputlation timestamps
    %loop until user ends
    while true
        
        startf = input(['Input the start timestamp of manipulation ' num2str(counter) ' (if there are no more manipulations input "N") FORMAT(min:sec): '],'s'); %get start timestamp

        %if no more manipulations
        if strcmp(start,'N')
            break;
        else
            endf = input(['Input the end timestamp of manipulation ' num2str(counter) ': '],'s'); %get end timestamp
        end
        
        %get seconds and minutes from input
        startf = split(startf,':'); %split into minutes and seconds
        endf = split(endf,':'); %split into minutes and seconds
        
        %assumption that both cameras are 60 frames a second
        %add numerical values to array
        m(counter,1) = (str2double(startf{1})*60 + str2double(startf{2}))*60; %convert minutes and seconds to frames
        m(counter,2) = (str2double(endf{1})*60 + str2double(endf{2}))*60; %convert minutes and seconds to frames
        counter = counter+1; %increase counter by one
    end
    
    m = reshape(m(m~=0),sum(sum(m~=0))/2,2);%truncate off zeros
    manipulations{ii} = m;%add m to cell array
end

end

