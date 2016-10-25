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
             q=find(farm(i,:)==11);
             farm(i,q)=12;
%              b=6; %插入的数 将14（卸载）插入到1（装载）前
%              q=find(farm(i,:)==1); %插入的位置
%              aa(i,q)=b; %插入数
%              aa(i,1:q-1)=farm(i,1:q-1); %前面不变
%              aa(i,q+1:N+1)=farm(i,q:N); %后面的数后移一位
%              farm(i,1:N+1)=aa(i,1:N+1);
end

