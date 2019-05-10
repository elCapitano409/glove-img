function grn = RGB2G(cs)
%RGB2G extracts green cell array from RGB strut

%CURRENTLY NOT USED

a = size(cs);
n = a(2); %number of frames       

s = size(cs(1).cdata);

grn = zeros(n,size(s(1),s(2)));

%loops through entire struct
for ii = 1:n
    %loop through x axis
    for xx = 1:s(1)
        %loop through y axis
        for yy = 1:s(2)
            grn(ii,xx,yy) = cs(ii).cdata(xx,yy,2);
        end
    end

end
end

