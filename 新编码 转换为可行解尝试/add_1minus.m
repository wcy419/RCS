function [ R ] = add_1minus( R )
    line_num = 2;%������
    operation_num = 4;%ÿ�����������򣬼�����󷵻�ж�ع�վ��
    for i = 1:line_num
        station1_line(i) = (1 + (i-1)*operation_num)*2+1;
    end
    len = size(R,2);
    for i = 1:line_num
    p = find(R==station1_line(i));
    if p>1
        R1=[R(1:p-1),1,R(p:len)];
    else
        R1=[1,R(1:len)];
    end
    R = R1;
    len = len + 1; 
    end

end

