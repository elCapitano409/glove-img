function mask = greymask(image,t)

   %al = [1400,2000];
   mask = image > t; %mask image due to brightness threshold
   mask = bwareaopen(mask,250); %get rid of holes

end

