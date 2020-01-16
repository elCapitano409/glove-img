function masked_image = rgbmask(rgbimage, c)
%RGBMASK masked image to isolate a certain colour

otherimages = {rgbimage.r,rgbimage.g,rgbimage.b};

t = 120; %threshold for colour masking


%validate colour selection
if strcmpi('r',c) || c == 1
    colour = 1;
    image = rgbimage.r;
elseif strcmpi('g',c) || c == 2
    colour = 2;
    image = rgbimage.g;
elseif strcmpi('b',c) || c == 3
    colour = 3;
    image = rgbimage.b;
else
    error('MyComponent:InvalidColor','Error. /nInvalid color selection.');
end

otherimages{colour} = {}; %delete image from array


mask = cell(1,3); %cell array to hold the masks

%mask due to brightness threshold
mask{1} = image > t;
mask{2} = otherimages{1} < t;
mask{3} = otherimages{2} < t;

masked_image = mask{1} & ~(~mask{2} | ~mask{3}); %exclude two of the channels from the image 

masked_image = bwareaopen(~bwareaopen(~masked_image,160),50); %fill black and white holes

end

