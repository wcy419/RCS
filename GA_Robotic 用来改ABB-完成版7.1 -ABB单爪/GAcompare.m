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
sum=sum/iter;%���ƽ��Ŀ�꺯����С
% q=nn/iter;

% disp('�õ��������Ž�ĳɹ���');
% disp(q);
disp('���ƽ��Ŀ�꺯����С');
disp(sum);
min