function [punish,add_time]=rotimepunish(N,R,solusion,D,EL,ET)
N = size(R,2);
tw=[3 5 7 11 13 15];%�洢��Ҫ����ʱ�䴰�Ĺ���δת��ǰ��
%%%%%%%%%%%this ET update should be noticed and improved.

afterorder=[0 0 2 0 4 0 6 0 0 0 10 0 12 0 14];%����λ������ת��ǰ�Ľ⣬�������2+��2-���ŵ������
timewindow = numel(tw);
n = timewindow;
add=0;
priority=0;
timing=zeros(1,n);
punish=zeros(1,n);
waittime=zeros(1,n);
uptime=zeros(1,n);
RR=zeros(n,N+2);


for nn=1:timewindow     %Ϊ����Ƿ�����ʱ�䴰Լ�����ҵ�ÿһ�������ڹ�λ��ͣ����ʱ�䣨���У���
tt = tw(nn);
R1=R;          %R1��Ϊ��ʱ����
station0=find(R1==tt);
station1=find(R1==afterorder(tt));

%���Ǻ���λ����������tt֮ǰ������ ���afterorder(tt)��tt֮ǰ��˵������һ�����ڵ�afterorder(tt)��λ�ò�unloading tt�ϼӹ���Ĺ�����
if  station1< station0
    R2=[R1(:,station0:N),R1(:,1:(station0-1))];
    station1=station1+N-station0+1;
    station0=1;
    R1=R2;
end

RR(nn,1:station1-station0+1)=R1(station0 : station1);%��nn����λ��ͣ�����о���¼�������У��������ж��Ƿ�waittime����Ӱ��
T_45=RR(nn,:);
a=find(T_45==tt);
b=find(T_45==afterorder(tt));

T_45 = ConvertToVRPSolution (1,T_45);%ת��Ϊ2+��2-��

line_num = 2;%������
operation_num = 4;%ÿ�����������򣬼�����󷵻�ж�ع�վ��
for i = 1:line_num
    unloading_station = (1 + i*operation_num);
    T_45(T_45 == unloading_station)=1;
end

timesum = stationconvert_timesum (1,T_45);

for i = a(1) : b-1
    timing(nn)=timing(nn)+D(timesum(i), timesum(i+1));
end

if timing(nn)>EL(nn)
       punish(nn)=punish(nn)+1;
else
    uptime(nn)=EL(nn)-timing(nn);
end
if timing(nn)<ET(tt)
     waittime(nn)=ET(tt)-timing(nn);
end
end
% [B,ind]=sort(waittime,'descend');
[B,ind]=sort(waittime);
BB=B;
for nn=1:n
    
    if B(nn)~=0
    j=1;
    position_0=find(RR(ind(nn),:)==0);
    length_nn=position_0(1)-2;
    priority=[];
    priority=zeros(1,length_nn);
    while RR(ind(nn),j+1)
%             fail=0;            
        p=0;   
        for ii=2:n %��RR��2:n,:������Ƿ����غ������ж��غ�����������������ĸ�λ�ü���ȴ�ʱ�䣨̰�Ĳ��ԣ�
            if waittime(ii)>0&&ii~=ind(nn)
            aim=RR(ind(nn),j);
            kk=find(RR(ii,:)==0);
            L = ismember(aim,RR(ii,1:kk(1)-2));%����iiվ�Ƿ��뵱ǰվ��·�����غϣ����������һ�����غϣ������غ���Ϊ1
            priority(j)=priority(j)+L;
                if L~=0
                p=p+1;
                B1(j,p)=ii;%���ص��Ǽ���·����¼�������֮���ȥ�⼸��·����Ӧ��waittime
                end
            end
        end
        j=j+1;
    end
    
    [~,ssort]=sort(priority,'descend');
    cp=ssort(1);
    pp=1;
    for pp=1:priority(cp)
        a=find(ind==B1(cp,pp));
        B(a)=B(a)-B(nn);
        pp=pp+1;
    end
    waittime(ind(nn))=0;
    if flag~=1
        punish(1)=punish(1)+1;
    end
    
    end   
end
sum_B = 0;
for b=1:nn
    if B(b) > 0
    sum_B = sum_B+B(b);
    end
end
% add_time=sum(B)+add; 
% one bug hasn't been fixed because element of B will be lower than 0
add_time=sum_B+add;

feasible = isfeasible(R,N);%��������Ƿ�����˫צ�Ŀ�����Լ��
add_time = add_time + 100*feasible;%�����У�feasible=1�������ͷ���





