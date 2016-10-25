function solusion = ConvertToVRPSolution (n,R)
for j = 1 : n
    workpoint = numel(R(j,:));

    for i = 1 : workpoint
        if rem(R(j,i),2)==0
        R(j,i)=(R(j,i)+2)/2;
        else
        R(j,i)=(R(j,i)+3)/2-1;
        end
    end
    solusion(j,:)=R(j,:);
end