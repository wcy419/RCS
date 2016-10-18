function fit=fitness(D,chrom,ET,EL,n,nind)

N=n;
R = ConvertToVRPSolution (n,chrom);
workpoint=N;
solusion = ones (nind, workpoint+12);
preorder=[1 1 2 1 4 3 5];


for j=1:nind
    if R(j,1)==1
        solusion(j,1) =1;
        index=2;
    else
        solusion(j,1) =preorder(R(j,1));
        solusion(j,2) =R(j,1);
        index=3;
    end
for i =2 : workpoint
%     if R(j,i) > R(j,i-1)
        if preorder(R(j,i)) ==R(j,i-1)          %是否前序节点
        solusion(j,index) =R(j,i);
        index = index + 1;
        else
        solusion(j,index) = preorder(R(j,i));    %非前序节点则要机械臂要先移动到前序节点
        index = index + 1;
        solusion(j,index) =R(j,i);
        index = index + 1;
        end
end
end

solusion(solusion==6)=1;
solusion(solusion==7)=1;
numberofjourney = size(solusion,2)-1;
len=zeros(nind,1);%机械臂移动路径总长度

PTime=ET;
% Sum_traveltime=30+31+22+22+22;
% Sum_traveltime=Sum_traveltime-10-11-2-2-2;


for j=1:nind
for i = 1 : numberofjourney
     len(j) = len(j)+  D(solusion(j,i), solusion(j,i+1));
end
R_real=R;
R_real(R_real==6)=1;
R_real(R_real==7)=1;
% len(j)=len(j)+D(R_real(j,6), preorder(R(j,1))); %完整的周期长度
% len(j)=len(j)+Sum_traveltime;
for i = 1 : N-1
%    t=R(j,i+1)-R(j,i);
   if preorder(R(j,i+1))==R(j,i)
       len(j)=len(j)+PTime(R(j,i));
   end
end

[punish,add_time]=rotimepunish(n,chrom(j,:),solusion(j,:),D,EL,PTime);
r=sum(punish);
len(j)=len(j)+r*50+add_time;
end
% 适应值计算
% [nx,ny]=size(R);
for i=1:nind
%    fit(i)=len+k0*c0;
   fit(i)=len(i);
%    fitx(i)=1/(len(i)+eps);
end




