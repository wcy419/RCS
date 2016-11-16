function feasible=isfeasible(chrom0,n)
%可行性约束看论文Scheduling dual gripper robotic cell: One-unit cycles

%chrom0 = [12     2    10     7     3     8     9     6     4     5];
%chrom0 = [12     2    10   3    7     8     9     6     4     5];
% chrom0 = [9 2 1 3 4 10 5 6 1 7 8 12];
%check 2-,3-,4-,5-
minus = [2, 4, 6, 8];
plus = [3, 5, 7 , 9];
check = [1, 2, 4, 6, 8];%correlated to dual_feasible
dual_feasible = [0, 5, 0, 10, 0, 9, 0, 12];%2- to 3+, 3- to 6+, 4- to 5+, 5- to 7+.
feasible = 0;
num = size(minus,2);
for i = 1:num
    chrom = chrom0;
    num_minus = 0;
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
                        num_minus = num_minus + 1;
                        %disp(-1);
                        feasible = 1;
                   else
                       if chrom(j+1) ~= dual_feasible(chrom(j))
                           feasible = 1;
                       end
                   end
           else
               if ~ismember(3,chrom(j+1:k_plus))&&~ismember(7,chrom(j+1:k_plus)) %拾取n-后如果在有n+(chrom(j)+1)操作则不违反。
                        num_minus = num_minus + 1;
                        %disp(-1);
                        feasible = 1;
               end
           end
       end       
    end
end
