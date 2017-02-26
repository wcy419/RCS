function [fit,chrom] = fitness(D,chrom,ET,EL,n,nind)
%这部分涉及到编码的部分请参考文献《Hybrid algorithm based scheduling optimization in robotic
%cell with dual-gripper》

%简化版模型的fitness函数（两条线 可重入）

%1->2->3->1(用5表示), 1->4->5->1(用9表示)
%nind是种群个数
N = n;%N是染色体序列长度
feasible_arry = zeros(nind,1);  %初始化可行性标记存储数组
fit = 200*ones(1,nind);  % 初始化适应度值
% chrom(1,:)=[5    8     3     10     12    16     11     13     4     2];
% chrom(1,:)= [5  14   16    7     3     10     12    15     11     13  6   8     4     2];
%chrom(1,:)= [6     4     7     2     5    12    15    10    13    14    16     3     8    11];

for j = 1 : nind
    sizeR = size(chrom(j,:),2); %可优化？
    feasible = isfeasible(chrom(j,:),sizeR);
        if feasible == 1 %不可行解?
            chrom(j,:) = Rreconstruct(chrom(j,:));
        end
    R_1minus(j,:) = add_1minus(chrom(j,:));
    feasible = isfeasible(R_1minus(j,:),sizeR+2);
    feasible_arry(j,1) =  feasible;
end
R = ConvertToVRPSolution (nind,R_1minus);
%将双爪操作序列的每个element转换为工站数。如[9 4 6 7 5 12 10 8 2 3]转换为[5 3 4 4 3 7 6 5 2 2]
solusion = R;
plus = [3 5 7 11 13 15];%当后序动作恰好在正后方时，用来加入等待时间（工位）
ET=[0 0 30 0 45 0 10 0 0 0 30 0 45 0 10];%（时间窗）改进

line_num = 2;%两条线
operation_num = 4;%每条线三个工序，加上最后返回卸载工站。
for i = 1:line_num    %5和9是卸载站，赋值为1站
    unloading_station = (1 + i*operation_num);
    solusion(solusion == unloading_station)=1;
end
%在两条线简化模型中, 6,7分别表示将两条线加工完成的工件放置在卸载站（1站）的动作。
numberofjourney = size(solusion,2)-1;
len=zeros(nind,1); %机械臂移动路径总长度
PTime=ET;
% q=0;
solusion = stationconvert_timesum (nind,solusion);
for j=1:nind
 for i = 1 : numberofjourney
     len(j) = len(j) +  D(solusion(j,i), solusion(j,i+1));
 end
len(j) = len(j) + D(solusion(j,end), solusion(j,1)); %update; last point to first point 
for i = 1 : size(plus,2)
   position = find(chrom(j,:) == plus(i));  %当后序正好在上一个动作的正后方时，加入等待时间。
   if position == N   %以此将序列视为循环式
       position = 0;
   end
   if chrom(j,position+1) == plus(i)-1;
       len(j)=len(j)+PTime(plus(i));
   end
end
if feasible_arry(j,1) == 0
    [punish,add_time]=rotimepunish(n,R_1minus(j,:),solusion(j,:),D,EL,PTime);

%核心函数 计算该解序列是否满足时间窗约束以及可行性条件
    r=sum(punish);
    len(j)=len(j)+r*50+add_time;%对不满足时间窗约束的解，应当将其加上一定等待时间waittime使其满足时间窗。
    fit(j)=len(j);% 适应值计算
end 
end




