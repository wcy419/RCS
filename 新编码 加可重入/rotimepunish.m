function [punish,add_time]=rotimepunish(N,R,solusion,D,EL,ET)
N = size(R,2);
tw=[3 5 7 11 13 15];%存储需要计算时间窗的工序（未转换前）
%%%%%%%%%%%this ET update should be noticed and improved.

afterorder=[0 0 2 0 4 0 6 0 0 0 10 0 12 0 14];%后序工位（用于转换前的解，避免出现2+、2-干扰的情况）
timewindow = numel(tw);
n = timewindow;
add=0;
priority=0;
timing=zeros(1,n);
punish=zeros(1,n);
waittime=zeros(1,n);
uptime=zeros(1,n);
RR=zeros(n,N+2);


for nn=1:timewindow     %为检测是否满足时间窗约束，找到每一个工件在工位上停留的时间（序列）。
tt = tw(nn);
R1=R;          %R1作为临时变量
station0=find(R1==tt);
station1=find(R1==afterorder(tt));

%考虑后序工位在序列中在tt之前的问题 如果afterorder(tt)在tt之前，说明再下一个周期的afterorder(tt)的位置才unloading tt上加工完的工件。
if  station1< station0
    R2=[R1(:,station0:N),R1(:,1:(station0-1))];
    station1=station1+N-station0+1;
    station0=1;
    R1=R2;
end

RR(nn,1:station1-station0+1)=R1(station0 : station1);%将nn个工位的停留序列均记录在数组中，用于做判断是否被waittime加上影响
T_45=RR(nn,:);
a=find(T_45==tt);
b=find(T_45==afterorder(tt));

T_45 = ConvertToVRPSolution (1,T_45);%转化为2+、2-解

line_num = 2;%两条线
operation_num = 4;%每条线三个工序，加上最后返回卸载工站。
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
        for ii=2:n %对RR（2:n,:）检查是否有重合区域，判断重合区域多少来决定在哪个位置加入等待时间（贪心策略）
            if waittime(ii)>0&&ii~=ind(nn)
            aim=RR(ind(nn),j);
            kk=find(RR(ii,:)==0);
            L = ismember(aim,RR(ii,1:kk(1)-2));%查找ii站是否与当前站的路径有重合（不包括最后一个点重合），有重合则为1
            priority(j)=priority(j)+L;
                if L~=0
                p=p+1;
                B1(j,p)=ii;%把重的那几条路径记录在数组里，之后减去这几条路径对应的waittime
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

feasible = isfeasible(R,N);%检测序列是否满足双爪的可行性约束
add_time = add_time + 100*feasible;%不可行（feasible=1）则加入惩罚项





