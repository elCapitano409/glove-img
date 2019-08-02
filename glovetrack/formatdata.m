function f = formatdata(name, data)
%FORMATDATA formats marker name and position to a savable format

f = {};

n = size(name,1); %number of markers
frame_num = size(data,2); %number of frames 

name = name'; %change from column array to row array

for ii = 1:n %loop through all markers
    %cat data together
    temp_name = [strcat(name{ii},"-x"),strcat(name{ii},"-y")];
    temp_data = [num2cell(reshape(data(ii,:,1),frame_num,1)),num2cell(reshape(data(ii,:,2),frame_num,1))];
    temp = [temp_name;temp_data];
    f = [f,temp];
end

