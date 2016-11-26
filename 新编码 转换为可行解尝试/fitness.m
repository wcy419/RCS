function fit=fitness(D,chrom,ET,EL,n,nind)
%�ⲿ���漰������Ĳ�����ο����ס�Hybrid algorithm based scheduling optimization in robotic
%cell with dual-gripper��

%�򻯰�ģ�͵�fitness������������ �����룩

%1->2->3->1(��5��ʾ), 1->4->5->1(��9��ʾ)
%nind����Ⱥ����
N=n;%N��Ⱦɫ�����г���
% chrom(1,:)=[5    8     3     10     12    16     11     13     4     2];
% chrom(1,:)= [5  14   16    7     3     10     12    15     11     13  6   8     4     2];
% chrom(1,:)= [4 2 11 16 5 10 12 14 15 8 7 6 13 3];
% chrom(1,:)= [5     6     7    14    15    10     2     8    16    11     3     4    12    13];
chrom(1,:)= [6    14    16    10   13   2     8     11     3     4    7    12    15   5];
len=zeros(nind,1);%��е���ƶ�·���ܳ���
R_1minus = zeros(nind,16);
for j = 1 : nind
    R_1minus(j,:) = add_1minus(chrom(j,:));
end

plus = [3 5 7 11 13 15];%��������ǡ��������ʱ����������ȴ�ʱ�䣨��λ��
ET=[0 0 30 0 45 0 10 0 0 0 30 0 45 0 10];%��ʱ�䴰��
PTime=ET;
punishes = zeros(nind,1);
for j=1:nind
[punish,add_time,chrom1]=rotimepunish(n,R_1minus(j,:),D,EL,PTime);
r = sum(punish);
punishes(j) = r*50+add_time;
R_1minus(j,:) = chrom1;
end
%���ĺ��� ����ý������Ƿ�����ʱ�䴰Լ���Լ�����������

solusion = ConvertToVRPSolution (nind,R_1minus);
%��˫צ�������е�ÿ��elementת��Ϊ��վ������[9 4 6 7 5 12 10 8 2 3]ת��Ϊ[5 3 4 4 3 7 6 5 2 2]

line_num = 2;%������
operation_num = 4;%ÿ�����������򣬼�����󷵻�ж�ع�վ��
for i = 1:line_num
    unloading_station = (1 + i*operation_num);
    solusion(solusion == unloading_station)=1;
end
%�������߼�ģ����, 6,7�ֱ��ʾ�������߼ӹ���ɵĹ���������ж��վ��1վ���Ķ�����
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
   if R_1minus(j,position+1) == plus(i)-1;%��������ǡ��������ʱ���������빤λ�ȴ�ʱ��
       len(j)=len(j)+PTime(plus(i));
   end
end
len(j)=len(j)+punishes(j);%�Բ�����ʱ�䴰Լ���Ľ⣬Ӧ���������һ���ȴ�ʱ��waittimeʹ������ʱ�䴰��
end
for i=1:nind
   fit(i)=len(i);% ��Ӧֵ����
end




