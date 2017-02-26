function [punish,add_time] = rotimepunish(N,R,solusion,D,EL,ET)
R = [6 12 15 8 1 3 14 16 1 11 2 5 4 7 10 13];
N = size(R,2);
tw = [3 5 7 11 13 15];%存储需要计算时间窗的工序（未转换前）
%%%%%%%%%%%this ET update should be noticed and improved.

afterorder = [0 0 2 0 4 0 6 0 0 0 10 0 12 0 14];%后序工位（用于转换前的解，避免出现2+、2-干扰的情况）
timewindow = numel(tw);  % 6
n = timewindow;
add = 0;
priority = 0;
timing = zeros(1,n);
punish = zeros(1,n);
waittime = zeros(1,n);  %各站需要的等待时间
uptime = zeros(1,n);
RR = zeros(n,N+2);

for nn = 1:timewindow     %为检测是否满足时间窗约束，找到每一个工件在各工位上停留的时间（序列）。
tt = tw(nn);
R1 = R;          %R1作为临时变量
station0 = find(R1==tt);  % 找到拿起动作（-）的位置
station1 = find(R1==afterorder(tt)); % 拿起动作对应的后序放下动作（+）的位置

%考虑后序工位在序列中在tt之前的问题 如果afterorder(tt)在tt之前，说明再下一个周期的afterorder(tt)的位置才unloading tt上加工完的工件。
if  station1 < station0
    R2 = [R1(:,station0:N),R1(:,1:(station0-1))];
    station1 = station1+N-station0+1;
    station0 = 1;
    R1 = R2;
end

RR(nn,1:station1-station0+1) = R1(station0 : station1);%将nn个工位的停留序列均记录在数组中，用于做判断是否被waittime加上影响
T_45 = RR(nn,:);
a = find(T_45 == tt);  % * 可改进？
b = find(T_45 == afterorder(tt));

T_45 = ConvertToVRPSolution (1,T_45);%转化为2+、2-解

line_num = 2;%两条线
operation_num = 4;%每条线三个工序，加上最后返回卸载工站。
for i = 1:line_num  %将5,9站变为1站，在ConvertToVRPSolution转化后的序列基础上
    unloading_station = (1 + i*operation_num);
    T_45(T_45 == unloading_station) = 1;
end
% 进一步将工站编号转换成1—5范围，便于搬运时间的计算
timesum = stationconvert_timesum (1,T_45);

for i = a(1) : b-1
    timing(nn) = timing(nn) + D(timesum(i), timesum(i+1));
end

if timing(nn) > EL(nn)
       punish(nn) = punish(nn) + 1;
else
    uptime(nn) = EL(nn) - timing(nn);
end
if timing(nn) < ET(tt)  %若2+到2-之间的搬运时间小于工站2上工件的加工时间，则需等待。
     waittime(nn) = ET(tt) - timing(nn);
end
end
% [B,ind]=sort(waittime,'descend');
[B,ind] = sort(waittime);%排序 并记录新序列B中对应的原序列位置（ind数组）用于一一对应
BB = B;
for nn = 1:n
    
    if B(nn) ~= 0
    j = 1;
    position_0 = find(RR(ind(nn),:) == 0);  % 找到非零等时间对应序列的末尾后一位（第一个为零的元素的位置），确定最后一个要查找的位置
    length_nn = position_0(1) - 2;%可以插入的位置数。这里可能是position_0(1) - 1（即在最后一个位置插入等待时间t，到达该站后不操作，等待t后操作），有待斟酌
%     priority = [];
    priority = zeros(1,length_nn);%看在哪个位置插入优先级高
    while RR(ind(nn),j+1)           
        p = 0;   
         for ii = 2:n %对RR（2:n,:）检查是否有重合区域，判断重合区域多少来决定在哪个位置加入等待时间（贪心策略）
            if waittime(ii) > 0 && ii ~= ind(nn)
            aim = RR(ind(nn),j);
            kk = find(RR(ii,:) == 0);
            L = ismember(aim,RR(ii,1:kk(1)-2));%查找ii站是否与当前站的路径有重合（不包括最后一个点重合），有重合则为1
%             priority(j) = priority(j) + L;
                if L ~= 0
                priority(j) = priority(j) + L;
                p = p + 1;
                B1(j,p) = ii;%把重的那几条路径记录在数组里，之后减去这几条路径对应的waittime
                end
            end
         end
        j = j + 1;
    end
    
    [~,ssort] = sort(priority,'descend');
    cp = ssort(1);
%     pp = 1; %注释掉
    for pp = 1:priority(cp)
        a = find(ind == B1(cp,pp));
        B(a) = B(a) - B(nn);
%         pp = pp + 1;  %这句语句无效，应删去
    end
    waittime(ind(nn)) = 0;
%     if flag ~= 1  %flag前面似乎没有提及？
%         punish(1) = punish(1) + 1;   %为何执行到此处会有图像框figure弹出？
%     end
    
    end   
end
sum_B = 0;
for b = 1 : nn
    if B(b) > 0 %只计算B数组中>0的等待时间，（小于0说明该序列在其他序列加入等待时间后有冗余等待时间，不计入等待时间累积中）
    sum_B = sum_B + B(b);
    end
end
% add_time=sum(B)+add; 
% one bug hasn't been fixed because element of B will be lower than 0
add_time = sum_B + add;%？add初始化为0后就没有改变过

%  feasible = isfeasible(R,N);%检测序列是否满足双爪的可行性约束
%  add_time = add_time + 100*feasible;%不可行（feasible=1）则加入惩罚项
end





