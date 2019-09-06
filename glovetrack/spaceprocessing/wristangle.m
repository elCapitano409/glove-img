function a = wristangle(g1,g2)
%WRISTANGLE.m outputs angle of wrist in radians, relative to bottom of frame, must use
%D11 and D12 as markers

g = [g2(1)-g1(1),g2(2)-g1(1)]; %guide vector
x = [1,0]; %unit vector
a = acos(dot(x,g)/(norm(x)*norm(g))); %angle between g and x

if g(1) < 0 %if x component of g is negative
    a = -a; %make angle negative
end

end

