function fit=fitness(D,chrom,ET,EL,N,n)
%这部分涉及到编码的部分请参考文献《Hybrid algorithm based scheduling optimization in robotic
%cell with dual-gripper》
%简化版模型的fitness函数（两条线 无可重入）
%1->2->3->1(用5表示), 1->4->5->1(用9表示)

% chrom(1,:)=[5    8     3     10     12    16     11     13     4     2];
for j = 1 : n
    R_1minus(j,:) = add_1minus(chrom(j,:));
end
R = ConvertToVRPSolution (n,R_1minus);
%将双爪操作序列的每个element转换为工站数。如[9 4 6 7 5 12 10 8 2 3]转换为[5 3 4 4 3 7 6 5 2 2]
solusion = R;

plus = [3 5 11 13];%当后序动作恰好在正后方时，用来加入等待时间（工位）
ET1 = [0 0 ET(2) 0 ET(3) 0 0 0 0 0 ET(2) 0 ET(3)];%（时间窗）
ET = ET1;
line_num = 2;%两条线
operation_num = 4;%每条线三个工序，加上最后返回卸载工站。
for i = 1:line_num
    unloading_station = (1 + i*operation_num);
    solusion(solusion == unloading_station)=1;
end
%在两条线简化模型中, 6,7分别表示将两条线加工完成的工件放置在卸载站（1站）的动作。
numberofjourney = size(solusion,2)-1;
len=zeros(n,1);%机械臂移动路径总长度
PTime=ET;

solusion = stationconvert_timesum (n,solusion);
for j=1:n
for i = 1 : numberofjourney
     len(j) = len(j) +  D(solusion(j,i), solusion(j,i+1));
end
len(j) = len(j) + D(solusion(j,end), solusion(j,1)); %update; last point to first point 
for i = 1 : size(plus,2)
   position = find(chrom(j,:) == plus(i));
   if position == N
       position = 0;
   end
   if chrom(j,position+1) == plus(i)-1;
       len(j)=len(j)+PTime(plus(i));
   end
end
[punish,add_time]=rotimepunish(n,R_1minus(j,:),solusion(j,:),D,EL,PTime);
%核心函数 计算该解序列是否满足时间窗约束以及可行性条件
r=sum(punish);
len(j)=len(j)+r*50+add_time;%对不满足时间窗约束的解，应当将其加上一定等待时间waittime使其满足时间窗。
end
for i=1:n
   fit(i)=len(i);% 适应值计算
end




