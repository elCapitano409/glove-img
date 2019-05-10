function refframe = findsyncframe(frames)
%FINDSYNCFRAME finds the frame in which the LED turns off
%   Detailed explanation goes here

s = size(frames);
nframe = s(2); %number of frames

x = 1:nframe; %vector to represent x axis
x = x'; %turn into column vector
inten = zeros(nframe, 1); %vector to store the intensity of each frame


intender = zeros(nframe, 1); %vector to store values of derivative

for ii = 1:nframe
    inten(ii) = mean2(frames(ii).gdata);%get average intensity
end

p = polyfit(x,inten,4) %fit intensity to polynomial
q = polyder(p) %find derivative

plot(x,inten)

for jj = 1:nframe
    intender(jj) = polyval(q,jj); %get instantaneous intensity change for each frame
end

[a, refframe] = max(abs(intender)); %find the frame with the highest abs rate of change

end

