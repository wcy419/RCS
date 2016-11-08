function fit=fitness(D,chrom,ET,EL,n,nind)
%�ⲿ���漰������Ĳ�����ο����ס�Hybrid algorithm based scheduling optimization in robotic
%cell with dual-gripper��
%�򻯰�ģ�͵�fitness������������ �޿����룩
%1->2->3->1(��6��ʾ), 1->4->5->1(��7��ʾ)

N=n;
% chrom(1,:)=[5     6     2     7    12     9     8     4     3    10];
% chrom(1,:)=[12     2    10     7     3     8     9     6     4     5];
chrom(1,:)=[5    10     3     6     8    12     7     9     4     2];
for j = 1 : n
    R_1minus(j,:) = add_1minus(chrom(j,:));
end
R = ConvertToVRPSolution (n,R_1minus);
%��˫צ�������е�ÿ��elementת��Ϊ��վ������[9 4 6 7 5 12 10 8 2 3]ת��Ϊ[5 3 4 4 3 7 6 5 2 2]
solusion = R;

plus = [3, 5, 7, 9];%��������ǡ��������ʱ����������ȴ�ʱ�䣨��λ��
ET=[0 0 30 0 45 0 30 0 45];

solusion(solusion==6)=1;
solusion(solusion==7)=1;%�������߼�ģ����, 6,7�ֱ��ʾ�������߼ӹ���ɵĹ���������ж��վ��1վ���Ķ�����
numberofjourney = size(solusion,2)-1;
len=zeros(nind,1);%��е���ƶ�·���ܳ���
PTime=ET;

for j=1:nind
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
for i=1:nind
   fit(i)=len(i);% ��Ӧֵ����
end




