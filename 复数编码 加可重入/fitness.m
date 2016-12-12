function fit=fitness(D,chrom,ET,EL,n,nind)
%这部分涉及到编码的部分请参考文献《Hybrid algorithm based scheduling optimization in robotic
%cell with dual-gripper》

%简化版模型的fitness函数（两条线 可重入）

%1->2->3->1(用5表示), 1->4->5->1(用9表示)
%nind是种群个数
N=n;%N是染色体序列长度
%chrom(1,:)= [5  14   16    7     3     10     12    15     11     13  6   8     4     2];
chrom(1,:)= [3+1i  8-1i   9+1i    4+1i     2+1i     6-1i     7-1i    8+1i     6+1i     7+1i  4-1i   5+1i     3-1i     2-1i];
for j = 1 : nind
    R_1minus(j,:) = add_1minus(chrom(j,:));
end
R = R_1minus;
%将双爪操作序列的每个element转换为工站数。如[9 4 6 7 5 12 10 8 2 3]转换为[5 3 4 4 3 7 6 5 2 2]
solusion = R;

plus = [2+1i 3+1i 4+1i 6+1i 7+1i 8+1i];%当后序动作恰好在正后方时，用来加入等待时间（工位）
plus_after=[2-1i 3-1i 4-1i 6-1i 7-1i 8-1i]; %plus各工序的后续工序
ET=[0 0 30 0 45 0 10 0 0 0 30 0 45 0 10];%（时间窗）

line_num = 2;%两条线
operation_num = 4;%每条线三个工序，加上最后返回卸载工站。
for ii = 1:line_num
    unloading_station = (1 + ii*operation_num);
    solusion(real(solusion) == unloading_station)=1+i;
end
%在两条线简化模型中, 6,7分别表示将两条线加工完成的工件放置在卸载站（1站）的动作。
numberofjourney = size(solusion,2)-1;
len=zeros(nind,1);%机械臂移动路径总长度
PTime=ET;

solusion = stationconvert_timesum (nind,solusion);
for j=1:nind
for ii = 1 : numberofjourney
     len(j) = len(j) +  D(real(solusion(j,ii)), real(solusion(j,ii+1)));
end
len(j) = len(j) + D(real(solusion(j,end)),real(solusion(j,1))); %update; last point to first point 
for ii = 1 : size(plus,2)
   position = find(chrom(j,:) == plus(ii));
   if position == N
       position = 0;
   end
   if chrom(j,position+1) == plus_after(ii);
       len(j)=len(j)+PTime((real(plus(ii)))*2-1);
   end
end
[punish,add_time]=rotimepunish(n,R_1minus(j,:),solusion(j,:),D,EL,PTime);
%核心函数 计算该解序列是否满足时间窗约束以及可行性条件
r=sum(punish);
len(j)=len(j)+r*50+add_time;%对不满足时间窗约束的解，应当将其加上一定等待时间waittime使其满足时间窗。
end
for ii=1:nind
   fit(ii)=len(ii);% 适应值计算
end




