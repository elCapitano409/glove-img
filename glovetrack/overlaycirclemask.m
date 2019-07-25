function image = overlaycirclemask(image,c)
%OVERLAYCIRCLEMAS overlays a mask over images to cover everything other
%than a certain radius around tracking markers
[h,w] = size(image); %get image dimensions

mask = zeros(h,w); % blank mask


r = 35; %radius of area
cnum = size(c,1); %number of circles
c = reshape(c,cnum,2); %change array from 3d to 2d

%loop through circles
for ii = 1:cnum
    center = round(c(ii,:)); %get center of circle
        
    x = [center(1)-r+1,center(1)+r]; %x indices
    y = [center(2)-r+1,center(2)+r]; %y indices

    %adjusts indices to avoid out of bounds
    if y(1) < 1
        y(1) = 1;
%         ym(1) = abs(center(2)-r-1);
    end
    if y(2) > h
        y(2) = h;
%         ym(2) = center(2)+r - h;
    end
    if x(1) < 1
        x(1) = 1;
%         xm(1) = abs(center(1)-r-1);
    end
    if x(2) > w
        x(2) = w;
%         xm(2) = center(1)+r - w;
    end  
    try
    mask(y(1):y(2),x(1):x(2)) = 1; %mask specific area
    catch ME
        rethrow(ME);
    end

end

mask = uint8(mask); %convert mask to 8 bit unsigned integer

image(~mask) = 0; %place mask over image


end

