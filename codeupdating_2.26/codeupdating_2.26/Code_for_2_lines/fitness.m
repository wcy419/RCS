function [fit,chrom] = fitness(D,chrom,ET,EL,n,nind)
%�ⲿ���漰������Ĳ�����ο����ס�Hybrid algorithm based scheduling optimization in robotic
%cell with dual-gripper��

%�򻯰�ģ�͵�fitness������������ �����룩

%1->2->3->1(��5��ʾ), 1->4->5->1(��9��ʾ)
%nind����Ⱥ����
N = n;%N��Ⱦɫ�����г���
feasible_arry = zeros(nind,1);  %��ʼ�������Ա�Ǵ洢����
fit = 200*ones(1,nind);  % ��ʼ����Ӧ��ֵ
% chrom(1,:)=[5    8     3     10     12    16     11     13     4     2];
% chrom(1,:)= [5  14   16    7     3     10     12    15     11     13  6   8     4     2];
%chrom(1,:)= [6     4     7     2     5    12    15    10    13    14    16     3     8    11];

for j = 1 : nind
    sizeR = size(chrom(j,:),2); %���Ż���
    feasible = isfeasible(chrom(j,:),sizeR);
        if feasible == 1 %�����н�?
            chrom(j,:) = Rreconstruct(chrom(j,:));
        end
    R_1minus(j,:) = add_1minus(chrom(j,:));
    feasible = isfeasible(R_1minus(j,:),sizeR+2);
    feasible_arry(j,1) =  feasible;
end
R = ConvertToVRPSolution (nind,R_1minus);
%��˫צ�������е�ÿ��elementת��Ϊ��վ������[9 4 6 7 5 12 10 8 2 3]ת��Ϊ[5 3 4 4 3 7 6 5 2 2]
solusion = R;
plus = [3 5 7 11 13 15];%��������ǡ��������ʱ����������ȴ�ʱ�䣨��λ��
ET=[0 0 30 0 45 0 10 0 0 0 30 0 45 0 10];%��ʱ�䴰���Ľ�

line_num = 2;%������
operation_num = 4;%ÿ�����������򣬼�����󷵻�ж�ع�վ��
for i = 1:line_num    %5��9��ж��վ����ֵΪ1վ
    unloading_station = (1 + i*operation_num);
    solusion(solusion == unloading_station)=1;
end
%�������߼�ģ����, 6,7�ֱ��ʾ�������߼ӹ���ɵĹ���������ж��վ��1վ���Ķ�����
numberofjourney = size(solusion,2)-1;
len=zeros(nind,1); %��е���ƶ�·���ܳ���
PTime=ET;
% q=0;
solusion = stationconvert_timesum (nind,solusion);
for j=1:nind
 for i = 1 : numberofjourney
     len(j) = len(j) +  D(solusion(j,i), solusion(j,i+1));
 end
len(j) = len(j) + D(solusion(j,end), solusion(j,1)); %update; last point to first point 
for i = 1 : size(plus,2)
   position = find(chrom(j,:) == plus(i));  %��������������һ������������ʱ������ȴ�ʱ�䡣
   if position == N   %�Դ˽�������Ϊѭ��ʽ
       position = 0;
   end
   if chrom(j,position+1) == plus(i)-1;
       len(j)=len(j)+PTime(plus(i));
   end
end
if feasible_arry(j,1) == 0
    [punish,add_time]=rotimepunish(n,R_1minus(j,:),solusion(j,:),D,EL,PTime);

%���ĺ��� ����ý������Ƿ�����ʱ�䴰Լ���Լ�����������
    r=sum(punish);
    len(j)=len(j)+r*50+add_time;%�Բ�����ʱ�䴰Լ���Ľ⣬Ӧ���������һ���ȴ�ʱ��waittimeʹ������ʱ�䴰��
    fit(j)=len(j);% ��Ӧֵ����
end 
end




