%%�Ŵ��㷨Robotic cell
%RΪ���·��,RlengthΪ·������
function [length_best,minlen]=mainRobotic
tic
%����������ɸ��ģ�
n=15;%nΪ��Ⱥ����
C=200;%CΪԤ��ֹͣ����
Pc=0.5;
Pm=0.2;%�������Pc���������Pm 

%robotic cell���⾭�䰸��
D = [0 6 10 6 10 
6 0 6 6 8.5 
10 6 0 8.5 6 
6 6 8.5 0 6 
10 8.5 6 6 0 ];%��е���ڹ���վ֮�����е�ʱ�����

N=size(D,2)*2; %����ڵ���
ET=[0 30 45 30 45];
%�ӹ�ʱ�� ����30��~Ϊ��һ����͵ڶ�����ļӹ�ʱ��

EL=[2000 2000 2000 2000 2000];%2000������������޴󣬼���ʱ�䴰
% ELL=EL-ET;%ʱ�䴰��С

[R,minlen,length_ave,length_best]=GA_Robotic(D,C,n,N,Pc,Pm,EL,ET);%

%��ͼ


% subplot(1,2,1); 
% plot(length_ave);
% title ('Plot of the average answer every generation');
% xlabel ('Number of generation');
% ylabel ('Object function value'); 
subplot(1,1,1); 
plot(length_best);
title ('Plot of the best answer so far');
xlabel ('Number of generation');
ylabel ('Object function value'); 
end