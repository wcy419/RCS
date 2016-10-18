%%遗传算法Robotic cell
%R为最短路径,Rlength为路径长度
function [length_best,minlen]=mainRobotic
tic
%输入参数（可更改）
n=10;%n为种群个数
C=300;%C为预设停止代数
Pc=0;
Pm=0.5;%交叉概率Pc，变异概率Pm 

%robotic cell问题经典案例
D = [0 6 10 6 10 
6 0 6 6 8.5 
10 6 0 8.5 6 
6 6 8.5 0 6 
10 8.5 6 6 0 ];

N=size(D,2)+1; %需求节点数
ET=[0 30 80 30 80];
% ET=[120 150 90 120 90 30 60 60 45 130 120 90 30];

EL=[2000.0 2000 2000 2000 2000];
ELL=EL-ET;%时间窗

[R,minlen,length_ave,length_best]=GA_Robotic(D,C,n,N,Pc,Pm,EL,ET);%

%绘图


subplot(1,2,1); 
plot(length_ave);
title ('Plot of the average answer every generation');
xlabel ('Number of generation');
ylabel ('Object function value'); 
subplot(1,2,2); 
plot(length_best);
title ('Plot of the best answer so far');
xlabel ('Number of generation');
ylabel ('Object function value'); 
end