function farm=initpop(nind,n)
% nind ��Ⱥ��ģ
% chrom���Ⱦɫ���������Ⱦɫ��������ΪȾɫ�峤��
% N Ⱦɫ�峤��;
% N=n-1; 
% farm=zeros(n,N+1);%���ڴ洢��Ⱥ
% aa=zeros(n,N+1);
N=n;
% farm=zeros(n,N);%���ڴ洢��Ⱥ
% aa=zeros(n,N);

for i=1:nind
             farm(i,1:N)=randperm(N)+1;  
             q=find(farm(i,:)==9);
             farm(i,q)=16;

end

