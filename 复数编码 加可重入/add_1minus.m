function [ R ] = add_1minus( R )
    line_num = 2;%������
    operation_num = 4;%ÿ�����������򣬼�����󷵻�ж�ع�վ��

    station1_line = [2+1i 6+1i];

    len = size(R,2);
    for ii = 1:line_num
    p = find(R==station1_line(ii));
    if p>1
        R1=[R(1:p-1),(1-1i),R(p:len)];
    else
        R1=[(1-1i),R(1:len)];
    end
    R = R1;
    len = len + 1; 
    end

end

