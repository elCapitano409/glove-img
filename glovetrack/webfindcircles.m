function c = webfindcircles(image)
%WEBFINDCIRCLES finds the circles in an image from the webcam and sorts it
%by y value

sen = .95; %sensitivity of circle find function;

tic; %start timer
%loop until valid
while true
    
    %if function has been running for an unreasonable amount of time(stuck in a loop)
    if toc > 5*60 || sen < .8
        error('MyComponent:watchDog','Error. \nCircle find function in endless loop.');
    end
    
    c = imfindcircles(image, [1 3], 'ObjectPolarity', 'bright','Sensitivity',sen);
    
    %validate number
    if size(c,1) > 6
        sen = sen - 0.05;
    elseif size(c,1) < 6
        error('MyComponent:blocked','Error. \nCord is blocked in this frame.');
    else
        break; %end loop
    end
end

c = sortrows(c,2); %sort circles by thier y value

end

