function grey = RGBstrut2grey(s)
%RGSSTRUT2GREY converts RGB strut to grey matrix

a = size(s);
n = a(2); %number of frames       

grey = cell(1,n);

%loops through entire struct
for ii = 1:n
    %save grayscale image into element to cell array
    grey{ii} = rgb2gray(s(ii).cdata); %converts image to grayscale
end
end

