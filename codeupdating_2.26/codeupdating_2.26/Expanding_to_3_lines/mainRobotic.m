%%遗传算法Robotic cell
%R为最短路径,Rlength为路径长度
function [length_best,minlen]=mainRobotic
tic
%输入参数（可更改）
n=10;%n为种群个数
C=300;%C为预设停止代数
Pc=0.5;
Pm=0.6;%交叉概率Pc，变异概率Pm 

%robotic cell问题经典案例（3条线，1-2:6，1-3:10，2-5:8.5，即斜线为8.5） &
D = [0 6 10 6 10 6 10
6 0 6 6 8.5 6 8.5
10 6 0 8.5 6 8.5 6
6 6 8.5 0 6 6 8.5
10 8.5 6 6 0 8.5 6
6 6 8.5 6 8.5 0 6
10 8.5 6 8.5 6 6 0];%机械臂在工作站之间运行的时间矩阵

N=3*(1+2*3); %需求节点数 &
ET=[0 30 45 30 45 30 45]; % &
%加工时间 设置30，45为第一工序和第二工序的加工时间

EL=2000*ones(1,10);%2000在这里代表无限大，即无时间窗 &
% ELL=EL-ET;%时间窗大小

[R,minlen,length_ave,length_best]=GA_Robotic(D,C,n,N,Pc,Pm,EL,ET);%

toc
%绘图
% subplot(1,2,1); 
% plot(length_ave);
% title ('Plot of the average answer every generation');
% xlabel ('Number of generation');
% ylabel ('Object function value'); 
% subplot(1,2,2); 
figure(1)
plot(length_best);
title ('Plot of the best answer so far');
xlabel ('Number of generation');
ylabel ('Object function value'); 
end