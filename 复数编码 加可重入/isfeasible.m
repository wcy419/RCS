function feasible=isfeasible(chrom0,n)
%������Լ��������Scheduling dual gripper robotic cell: One-unit cycles
    line_num = 2;%������
    operation_num = 4;%ÿ�����������򣬼�����󷵻�ж�ع�վ��
%     for ii = 1:line_num
%         station1_line(ii) = (1 + (ii-1)*operation_num)*2+1;
%     end
station1_line=[2+1i 6+1i];
%chrom0 = [12     2    10     7     3     8     9     6     4     5];
%check 2-,3-,4-,5-

minus = [2-1i, 3-1i, 4-1i, 6-1i, 7-1i, 8-1i];
plus = [2+1i, 3+1i, 4+1i, 6+1i, 7+1i, 8+1i];
check = [1-1i, 2-1i, 3-1i, 4-1i, 6-1i, 7-1i, 8-1i];%correlated to dual_feasible
dual_feasible = [3+1i, 4+1i, 5+1i, 7+1i, 8+1i, 9+1i];%2- to 3+, 3- to 6+, 4- to 5+, 5- to 7+. 5,9������Ҫ�仯
feasible = 0;
num = size(minus,2);
for ii = 1:num
    chrom = chrom0;
    num_minus = 0;
    first_point = find(chrom==minus(ii));
    k_plus = find(chrom==dual_feasible(ii));
    if k_plus < first_point
            chrom=[chrom(first_point:n),chrom(1:(first_point-1))];
            k_plus = n - first_point + k_plus + 1;
            first_point = 1;            
    end
    for j = first_point+1 : k_plus      
       if ismember(chrom(j),check)
           if chrom(j) ~= 1-1i
                   if ~ismember(dual_feasible(ii),chrom(j+1:k_plus)) %ʰȡn-���������n+(chrom(j)+1)������Υ����
                        num_minus = num_minus + 1;
                        %disp(-1);
                        feasible = 1;
                   else
                       if chrom(j+1) ~= chrom(j) + 1 + 2i %�޸�update ����ע�⣬����dual_feasible(ii)
                           feasible = 1;
                       end
                   end
           else
               if ~ismember(station1_line(1),chrom(j+1:k_plus))&&~ismember(station1_line(2),chrom(j+1:k_plus)) %ʰȡn-���������n+(chrom(j)+1)������Υ����
                        num_minus = num_minus + 1;
                        %disp(-1);
                        feasible = 1;
               end
           end
       end       
    end
end
