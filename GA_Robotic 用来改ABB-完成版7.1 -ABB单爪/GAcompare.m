nn=0;
sum=0;
iter=3;
min=999;
for i=1:iter
[length_best,Rlength]=mainRobotic;
    sum=sum+Rlength;
    if Rlength<min
        min=Rlength;
%         x=find(length_best==519);
%         nn=nn+1;
%         sum=x(1)+sum;
    end
end
sum=sum/iter;%解的平均目标函数大小
% q=nn/iter;

% disp('得到近似最优解的成功率');
% disp(q);
disp('解的平均目标函数大小');
disp(sum);
min