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
             q=find(farm(i,:)==11);
             farm(i,q)=12;
%              b=6; %������� ��14��ж�أ����뵽1��װ�أ�ǰ
%              q=find(farm(i,:)==1); %�����λ��
%              aa(i,q)=b; %������
%              aa(i,1:q-1)=farm(i,1:q-1); %ǰ�治��
%              aa(i,q+1:N+1)=farm(i,q:N); %�����������һλ
%              farm(i,1:N+1)=aa(i,1:N+1);
end

