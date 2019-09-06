function p = getparams(cam)
%GETPARAMS returns parameters to undistort image

imnum = 10; %number of calibration images

images = cell(imnum,1);

if strcmpi(cam,'ion')
    for ii = 1:imnum
        images{ii} = ['C:\Users\Kyle Inzunza\Documents\University\NSERC\glove-img\glovetrack\' cam '_calibration_images\image' num2str(ii) '.jpg'];
    end
else 
    error("MyComponent:CameraInvalid","Error. \nThe camera specified is invalid.");
end

% if size(images,1) == 1 %if row matrix
%     images = images'; %turn into col matrix
% end
% 
% if size(images,1) < 10 %need at least 10 images
%    error('MyComponent:InsufficentImages',"Error. \n"); 
% end

[imagePoints,boardSize] = detectCheckerboardPoints(images); %detect calibration pattern

squareSize = 30; %distance between corners in mm

worldPoints = generateCheckerboardPoints(boardSize,squareSize); %find world coordinates of checkerboard

I = imread(images{1});
imageSize = [size(I,1),size(I,2)];
p = estimateCameraParameters(imagePoints,worldPoints,'ImageSize',imageSize); %generate parameters

end

