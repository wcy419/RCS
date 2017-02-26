%交叉算法
%部分匹配交叉
function [a,b]=CrossOperation(a,b)
L=length(a);
if L<=7  %确定交叉宽度
    W=6;
elseif ((L/10)-floor(L/10))>=rand && L>10
    W=ceil(L/10)+6;
else
    W=floor(L/10)+6;
end
p=unidrnd(L-W+1);%随机选择交叉范围，从p到p+W
for i=1:W
    %交叉
    x=find(a==b(1,p+i-1));
    y=find(b==a(1,p+i-1));
    [a(1,p+i-1),b(1,p+i-1)]=exchange(a(1,p+i-1),b(1,p+i-1));
    [a(1,x(1)),b(1,y(1))]=exchange(a(1,x(1)),b(1,y(1)));   %*x(1),y(1)可直接写成x,y
end
