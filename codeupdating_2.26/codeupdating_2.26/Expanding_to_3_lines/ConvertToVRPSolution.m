function solusion = ConvertToVRPSolution (n,R)
%将原初始化的序列（2~24）转化成带有体现loading（+）、unloading(-)操作的序列
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