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

for ii=1:nind
             farm(ii,1:N)=randperm(N)+1;  
             q=find(farm(ii,:)==9);
             farm(ii,q)=16;
             for j=1:N
               if (farm(ii,j)~=8 && farm(ii,j)~=16 )
                   if (rem(farm(ii,j),2)==0)
                       farm(ii,j)=((farm(ii,j)+2)/2)-1i;
                   else
                        farm(ii,j)=((farm(ii,j)+3)/2-1)+1i;
                   end
               else
                  if(farm(ii,j)==8)  farm(ii,j)=5+1i;
                  else farm(ii,j)=9+1i;
                  end
               end
             end
end

