function fit=fitness(D,chrom,ET,EL,n,nind)
%这部分涉及到编码的部分请参考文献《Hybrid algorithm based scheduling optimization in robotic
%cell with dual-gripper》

%简化版模型的fitness函数（两条线 可重入）

%1->2->3->1(用5表示), 1->4->5->1(用9表示)
%nind是种群个数
N=n;%N是染色体序列长度
% chrom(1,:)=[5    8     3     10     12    16     11     13     4     2];
% chrom(1,:)= [5  14   16    7     3     10     12    15     11     13  6   8     4     2];
% chrom(1,:)= [4 2 11 16 5 10 12 14 15 8 7 6 13 3];
% chrom(1,:)= [5     6     7    14    15    10     2     8    16    11     3     4    12    13];
chrom(1,:)= [6    14    16    10   13   2     8     11     3     4    7    12    15   5];
len=zeros(nind,1);%机械臂移动路径总长度
R_1minus = zeros(nind,16);
for j = 1 : nind
    R_1minus(j,:) = add_1minus(chrom(j,:));
end

plus = [3 5 7 11 13 15];%当后序动作恰好在正后方时，用来加入等待时间（工位）
ET=[0 0 30 0 45 0 10 0 0 0 30 0 45 0 10];%（时间窗）
PTime=ET;
punishes = zeros(nind,1);
for j=1:nind
[punish,add_time,chrom1]=rotimepunish(n,R_1minus(j,:),D,EL,PTime);
r = sum(punish);
punishes(j) = r*50+add_time;
R_1minus(j,:) = chrom1;
end
%核心函数 计算该解序列是否满足时间窗约束以及可行性条件

solusion = ConvertToVRPSolution (nind,R_1minus);
%将双爪操作序列的每个element转换为工站数。如[9 4 6 7 5 12 10 8 2 3]转换为[5 3 4 4 3 7 6 5 2 2]

line_num = 2;%两条线
operation_num = 4;%每条线三个工序，加上最后返回卸载工站。
for i = 1:line_num
    unloading_station = (1 + i*operation_num);
    solusion(solusion == unloading_station)=1;
end
%在两条线简化模型中, 6,7分别表示将两条线加工完成的工件放置在卸载站（1站）的动作。
solusion = stationconvert_timesum (nind,solusion);
numberofjourney = size(solusion,2)-1;
len_R = size(R_1minus,2);
for j=1:nind
for i = 1 : numberofjourney
     len(j) = len(j) +  D(solusion(j,i), solusion(j,i+1));
end
len(j) = len(j) + D(solusion(j,end), solusion(j,1)); %update; last point to first point 
for i = 1 : size(plus,2)
   position = find(R_1minus(j,:) == plus(i));
   if position == len_R
       position = 0;
   end
   if R_1minus(j,position+1) == plus(i)-1;%当后序动作恰好在正后方时，用来加入工位等待时间
       len(j)=len(j)+PTime(plus(i));
   end
end
len(j)=len(j)+punishes(j);%对不满足时间窗约束的解，应当将其加上一定等待时间waittime使其满足时间窗。
end
for i=1:nind
   fit(i)=len(i);% 适应值计算
end




