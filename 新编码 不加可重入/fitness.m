function fit=fitness(D,chrom,ET,EL,N,n)
%�ⲿ���漰������Ĳ�����ο����ס�Hybrid algorithm based scheduling optimization in robotic
%cell with dual-gripper��
%�򻯰�ģ�͵�fitness������������ �޿����룩
%1->2->3->1(��5��ʾ), 1->4->5->1(��9��ʾ)

% chrom(1,:)=[5    8     3     10     12    16     11     13     4     2];
for j = 1 : n
    R_1minus(j,:) = add_1minus(chrom(j,:));
end
R = ConvertToVRPSolution (n,R_1minus);
%��˫צ�������е�ÿ��elementת��Ϊ��վ������[9 4 6 7 5 12 10 8 2 3]ת��Ϊ[5 3 4 4 3 7 6 5 2 2]
solusion = R;

plus = [3 5 11 13];%��������ǡ��������ʱ����������ȴ�ʱ�䣨��λ��
ET1 = [0 0 ET(2) 0 ET(3) 0 0 0 0 0 ET(2) 0 ET(3)];%��ʱ�䴰��
ET = ET1;
line_num = 2;%������
operation_num = 4;%ÿ�����������򣬼�����󷵻�ж�ع�վ��
for i = 1:line_num
    unloading_station = (1 + i*operation_num);
    solusion(solusion == unloading_station)=1;
end
%�������߼�ģ����, 6,7�ֱ��ʾ�������߼ӹ���ɵĹ���������ж��վ��1վ���Ķ�����
numberofjourney = size(solusion,2)-1;
len=zeros(n,1);%��е���ƶ�·���ܳ���
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
%���ĺ��� ����ý������Ƿ�����ʱ�䴰Լ���Լ�����������
r=sum(punish);
len(j)=len(j)+r*50+add_time;%�Բ�����ʱ�䴰Լ���Ľ⣬Ӧ���������һ���ȴ�ʱ��waittimeʹ������ʱ�䴰��
end
for i=1:n
   fit(i)=len(i);% ��Ӧֵ����
end




