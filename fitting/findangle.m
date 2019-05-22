function theta = findangle(a,b)
%FINDANGLE finds angle between two vectors

theta = acos(dot(a,b)/(norm(a)*norm(b)));

end

