function fit=fitness(D,chrom,ET,EL,n,nind)

N=n;

R=chrom;
% R(1,:)=[2 11 6 7 3 12 8 4 13 9 14 1 10 5];
% R(1,:)=[2 12 6 7 13 3 14 1 8 4 9 11 10 5];
R(1,:)=[5 4 2 6 3 7];
% R(1,:)=[2 6 4 7 3 5];
% R(1,:)=[7 4 6 2 3 5];
% R(1,:)=[2 4 7 5 6 3];
% R(1,:)=[5 6 3 4 2 7];
% R(1,:)=[6     4     3     5     2     7]; 
% R(1,:)=[3 7 5 2 6 4];
workpoint=N;
solusion = ones (nind, workpoint+8);
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
        if preorder(R(j,i)) ==R(j,i-1)          %由于flow-shop类型。后结点只比前结点大一，说明机械臂是带件运输到下一工位。
        solusion(j,index) =R(j,i);
        index = index + 1;
        else
        solusion(j,index) = preorder(R(j,i));    %由于flow-shop类型。后结点n比前结点大不止一，说明机械臂是先空载到n-1工位，再将n-1工位上的工件搬运到n工位上进行下一步加工。
        index = index + 1;
        solusion(j,index) =R(j,i);
        index = index + 1;
        end
%     end
%     if R(j,i) < R(j,i-1)
%         if R(j,i)==1
%             solusion(j,index) =R(j,i);
%             index = index + 1;
%         else
%         solusion(j,index) =R(j,i)-1;
%         index = index + 1;
%         solusion(j,index) =solusion(j,index-1) +1;
%         index = index + 1;
%         end
%     end
end
end
% solusion(solusion==14)=1;
solusion(solusion==6)=1;
solusion(solusion==7)=1;
numberofjourney = size(solusion,2)-1;
len=zeros(nind,1);%=totaldistance 总长度

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

[punish,add_time]=rotimepunish(n,R(j,:),solusion(j,:),D,EL,PTime);
r=sum(punish);
len(j)=len(j)+r*50+add_time;
%add time requirement from last point to first point
first_point=preorder(R(j,1));
last_point=R(j,end);
if last_point == 6|7
    last_point = 1;
end
len(j)=len(j)+D(first_point,last_point);

end
% 适应值计算
[nx,ny]=size(R);
for i=1:nx
% 初始化各个变量
%    fit(i)=len+k0*c0;
   fit(i)=len(i);
%    fitx(i)=1/(len(i)+eps);
end




