%{
%DATA_PROCESSING.m
%KYLE INZUNZA 
%}

%% import data

%booleans if the marker was tracked
%origins top and side view
O0t = 0;
O0s = 0; 
O1t = 0;
O1s = 0;
%palm
P10 = 0;
P11 = 0; %guide
P12 = 0; %guide
P13 = 0; 
P20 = 0;
P21 = 0; %guide
P22 = 0; %guide
P23 = 0;
%dorsal
D10 = 0;
D11 = 0; %guide
D12 = 0; %guide
D13 = 0;
D20 = 0;
D21 = 0; %guide
D22 = 0; %guide
D23 = 0;


%import data
load Task2_wrist_trial2_side.mat

p = struct('snum', sum(d.markernum_side), 'tnum', sum(d.markernum_top)); %struct to hold position info

for k = 1:size(d.pside,1) %loop through side markers
    %enable booleans and record position
    if strcmpi(d.mside{k},'P10')
        P10 = 1;
        p.P10 = reshape(d.pside(k,:,:),[fnum,2]);
    elseif strcmpi(d.mside{k},'P11')
        P11 = 1;
        p.P11 = reshape(d.pside(k,:,:),[fnum,2]);
    elseif strcmpi(d.mside{k},'P12')
        P12 = 1;
        p.P12 = reshape(d.pside(k,:,:),[fnum,2]);
    elseif strcmpi(d.mside{k},'P13')
        P13 = 1;
        p.P13 = reshape(d.pside(k,:,:),[fnum,2]);
    elseif strcmpi(d.mside{k},'P20')
        P20 = 1;
        p.P20 = reshape(d.pside(k,:,:),[fnum,2]);
    elseif strcmpi(d.mside{k},'P21')
        P21 = 1;
        p.P21 = reshape(d.pside(k,:,:),[fnum,2]);
    elseif strcmpi(d.mside{k},'P22')
        P22 = 1;
        p.P22 = reshape(d.pside(k,:,:),[fnum,2]);
    elseif strcmpi(d.mside{k},'P23')
        P23 = 1;
        p.P23 = reshape(d.pside(k,:,:),[fnum,2]);
    elseif strcmpi(d.mside{k},'O0')
        O0s = 1;
        p.O0s = reshape(d.pside(k,:,:),[fnum,2]);
    elseif strcmpi(d.mside{k},'O1')
        O1s = 1;
        p.O1s = reshape(d.pside(k,:,:),[fnum,2]);
    else
        error('MyComponent:InvalidData','Error. \nUnexpected fields in imported data structure.');
    end
end

for k = 1:size(d.ptop,1) %loop through top markers
    %enable booleans and record position
    if strcmpi(d.mtop{k},'D10')
        D10 = 1;
        p.D10 = reshape(d.ptop(k,:,:),[fnum,2]);
    elseif strcmpi(d.mtop{k},'D11')
        D11 = 1;
        p.D11 = reshape(d.ptop(k,:,:),[fnum,2]);
    elseif strcmpi(d.mtop{k},'D12')
        D12 = 1;
        p.D12 = reshape(d.ptop(k,:,:),[fnum,2]);
    elseif strcmpi(d.mtop{k},'D13')
        D13 = 1;
        p.D13 = reshape(d.ptop(k,:,:),[fnum,2]);
    elseif strcmpi(d.mtop{k},'D20')
        D20 = 1;
        p.D20 = reshape(d.ptop(k,:,:),[fnum,2]);
    elseif strcmpi(d.mtop{k},'D21')
        D21 = 1;
        p.D21 = reshape(d.ptop(k,:,:),[fnum,2]);
    elseif strcmpi(d.mtop{k},'D22')
        D22 = 1;
        p.D22 = reshape(d.ptop(k,:,:),[fnum,2]);
    elseif strcmpi(d.mtop{k},'D23')
        D23 = 1;
        p.D23 = reshape(d.ptop(k,:,:),[fnum,2]);
    elseif strcmpi(d.mtop{k},'O0t')
        O0t = 1;
        p.O0t = reshape(d.ptop(k,:,:),[fnum,2]);
    elseif strcmpi(d.mtop{k},'O0s')
        O0s = 1;
        p.O0s = reshape(d.ptop(k,:,:),[fnum,2]);
    else
        error('MyComponent:InvalidData','Error. \nUnexpected fields in imported data structure.');
    end
end

%save booleans in array
side_marker_bool = [P10,P11,P12,P13,P20,P21,P22,P23];
top_marker_bool = [D10,D11,D12,D13,D20,D21,D22,D23];


%% reee
w_angle = zeros(1,fnum); %wrist angles
if D12 && D11 %if needed markers are being tracked
    for k = 1:fnum
        w_angle = wristangle(p.D11(k,:),p.D12(k,:)); %calculate wrist angle
    end
else
    error('MyComponent:MissingData','Error. \nD11 and D12 positions are needed to process data');
end

[~,id] = min(abs(w_angle)); %find frame with wrist angle closest to 0


if P21 && P22
    pxcon = pdist2(p.P21(id,:),p.P22(id,:))/truedist; %px per mm
elseif P11 && P12
    pxcon = pdist2(p.P11(id,:),p.P12(id,:))/truedist; %px per mm
else
    error('MyComponent:MissingData','Error. Not enough positions to process data');
end

spos = zeros(p.snum,fnum,3);
tpos = zeros(p.tnum,fnum,3);

for ii = 1:fnum %loop through frames
    k = 1;
    
    if isnan(d.pside(1,ii,1)) %if this frame is nan
        spos(:,ii,:) = nan*ones(size(spos(:,ii,:))); %write entire frame as nan
        continue; %skip to next iteration
    end
    
    %set origin
    if O0s
        origin = p.O0s;
    elseif O0t
        origin = p.O0t;
    end
    
    for jj = 1:size(side_marker_bool,2) %loop through all possible side markers
        if side_marker_bool(jj) % if marker is being tracked
            
            %save true world positions in mm
            spos(k,ii,1) = (d.pside(k,ii,1) - origin(1))/pxcon; %x
            spos(k,ii,2) = gettruedepth(w_angle(ii),origin,d.pside(k,ii,1) - origin(1),pxcon); %y
            spos(k,ii,3) = (d.pside(k,ii,2) - origin(2))/pxcon; %z
            
        end
    end
    
    for jj = 1:size(top_marker_bool,2) %loop through all possible top markers
        if top_marker_bool(jj)
            %save true world positions
        end
    end
end
    
    
    
    
    
    
    
    
    %loop through frames
    %   get wrist angle
    %   find true positions of markers
    %   find joint angles
    %   find velocitys of joint markers
    
    %put every position in reference to origin
    
    %save to file
    