function fit=fitness(D,chrom,ET,EL,n,nind)
%这部分涉及到编码的部分请参考文献《Hybrid algorithm based scheduling optimization in robotic
%cell with dual-gripper》
%简化版模型的fitness函数（两条线 无可重入）
%1->2->3->1(用6表示), 1->4->5->1(用7表示)

N=n;
% chrom(1,:)=[5     6     2     7    12     9     8     4     3    10];
% chrom(1,:)=[12     2    10     7     3     8     9     6     4     5];
R = ConvertToVRPSolution (n,chrom);
%将双爪操作序列的每个element转换为工站数。如[9 4 6 7 5 12 10 8 2 3]转换为[5 3 4 4 3 7 6 5 2 2]
solusion = R;
preorder=[1 1 2 1 4 3 5];%前序工站,i.e.工站3的前序工站preorder(3)=2

solusion(solusion==6)=1;
solusion(solusion==7)=1;%在两条线简化模型中, 6,7分别表示将两条线加工完成的工件放置在卸载站（1站）的动作。
numberofjourney = size(solusion,2)-1;
len=zeros(nind,1);%机械臂移动路径总长度
PTime=ET;

for j=1:nind
for i = 1 : numberofjourney
     len(j) = len(j) +  D(solusion(j,i), solusion(j,i+1));
end
len(j) = len(j) + D(solusion(j,end), solusion(j,1)); %update; last point to first point 
for i = 1 : N-1
   if preorder(R(j,i+1))==R(j,i)
       len(j)=len(j)+PTime(R(j,i));
   end
end
[punish,add_time]=rotimepunish(n,chrom(j,:),solusion(j,:),D,EL,PTime);
%核心函数 计算该解序列是否满足时间窗约束以及可行性条件
r=sum(punish);
len(j)=len(j)+r*50+add_time;%对不满足时间窗约束的解，应当将其加上一定等待时间waittime使其满足时间窗。
end
for i=1:nind
   fit(i)=len(i);% 适应值计算
end




