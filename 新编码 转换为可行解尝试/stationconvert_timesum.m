function solusion = stationconvert_timesum (n,R)
for j = 1 : n
    workpoint = numel(R(j,:));
        p = R(j,:) == 6;
        q = R(j,:) == 7;
        s = R(j,:) == 4;
        t = R(j,:) == 8;
        R(j,p) = 4;
        R(j,q) = 5;
        R(j,s) = 2;
        R(j,t) = 4;
    solusion(j,:)=R(j,:);
end
