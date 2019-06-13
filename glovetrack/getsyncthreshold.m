function t = getsyncthreshold(image)
%GETSYNCTHRESHOLD returns threshold to set mask to find the sync frame
%local minumum within brightest region of histogram considered the
%threshold

h = imhist(image); %creates grayscale histogram from image
y = h(230:end); %extract the end of the graph
x = (230:256)'; %generate x axis for extracted values


[maxh,maxhid] = max(y); %find maximum brightness value in range

local_min = 0.15*maxh; %assumed value of local min

counter = 1; %counts amount of times loop was run

%loops until broken
while true
    if y(maxhid - counter) <=local_min
        t = x(maxhid - counter); %set threshold as x value of local min
        break;
    end
    counter = counter+1; %increase counter by one
end
end

