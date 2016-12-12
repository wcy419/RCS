function fit=fitness(D,chrom,ET,EL,n,nind)
%�ⲿ���漰������Ĳ�����ο����ס�Hybrid algorithm based scheduling optimization in robotic
%cell with dual-gripper��

%�򻯰�ģ�͵�fitness������������ �����룩

%1->2->3->1(��5��ʾ), 1->4->5->1(��9��ʾ)
%nind����Ⱥ����
N=n;%N��Ⱦɫ�����г���
%chrom(1,:)= [5  14   16    7     3     10     12    15     11     13  6   8     4     2];
chrom(1,:)= [3+1i  8-1i   9+1i    4+1i     2+1i     6-1i     7-1i    8+1i     6+1i     7+1i  4-1i   5+1i     3-1i     2-1i];
for j = 1 : nind
    R_1minus(j,:) = add_1minus(chrom(j,:));
end
R = R_1minus;
%��˫צ�������е�ÿ��elementת��Ϊ��վ������[9 4 6 7 5 12 10 8 2 3]ת��Ϊ[5 3 4 4 3 7 6 5 2 2]
solusion = R;

plus = [2+1i 3+1i 4+1i 6+1i 7+1i 8+1i];%��������ǡ��������ʱ����������ȴ�ʱ�䣨��λ��
plus_after=[2-1i 3-1i 4-1i 6-1i 7-1i 8-1i]; %plus������ĺ�������
ET=[0 0 30 0 45 0 10 0 0 0 30 0 45 0 10];%��ʱ�䴰��

line_num = 2;%������
operation_num = 4;%ÿ�����������򣬼�����󷵻�ж�ع�վ��
for ii = 1:line_num
    unloading_station = (1 + ii*operation_num);
    solusion(real(solusion) == unloading_station)=1+i;
end
%�������߼�ģ����, 6,7�ֱ��ʾ�������߼ӹ���ɵĹ���������ж��վ��1վ���Ķ�����
numberofjourney = size(solusion,2)-1;
len=zeros(nind,1);%��е���ƶ�·���ܳ���
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
%���ĺ��� ����ý������Ƿ�����ʱ�䴰Լ���Լ�����������
r=sum(punish);
len(j)=len(j)+r*50+add_time;%�Բ�����ʱ�䴰Լ���Ľ⣬Ӧ���������һ���ȴ�ʱ��waittimeʹ������ʱ�䴰��
end
for ii=1:nind
   fit(ii)=len(ii);% ��Ӧֵ����
end




