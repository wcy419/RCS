function farm=initpop(nind,n)
% nind ��Ⱥ��ģ
% chrom���Ⱦɫ���������Ⱦɫ��������ΪȾɫ�峤��
N = n; %& ������ʱ��1
oneplus = [9 17
           16 24]; %��Ϊ1+�Ľڵ㣬��ж��վ���
%��ʼ��
farm = zeros(nind,N);
for i=1:nind
             farm_t = randperm(N+2) + 1;   
             q1 = farm_t == oneplus(1,1); 
             farm_t(q1) = [];  %��2-24��ȥ��9��17
             q2 = farm_t == oneplus(1,2);
             farm_t(q2) = []; 
             farm(i,:) = farm_t;
end

