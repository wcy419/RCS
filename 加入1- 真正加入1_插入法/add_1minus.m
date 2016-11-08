function [ R2 ] = add_1minus( R )
    p = find(R==3);
    len = size(R,2);
    if p>1
        R1=[R(1:p-1),1,R(p:len)];
    else
        R1=[1,R(1:len)];
    end
    q = find(R1==7);
    len = size(R1,2);    
    if q>1
        R2=[R1(1:q-1),1,R1(q:len)];
    else
        R2=[1,R1(1:len)];
    end
end

