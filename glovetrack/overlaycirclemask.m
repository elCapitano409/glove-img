function image = overlaycirclemask(image,c)
%OVERLAYCIRCLEMAS overlays a mask over images to cover everything other
%than a certain radius around tracking markers
[h,w] = size(image); %get image dimensions

mask = zeros(h,w); % blank mask

r = 50; %radius of area
cnum = size(c,1); %number of circles

% %generate square mask of circle
% circmatrix = ones(r*2);

% %loop through rows
% for ii = 1:r*2
%     %loop through columns
%     for jj = 1:r*2
%         %if outside circle radius
%         if sqrt((ii-r)^2 + (jj-r)^2) > r
%             circmatrix(ii,jj) = 0; %make area black
%         end
%     end
% end

%loop through circles
for ii = 1:cnum
    center = round(c(ii,:)); %get center of circle
        
    x = [center(1)-r+1,center(1)+r]; %x indices
    y = [center(2)-r+1,center(2)+r]; %y indices

%     %indices of circle matrix to be called
%     xm = [1,100];
%     ym = [1,100];
    
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
%   mask(y(1):y(2),x(1):x(2)) = circmatrix(ym(1):ym(2),xm(1):xm(2)); %add partial circle to matrix
    
    mask(y(1):y(2),x(1):x(2)) = 1; %mask specific area

end

mask = uint8(mask); %convert mask to 8 bit unsigned integer

image(~mask) = 0; %place mask over image

toc;

end
