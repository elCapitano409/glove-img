function c = idcircle1(prevc,image,rad,sen,pol)
%IDCIRCLE1 identifies the same marker as prevc in image

if strcmp(pol,'dark') %if looking for black circles
    sen = sen + 0.02; 
    

image = overlaycirclemask(image,prevc); %mask everything except radii around previous circle

c = imfindcircles(image, rad, 'ObjectPolarity',pol,'Sensitivity',sen); %search for circle on masked image


if size(c,1) > 1 %if more than one circle is found
    dist = pdist2(prevc,c); %vector of distances from circles c to circle cprev
    [~,id] = min(dist); %get index of minimum distance
    
    c = reshape(c(id,:),1,2); %set that as the only circle
   
elseif size(c,1) < 1 %if no circles are found
    error("MyComponent:NoCirclesFound", "Error. \nNo circles were found in masked image."); %throw error
end
end

