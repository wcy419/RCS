function solusion = stationconvert_timesum (n,R)
for j = 1 : n
    workpoint = numel(R(j,:));
        p =real( R(j,:)) == 6;
        q = real(R(j,:)) == 7;
        s = real(R(j,:)) == 4;
        t = real(R(j,:)) == 8;
        R_imag=imag(R(j,p));  %ֻ�ı�ʵ���������鲿��Ϣ����
        R(j,p)= 4+R_imag*i;
        R_imag=imag(R(j,q)); 
        R(j,q) = 5+R_imag*i;
        R_imag=imag(R(j,s));
        R(j,s) = 2+R_imag*i;
        R_imag=imag(R(j,t));
        R(j,t) = 4+R_imag*i;
    solusion(j,:)=R(j,:);
end
