function g = gridc(c)
%GRIDC sorts grid of circles into a coresponding matrix

thres = 40; %max px deviation within the same column/row

[cnum,~] = size(c); %get number of circles

c = [c,(1:cnum)']; %add circle index as ID

% [~,cleft] = min(c(:,1)); %get index of most left circle
% [~,cbottom] = min(c(:,2)); %get index of lowest circle

%% sorting columns

cx = sortrows(c,1); %circles sorted from left to right

counter = 1; %counts the number of indices that have been written to the current column
icol = 1; %keeps track of which column is currently being filled

%loop through circles
for ii = 1:cnum
    %record first circle in the first column
    if ii == 1
        col(1,1) = cx(1,3);
    else
        %if point ii and ii-1 are close enough to be in the same column
        if abs(cx(ii,1) - cx(ii-1,1)) < thres
            col(icol,counter) = cx(ii,3); %add ID to column

        %the next point is in a new column
        else
            icol = icol+1;
            counter = 1; %reset counter
            col(icol,1) = cx(ii,3);
        end
        
    end
    
    counter = counter+1; %increase counter
            
end

%% sorting rows

cy = sortrows(c,2); %circles sorted from bottom to top

counter = 1; %counts the number of indices that have been written to the current row
irow = 1; %keeps track of which row is currently being filled

%loop through circles
for ii = 1:cnum
    %record first circle in the first row
    if ii == 1
        row(1,1) = cy(ii,3);
    else
        %if point ii and ii-1 are close enough to be in the same row
        if abs(cy(ii,2) - cy(ii-1,2)) < thres
            row(irow,counter) = cy(ii,3); %add index to column

        %the next point is in a new column
        else
            irow = irow+1;
            counter = 1; %reset counter
            row(irow,counter) = cy(ii,3);
        end
        
    end
    
    counter = counter+1; %increase counter        
end
%% combine rows and columns

[numrow,~] = size(row); %number of rows
[numcol,~] = size(col); %number of columns
g = zeros(numrow,numcol,2); %grid of circles

%loop through rows
for ii = 1:numrow
    %loop through columns
    for jj = 1:numcol
        
        com = intersect(row(ii,:),col(jj,:)); %find common elements 
        
        %if the only common element is 0 or no common elements (no circle)
        if isequal([1 1],size(com))||isequal([1 0],size(com))
            g(ii,jj,:) = [0 0]; %zeros as placeholder
            
        %if more than one common element (other than 0)
        elseif ~isequal([1 2],size(com))
            error('More than one common element.');
            
        else
            com = sort(com, 'descend'); %sort to ensure non zero element is in first index  
            g(ii,jj,:) = c(com(1),1:2); %set circle position
        end
        
    end
end