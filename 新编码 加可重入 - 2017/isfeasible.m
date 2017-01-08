function feasible=isfeasible(chrom0,n)
%可行性约束看论文Scheduling dual gripper robotic cell: One-unit cycles
    line_num = 2;%两条线
    operation_num = 4;%每条线三个工序，加上最后返回卸载工站。
    for i = 1:line_num
        station1_line(i) = (1 + (i-1)*operation_num)*2+1;
    end
%chrom0 = [12     2    10     7     3     8     9     6     4     5];
%check 2-,3-,4-,5-

minus = [2, 4, 6, 10, 12, 14];
plus = [3, 5, 7, 11, 13, 15];
check = [1, 2, 4, 6, 10, 12, 14];%correlated to dual_feasible
dual_feasible = [0, 5, 0, 7, 0, 8, 0, 0, 0, 13, 0, 15, 0, 16];%2- to 3+, 3- to 6+, 4- to 5+, 5- to 7+.
feasible = 0;
num = size(minus,2);
chrom = chrom0;

re_plus = [3,11];%reentrant_plus means: 2+ and 6+
re_minus = [2,10];%reentrant_minus means: 2- and 6-
for i = 1:size(re_plus,2)
    first_point = find(chrom==re_plus(i));
    k_plus = find(chrom==re_minus(i));
    if k_plus < first_point
            chrom=[chrom(first_point:n),chrom(1:(first_point-1))];
            k_plus = n - first_point + k_plus + 1;
            first_point = 1;            
    end   
    if re_plus(i) == 3
        if ismember(6,chrom(first_point:k_plus)) || ismember(7,chrom(first_point:k_plus))
            feasible = 1;
        end
    end
    if re_plus(i) == 11
        if ismember(14,chrom(first_point:k_plus)) || ismember(15,chrom(first_point:k_plus))
            feasible = 1;
        end
    end
end
if feasible ~= 1
    for i = 1:num
        chrom = chrom0;
        first_point = find(chrom==minus(i));
        k_plus = find(chrom==dual_feasible(minus(i)));
        if k_plus < first_point
                chrom=[chrom(first_point:n),chrom(1:(first_point-1))];
                k_plus = n - first_point + k_plus + 1;
                first_point = 1;            
        end   
        for j = first_point+1 : k_plus      
           if ismember(chrom(j),check)
               if chrom(j) ~= 1
                       if ~ismember(dual_feasible(chrom(j)),chrom(j+1:k_plus)) %拾取n-后如果在有n+(chrom(j)+1)操作则不违反。
                            %disp(-1);
                            feasible = 1;
                       else
                           if chrom(j+1) ~= dual_feasible(chrom(j))
                               feasible = 1;
                           end
                       end
               else
                   if ~ismember(station1_line(1),chrom(j+1:k_plus))&&~ismember(station1_line(2),chrom(j+1:k_plus)) %拾取n-后如果在有n+(chrom(j)+1)操作则不违反。
                            %disp(-1);
                            feasible = 1;
                   end
               end
           end       
        end
    end
end
