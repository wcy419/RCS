function farm=initpop(nind,n)
% nind 种群规模
% chrom随机染色体矩阵，行是染色体数，列为染色体长度
% N 染色体长度;
% N=n-1; 
% farm=zeros(n,N+1);%用于存储种群
% aa=zeros(n,N+1);
N=n;
% farm=zeros(n,N);%用于存储种群
% aa=zeros(n,N);

for i=1:nind
             farm(i,1:N)=randperm(N)+1;  
             q=find(farm(i,:)==9);
             farm(i,q)=16;

end

