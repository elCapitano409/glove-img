function csort = usridcircles(image,cw,cb,cname)
%USRIDCIRCLES user is prompted to reidentify circles after they have been
%lost

cnum = size(cname,1); %number of circles being tracked
csort = zeros(cnum,2); %array to store marker positions in the same order as name array

%% white markers

printcircles(image, cw); %print white circles to user

%loop through number of circles being tracked
for ii = 1:cnum
    %check if white circle
    if ~strcmp(cname{ii},'O1') && ~strcmp(cname{ii},'O2')
        %loop until valid
        while true
            index = input(['Input the ID of marker ' cname{ii} ' (if it is not visible in frame type "N"): '],'s');
           
            %if user entered "N"
            if strcmp(index,"N")
                error('MyComponent:wrongframe','Error.\nNot all circles visible in this frame.');
            end
            
            index = str2double(index); %convert string into number
            
            %is an integer
            %is within the bounds
            if floor(index) == index && index <= size(cw,1) && index > 0
                csort(ii,:) = cw(index,:); %set circle coordinates
                break; %end loop
            else
                disp('Invalid input.');
            end
        end
    else 
        break; %end loop
    end
end


%% black markers 

printcircles(image, cb); %print black circles to user

%loop through number of circles being tracked
for ii = 1:cnum
    %check if O1 or O2 (only black markers)
    if strcmp(cname{ii},'O0') || strcmp(cname{ii},'O0')
        %loop until valid
        while true
            index = input(['Input the ID of marker ' cname{ii} ': (if it is not visible in frame type "N"): ']);
            
            %if user entered "N"
            if strcmp(index,"N")
                error('MyComponent:wrongframe','Error.\nNot all circles visible in this frame.');
            end
            
            %is an integer
            %is within the bounds
            if floor(index) == index && index <= size(cb,1) && index > 0
                csort(ii,:) = cw(index,:); %set circle coordinates
                break; %end loop
            else
                disp('Invalid input.');
            end
        end
    end
end


end

