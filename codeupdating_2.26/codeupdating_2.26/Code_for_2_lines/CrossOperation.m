%�����㷨
%����ƥ�佻��
function [a,b]=CrossOperation(a,b)
L=length(a);
if L<=7  %ȷ��������
    W=6;
elseif ((L/10)-floor(L/10))>=rand && L>10
    W=ceil(L/10)+6;
else
    W=floor(L/10)+6;
end
p=unidrnd(L-W+1);%���ѡ�񽻲淶Χ����p��p+W
for i=1:W
    %����
    x=find(a==b(1,p+i-1));
    y=find(b==a(1,p+i-1));
    [a(1,p+i-1),b(1,p+i-1)]=exchange(a(1,p+i-1),b(1,p+i-1));
    [a(1,x(1)),b(1,y(1))]=exchange(a(1,x(1)),b(1,y(1)));   %*x(1),y(1)��ֱ��д��x,y
end
