function dnew = fixabs(d,l)
%FIXABS fixes problems where data has been applied with absolute function

n = size(l,2);
dnew = d;
%if not an even number
if ~mod(n,2)
    n = n - 1;
end

%loop for every other value
for ii = 2:2:n
    %make values negative
    dnew(l(ii-1):l(ii)) = (-1)*d(l(ii-1):l(ii));
end

end

