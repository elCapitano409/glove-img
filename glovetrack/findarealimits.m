function l = findarealimits(a)
%FINDAREALIMITS finds the limits of pontential areas of blobs
  

%find min/max
a_min = min(a);
a_max = max(a);

l = [floor(a_min/1.30),ceil(a_max*1.50)];

end

