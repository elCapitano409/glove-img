function truepx = findtpx(closest, imcenter)
%FINDAXISOFFSET finds the assumed reality px distance between circles

offset = zeros(4,2); %stores x and y distances from axis

%store abs difference in position
offset(1,:) = [abs(closest(1,1,1) - imcenter(1)), abs(closest(1,1,2)-imcenter(2))];
offset(2,:) = [abs(closest(1,2,1) - imcenter(1)), abs(closest(1,2,2)-imcenter(2))];
offset(3,:) = [abs(closest(2,1,1) - imcenter(1)), abs(closest(2,1,2)-imcenter(2))];
offset(4,:) = [abs(closest(2,2,1) - imcenter(1)), abs(closest(2,2,2)-imcenter(2))];

truepx = sum(sum(offset))/4; %assumed true pixel difference is average of distances between circles
end

