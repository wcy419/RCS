function farm=initpop(nind,n)
% nind 种群规模
% chrom随机染色体矩阵，行是染色体数，列为染色体长度
N = n; %& 两条线时加1
oneplus = [9 17
           16 24]; %变为1+的节点，即卸载站标记
%初始化
farm = zeros(nind,N);
for i=1:nind
             farm_t = randperm(N+2) + 1;   
             q1 = farm_t == oneplus(1,1); 
             farm_t(q1) = [];  %从2-24中去掉9和17
             q2 = farm_t == oneplus(1,2);
             farm_t(q2) = []; 
             farm(i,:) = farm_t;
end

