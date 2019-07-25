function t = getmaskthreshold(image,pol)
%GETMASKTHRESHOLD prompts user to get proper threshold to mask images

if strcmpi(pol,'dark') %if dark polarity
    t = 30; %start low
    polarity = 0;
elseif strcmpi(pol,'bright') %if light polarity
    t = 200; %start high
    polarity = 1;
else
    error("MyComponent:InvalidArguments", "Error. \nInvalid polarity argument.");
end

while true %loop until broken
    
    %mask image based on polarity
    if polarity == 0
        mask = image < t;
    else
        mask = image > t;
    end
    
    montage([mask*255,image]); %display mask and image
    
    text(100,100,num2str(t),'Color','g'); %display threshold on image
    
    usrinput = input('Input +/- and step size (or N to end loop): ','s');
    
    if strcmpi(usrinput,'N')%if user ends loop
        break;
    end
    
    sign = usrinput(1); %extract +/-
    step = str2double(usrinput(2:end)); %extract number of steps
    
    %parse input
    if strcmpi(sign,'+')
        t = t + step; %adjust threshold
    elseif strcmpi(sign,'-')
        t = t - step; %adjust threshold
    else
        disp("Invalid input, please input again.");
    end
    
    %fix invalid t values
    if t < 0  || isnan(t)
        t = 0;
    elseif t > 255
        t = 255;
    end
end

close all; %close image

end

