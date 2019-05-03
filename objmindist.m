function index = objmindist(oldc,newc,plane)
%OBJMINDIST determines which object in a array has the closest position to
%another object

%oldc -> (xyz)
%newc -> (circle, xyz)

s = size(newc);
nnewc = s(1); %number of new circles to be checked
d = zeros(nnewc,1); %array to store distances

%checks plane to determine what coordinates to use
if strcmp(plane,'xz')||strcmp(plane,'zx')
    a = 1; %x 
    b = 3; %z
elseif strcmp(plane, 'yz')||strcmp(plane,'zy')
    a = 2; %y
    b = 3; %z
else
    a = 1; %x
    b = 2; %y
end

%loop throw all the new objects
for ii = 1:nnewc
    p1 = [oldc(a),oldc(b)]; %point1
    p2 = [newc(ii,a), newc(ii,b)]; %point2
    d(ii) = getdist(p1, p2); %distance between two points
end

[m, index] = min(d); %find index of minimum distance
d
end

