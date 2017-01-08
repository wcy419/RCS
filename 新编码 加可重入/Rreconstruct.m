function Rnew=Rreconstruct(chrom0)
n = size(chrom0,2);
    line_num = 2;%两条线
    operation_num = 4;%每条线三个工序，加上最后返回卸载工站。
    for i = 1:line_num
        station1_line(i) = (1 + (i-1)*operation_num)*2+1;
    end


minus = [2, 4, 6, 10, 12, 14];
plus = [3, 5, 7, 11, 13, 15];
check = [1, 2, 4, 6, 10, 12, 14];%correlated to dual_feasible
dual_feasible = [0, 5, 0, 7, 0, 8, 0, 0, 0, 13, 0, 15, 0, 16];%2- to 3+, 3- to 6+, 4- to 5+, 5- to 7+.
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
                        [chrom(j),chrom(k_plus)]=exchange(chrom(j),chrom(k_plus));
                        chrom0 = chrom;%交换当前chrom(j)与minus(i)位置
                        j = k_plus;
                   else
                       if chrom(j+1) ~= dual_feasible(chrom(j))
                           index_c = find(chrom==dual_feasible(chrom(j)));
                          [chrom(j+1),chrom(index_c)]=exchange(chrom(j+1),chrom(index_c));%交换当前chrom(j)与minus(i)位置
                          chrom0 = chrom;
                       end
                   end
           else
               if ~ismember(station1_line(1),chrom(j+1:k_plus))&&~ismember(station1_line(2),chrom(j+1:k_plus)) %拾取n-后如果在有n+(chrom(j)+1)操作则不违反。
                        num_minus = num_minus + 1;
                        %disp(-1);
                        feasible = 1;
               end
           end
       end
       if j == k_plus
            break;
       end
    end
end
Rnew = chrom;
