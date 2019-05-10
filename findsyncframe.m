function n = findsyncframe(frames)
%FINDSYNCFRAME finds the frame in which the LED turns off
%   assuming the light turns OFF

s = size(frames);
nframe = s(2); %number of frames

cage = round(findsynccage(frames{1}));


inten = zeros(nframe, 1); %vector to store the intensity of each frame


for ii = 1:nframe
    tempim = frames{ii}; %temporary holder
    inten(ii) = mean2(tempim(cage(2,1):cage(2,2),cage(1,1):cage(1,2)));%get average intensity of area in cage
end

intender = gradient(inten); %get vector of derivatives for intensity with respect to frame num

[a, n] = max(abs(intender)); %find the frame with the highest abs rate of change

%check if result is correct;
c1 = inten(n) - inten(n-1); %change in intensity from frame n-1 to n
c2 = inten(n+1) - inten(n); %chage in intensity from frame n to n+1

%if the biggest decrease is from n to n+1 instead of n-1 to n
%the first frame the led is off in is n+1
if c1 < c2
    n = n+1;
end
 
end

