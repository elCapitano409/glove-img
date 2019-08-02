function c = usridblobs(image,tw,tb,name)
%USRIDBLOB prompts user to reidentify markers

cnum = size(name,1); %number of markers
c = zeros(cnum,2); %marker positions

[pw,~,pb,~] = blobprops(image,tw,tb);
 
printcircles(image, pw); %display white circles

for ii = 1:cnum %loop through markers
    if strcmpi(name{ii},'O0') || strcmpi(name{ii},'O1') %black marker
        printcircles(image, pb); %display black circles 
    end
    
    index = input(['Input the ID of marker ' name{ii} ' (if it is not visible in frame type "N"): '],'s'); %get user input
    
    if strcmpi('N', index) 
        error('MyComponent:WrongFrame','Error.\nNot all circles visible in this frame.');
    end
    
    index = str2double(index); %convert string into number
    
    %record result
    if strcmpi(name{ii},'O0') || strcmpi(name{ii},'O1') %black marker
        c(ii,:) = pb(index,:);
    else %white marker
        c(ii,:) = pw(index,:);
    end
    
end

end

