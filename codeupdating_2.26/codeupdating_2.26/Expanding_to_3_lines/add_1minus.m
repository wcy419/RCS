function [ R ] = add_1minus( R )
    line_num = 3;%两条线
    operation_num = 4;%每条线三个工序，加上最后返回卸载工站。
    for i = 1:line_num   %在3,11前加上1
        station1_line(i) = (1 + (i-1)*operation_num)*2+1;
    end
    lenc = size(R,2);
    for i = 1:line_num
    p = find(R==station1_line(i));
    if p>1
        R1=[R(1:p-1),1,R(p:lenc)];
    else
        R1=[1,R(1:lenc)];
    end
    R = R1;
    lenc = lenc + 1; 
    end

end

