function grey = RGBstrut2grey(s)
%RGSSTRUT2GREY converts RGB strut to grey matrix

n = size(s,2); %number of frames       

grey = cell(1,n);

wb = waitbar(0,'Converting to grayscale...');

%loops through entire struct
for ii = 1:n
    %save grayscale image into element to cell array
    grey{ii} = rgb2gray(s(ii).cdata); %converts image to grayscale
    
    waitbar(ii/n); %update progress bar
end

close(wb); %close progress bar

end

