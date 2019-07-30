function l = findarealimits(a)
%FINDAREALIMITS finds the limits of pontential areas of blobs
  

%find min/max
a_min = min(a);
a_max = max(a);

l = [a_min/1.2,a_max*1.2];

end

