function [punish,add_time]=rotimepunish(N,R,solusion,D,EL,ET)

% preorder=[1 1 2 1 4 3 5];
preorder=[0 0 1 0 2 0 1 0 4 3 0 5];
preorder=[0 0 1 0 2 0 1 0 6 4 0 8];
tw=[3 5 7 9];%�洢��Ҫ����ʱ�䴰�Ĺ���
afterorder=[0 0 4 0 10 0 8 0 12];%��Ϊת��ǰ�ģ��������2+��2-���ŵ������
% de=ones(1,length(R));
% R=R-de;%1վ��װ��վ����ʱ�䴰���ƣ��������������1��������վ��-1
% n=n-1;
timewindow = numel(tw);
n = timewindow;
add=0;
priority=0;
TRAV=[20 20 20 20 20];%�����ǰ���ʱ�Ļ������˶�ʱ����ڿ�ʻʱ�����϶����ʱ���������1��2��ʻʱ��Ϊ6�����˲���ʱ��Ϊ26.��ʱ����Ϊ20.
timing=zeros(1,n);
punish=zeros(1,n);
waittime=zeros(1,n);
uptime=zeros(1,n);

RR=zeros(n,N+2);


for nn=1:timewindow     %Ϊ����ʱ�䴰���ҵ�ÿһ�������ڹ�λ��ͣ����ʱ�䣨���У�
tt = tw(nn);
R1=R;          %R1��Ϊ��ʱ����
station0=find(R1==tt);
station1=find(R1==afterorder(tt));
%between2n3=station3-station2;

%���ﻹҪ���ǣ�5��4֮ǰ�����⣡���5��4֮ǰ��˵������һ�����ڵ�5��λ�ò�unloading4�ϼӹ���Ĺ�����Ҳ���Ǵ�������4��ʼ���㵽�����ڵ�5֮ǰ��
if  station1< station0
    R2=[R1(:,station0:N),R1(:,1:(station0-1))];
    station1=station1+N-station0+1;
    station0=1;
    R1=R2;
end
% R1(R1==6)=1;
% R1(R1==7)=1;
index=1;        %���ɹ����ڹ�λ��ͣ�������е�����

RR(nn,1:station1-station0+1)=R1(station0 : station1);%��nn����λ��ͣ�����о���¼�������У��������ж��Ƿ�waittime����Ӱ��

T_45=ones(1,25);
if preorder(R1(1))~=tt
    T_45(index) = tt;  %��nn��ʼ
    index = index + 1;
end;

% R1 = ConvertToVRPSolution (1,R1);%ת��Ϊ2+��2-��

for i =station0 : station1-2
        if preorder(R1(i+1)) ==R1(i)          %����flow-shop���͡�����ֻ��ǰ����һ��˵����е���Ǵ������䵽��һ��λ��
        T_45(index) =R1(i+1);
        index = index + 1;
%         timing(nn)=timing(nn)+TRAV(R1(i+1));
%         timing(nn)=timing(nn)+ET(R1(i));
%         add=add+ET(R1(i));
        else
            if preorder(R1(i+1)) ~= 0
            T_45(index) = preorder(R1(i+1));    %����flow-shop���͡�����n��ǰ����ֹһ��˵����е�����ȿ��ص�n-1��λ���ٽ�n-1��λ�ϵĹ������˵�n��λ�Ͻ�����һ���ӹ���
            index = index + 1;
            T_45(index) =R1(i+1);
            index = index + 1;
    %         timing(nn)=timing(nn)+TRAV(R1(i+1));
            end
        end        
 
end
T_45(index) =nn;

%��5,6�����������ʱ��ֱ�ӽ�timing��Ϊ
if station1==station0+1
    timing(nn)=timing(nn)+ET(nn);
end



    a=find(T_45==tt);
    b=find(T_45==afterorder(tt));

T_45 = ConvertToVRPSolution (1,T_45);%ת��Ϊ2+��2-��
%�ڼ����������ʱ����6,7��Ϊ1
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
%         j=j+1; %����û���Ͼ�������
%         flag=0;
%     

    if flag~=1
        punish(1)=punish(1)+1;
    end
    
    end   
end

add_time=sum(B)+add;






% t=t+d/v; %����ʱ��
% cfe1=0;
% cfe2=0;
% if t<ET(B(j+1))
%     %Ӳʱ�䴰
%     if B(j+1)==nn|B(j+1)==n|B(j+1)==15 
%         t=TT(B(j+1))+ET(B(j+1)); %ж������ʱ��
%         cfe1=0;
%     else
%         %��ʱ�䴰
%         t=t+TT(B(j+1)); %ж������ʱ��
%         cfe1=CT(B(j+1))*abs(ET(B(j+1))-t); %������ʱ�䴰�絽�ͷ�
%     end
% elseif t>ELL(B(j+1))
%     t=t+TT(B(j+1)); %ж������ʱ��
%     cfe2=CL(B(j+1))*abs(t-ELL(B(j+1)));
% end
% cfe0=cfe1+cfe2;
