function num = countvis(boolean)
%COUNTVIS returns the number of visible circles in the frame

s = size(boolean);
num = 0;
for ii = 1:s(1)
    if boolean(ii) == 1
        num = num + 1;
    end
end
end

