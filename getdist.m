function d = getdist(p1, p2)
%GETDIST outputs distance between two points

%pythagean theorm
d = sqrt((p1(1)-p2(1))^2 + (p1(2)-p2(2))^2);
end

