%%�Ŵ��㷨Robotic cell
%RΪ���·��,RlengthΪ·������
function [length_best,minlen]=mainRobotic
tic
%����������ɸ��ģ�
n=10;%nΪ��Ⱥ����
C=300;%CΪԤ��ֹͣ����
Pc=0;
Pm=0.5;%�������Pc���������Pm 

%robotic cell���⾭�䰸��
D = [0 6 10 6 10 
6 0 6 6 8.5 
10 6 0 8.5 6 
6 6 8.5 0 6 
10 8.5 6 6 0 ];

N=size(D,2)+1; %����ڵ���
ET=[0 30 80 30 80];
% ET=[120 150 90 120 90 30 60 60 45 130 120 90 30];

EL=[2000.0 2000 2000 2000 2000];
ELL=EL-ET;%ʱ�䴰

[R,minlen,length_ave,length_best]=GA_Robotic(D,C,n,N,Pc,Pm,EL,ET);%

%��ͼ


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