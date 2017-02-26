function feasible=isfeasible(chrom0,n)
%������Լ��������Scheduling dual gripper robotic cell: One-unit cycles
%ԭ��1.�������������𹤼�����һ���������Ƿ��£�
    line_num = 2;%������
    operation_num = 4;%ÿ�����������򣬼�����󷵻�ж�ع�վ��
    for i = 1:line_num
        station1_line(i) = (1 + (i-1)*operation_num)*2+1; %3,11
    end     %*�ɸĽ����뺯�������ͬ���ֺϲ�
%chrom0 = [12     2    10     7     3     8     9     6     4     5];
%check 2-,3-,4-,5-

minus = [2, 4, 6, 10, 12, 14];  %*���Ż�
plus = [3, 5, 7, 11, 13, 15];
check = [1, 2, 4, 6, 10, 12, 14];%correlated to dual_feasible
dual_feasible = [0, 5, 0, 7, 0, 8, 0, 0, 0, 13, 0, 15, 0, 16];%2- to 3+, 3- to 6+, 4- to 5+, 5- to 7+.��minus��Ӧ
feasible = 0;  %��ʼ�������Ա��Ϊ0�������У�
num = size(minus,2);
for i = 1:num  %��A�Ѿ�����һ������
    chrom = chrom0;
    num_minus = 0;
    first_point = find(chrom == minus(i));
    k_plus = find(chrom == dual_feasible(minus(i)));
    if k_plus < first_point
            chrom = [chrom(first_point:n),chrom(1:(first_point-1))]; %��ӹ�������һ��ѭ�����ɵ����ṹ
            k_plus = n - first_point + k_plus + 1;  %����(chrom==dual_feasible(minus(i)))��λ��
            first_point = 1;            
    end
    for j = first_point+1 : k_plus      
       if ismember(chrom(j),check)  %���j��������������minus��
           if chrom(j) ~= 1  %chrom��Ŀǰ��û��Ԫ��1��
                   if ~ismember(dual_feasible(chrom(j)),chrom(j+1:k_plus)) %ʰȡn-��������У�n+1��+��������Υ����
                        num_minus = num_minus + 1; %��             �������Ƿ��²���
                        %disp(-1);
                        feasible = 1;
                        break;
                   else
                       if chrom(j+1) ~= dual_feasible(chrom(j))  %����һ�������Ƿ�����צ�е���һ��������Υ��
                           feasible = 1;
                           break;
                       end
                   end
           else         
%                if ~ismember(station1_line(1),chrom(j+1:k_plus))&&~ismember(station1_line(2),chrom(j+1:k_plus)) %ʰȡn-���������n+(chrom(j)+1)������Υ����
%                         num_minus = num_minus + 1;
%                         %disp(-1);
%                         feasible = 1;
%                end
           end
       end       
    end
 
  %���������Լ����reentrant���ж�
  reentrant_ws = [6,7,14,15]; %�����벿�ֵĹ�վ���
  first_ws = [2,3,10,11];  % �״μӹ����ֵĹ�վ���
  if  feasible == 0
	% ��һ�������빤վ
    pos1_begin = find(chrom == reentrant_ws(2));
    pos1_end = find(chrom == reentrant_ws(1));
     if pos1_end < pos1_begin
            chrom = [chrom(pos1_begin:n),chrom(1:(pos1_begin-1))]; %��ӹ�������һ��ѭ�����ɵ����ṹ
            pos1_end = n - pos1_begin + pos1_end + 1; 
            pos1_begin = 1;   
%         [pos1_begin,pos1_end] = exchange(pos1_begin,pos1_end); 
     end
    chrom_re1 = chrom(:,pos1_begin:pos1_end);
    if (ismember(first_ws(1),chrom_re1)) || (ismember(first_ws(2),chrom_re1))
        feasible = 1;
     end
 end
  if  feasible == 0
  % �ڶ��������빤վ
    pos2_begin = find(chrom == reentrant_ws(4));
    pos2_end = find(chrom == reentrant_ws(3));
    if pos2_end < pos2_begin
            chrom = [chrom(pos2_begin:n),chrom(1:(pos2_begin-1))]; %��ӹ�������һ��ѭ�����ɵ����ṹ
            pos2_end = n - pos2_begin + pos2_end + 1; 
            pos2_begin = 1;      
%         [pos2_begin,pos2_end] = exchange(pos2_begin,pos2_end); 
    end
    chrom_re2 = chrom(:,pos2_begin:pos2_end);
    if (ismember(first_ws(3),chrom_re2)) || (ismember(first_ws(4),chrom_re2))
        feasible = 1;
     end
  end
 %�ٿ���2����2+֮���ǲ�����4-��4+��6-��6+֮���ǲ�����8-��8+
  if  feasible == 0
	% ��һ�������빤վ
    pos1_begins = find(chrom ==  first_ws(2));
    pos1_ends = find(chrom ==  first_ws(1));
     if pos1_ends < pos1_begins
            chrom = [chrom(pos1_begins:n),chrom(1:(pos1_begins-1))]; %��ӹ�������һ��ѭ�����ɵ����ṹ
            pos1_ends = n - pos1_begins + pos1_ends + 1; 
            pos1_begins = 1; 
%             [pos1_begins,pos1_ends] = exchange(pos1_begins,pos1_ends); 
     end
    chrom_re1s = chrom(:,pos1_begins:pos1_ends);
    if (ismember(reentrant_ws(1),chrom_re1s)) || (ismember(reentrant_ws(2),chrom_re1s))
        feasible = 1;
     end
  end
 if  feasible == 0
	% �ڶ��������빤վ
    pos2_begins = find(chrom ==  first_ws(4));
    pos2_ends = find(chrom ==  first_ws(3));
     if pos2_ends < pos2_begins
            chrom = [chrom(pos2_begins:n),chrom(1:(pos2_begins-1))]; %��ӹ�������һ��ѭ�����ɵ����ṹ
            pos2_ends = n - pos2_begins + pos2_ends + 1; 
            pos2_begins = 1;       
%         [pos2_begins,pos2_ends] = exchange(pos2_begins,pos2_ends);       
     end
    chrom_re2s = chrom(:,pos2_begins:pos2_ends);
    if (ismember(reentrant_ws(3),chrom_re2s)) || (ismember(reentrant_ws(4),chrom_re2s))
        feasible = 1;
    end 
 end
 %������Լ��-------------------
    if feasible == 1  %�������У�����������ѭ��
        break;
    end
end
