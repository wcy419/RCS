function solusion = stationconvert_timesum (n,R)
for j = 1 : n
    workpoint = numel(R(j,:));
        p = R(j,:) == 6;
        q = R(j,:) == 7;
        R(j,p) = 4;
        R(j,q) = 5;        
    solusion(j,:)=R(j,:);
end
