function [punish,add_time]=rotimepunish(n,R,solusion,D,EL,ET)

% de=ones(1,length(R));
% R=R-de;%1站是装载站，无时间窗限制，所以在这里忽略1，将所有站点-1
n=n-1;
add=0;
priority=0;
TRAV=[20 20 20 20 20];%当考虑搬运时的机器人运动时间大于空驶时，加上额外的时间量。如从1到2空驶时间为6，搬运操作时间为26.则时间量为20.
timing=zeros(1,n);
punish=zeros(1,n);
waittime=zeros(1,n);
uptime=zeros(1,n);
RR=zeros(n,n+2);
% afterorder=[1 3 6 5 7 ];%只有2-5这四个站点有时间窗
preorder=[1 1 2 1 4 3 5];
afterorder=[1 3 6 5 7];%1站是装载站，无时间窗限制，所以在这里忽略1，将所有站点-1.即
for nn=2:n     %为满足时间窗，找到每一个工件在工位上停留的时间（序列）
R1=R;          %R1作为临时变量
station0=find(R1==nn);
station1=find(R1==afterorder(nn));
%between2n3=station3-station2;

%这里还要考虑，5在4之前的问题！如果5在4之前，说明再下一个周期的5的位置才unloading4上加工完的工件。也就是从这周期4开始，算到下周期的5之前。
if  station1< station0
    R2=[R1(:,station0:n+1),R1(:,1:(station0-1))];
    station1=station1+6-station0+1;
    station0=1;
    R1=R2;
end
% R1(R1==6)=1;
% R1(R1==7)=1;
index=1;        %生成工件在工位上停留过程中的序列

RR(nn,1:station1-station0+1)=R1(station0 : station1);%将nn个工位的停留序列均记录在数组中，用于做判断是否被waittime加上影响

T_45=ones(1,25);
if preorder(R1(1))~=nn
    T_45(index) = nn;  %从nn开始
    index = index + 1;
end;

for i =station0 : station1-2
        if preorder(R1(i+1)) ==R1(i)          %由于flow-shop类型。后结点只比前结点大一，说明机械臂是带件运输到下一工位。
        T_45(index) =R1(i+1);
        index = index + 1;
%         timing(nn)=timing(nn)+TRAV(R1(i+1));
        timing(nn)=timing(nn)+ET(R1(i));
        add=add+ET(R1(i));
        else
        T_45(index) = preorder(R1(i+1));    %由于flow-shop类型。后结点n比前结点大不止一，说明机械臂是先空载到n-1工位，再将n-1工位上的工件搬运到n工位上进行下一步加工。
        index = index + 1;
        T_45(index) =R1(i+1);
        index = index + 1;
%         timing(nn)=timing(nn)+TRAV(R1(i+1));
        end        
 
end
T_45(index) =nn;

%当5,6这种特殊情况时，直接将timing设为
if station1==station0+1
    timing(nn)=timing(nn)+ET(nn);
end


if nn==1
    a=find(T_45==nn);
    b=length(T_45)-2;
else
    a=find(T_45==nn);
    b=a(2)-1;
end

%在计算空载运行时，将6,7置为1
T_45(T_45==6)=1;
T_45(T_45==7)=1;
for i = a(1) : b
    timing(nn)=timing(nn)+D(T_45(i), T_45(i+1));
%     timing(nn)=timing(nn)+waittime(T_45(i));
end

if timing(nn)>EL(nn)
       punish(nn)=punish(nn)+1;
else
    uptime(nn)=EL(nn)-timing(nn);
end
if timing(nn)<ET(nn)
%     punish(nn)=punish(nn)+1;
     waittime(nn)=ET(nn)-timing(nn);
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
%     for mm=1:length_nn
%     B1(mm,:)=B;
%     end
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
%     if L~=0&&ii~=ind(nn)
%                     if uptime(ii)<B(nn)
%                         fail=fail+1;
%                     end
%                     if waittime(ii)>0&&waittime(ii)>B(nn)
%                         search=find(ind==ii);
%                 
%                         BB(search)=BB(search)-B(nn);
%                     end            
%                 end
%         if fail==0
%             B=BB;
%             flag=1;
%             break;
%         end
%         j=j+1; %这条没用上就跳出了
%         flag=0;
%     

    if flag~=1
        punish(1)=punish(1)+1;
    end
    
    end   
end

add_time=sum(B)+add;






% t=t+d/v; %到达时间
% cfe1=0;
% cfe2=0;
% if t<ET(B(j+1))
%     %硬时间窗
%     if B(j+1)==nn|B(j+1)==n|B(j+1)==15 
%         t=TT(B(j+1))+ET(B(j+1)); %卸货结束时间
%         cfe1=0;
%     else
%         %软时间窗
%         t=t+TT(B(j+1)); %卸货结束时间
%         cfe1=CT(B(j+1))*abs(ET(B(j+1))-t); %计算软时间窗早到惩罚
%     end
% elseif t>ELL(B(j+1))
%     t=t+TT(B(j+1)); %卸货结束时间
%     cfe2=CL(B(j+1))*abs(t-ELL(B(j+1)));
% end
% cfe0=cfe1+cfe2;
