function feasible=isfeasible(chrom0,n)
%可行性约束看论文Scheduling dual gripper robotic cell: One-unit cycles
%原则：1.当连续两次拿起工件后，下一动作必须是放下；
    line_num = 2;%两条线
    operation_num = 4;%每条线三个工序，加上最后返回卸载工站。
    for i = 1:line_num
        station1_line(i) = (1 + (i-1)*operation_num)*2+1; %3,11
    end     %*可改进，与函数外的相同部分合并
%chrom0 = [12     2    10     7     3     8     9     6     4     5];
%check 2-,3-,4-,5-

minus = [2, 4, 6, 10, 12, 14];  %*待优化
plus = [3, 5, 7, 11, 13, 15];
check = [1, 2, 4, 6, 10, 12, 14];%correlated to dual_feasible
dual_feasible = [0, 5, 0, 7, 0, 8, 0, 0, 0, 13, 0, 15, 0, 16];%2- to 3+, 3- to 6+, 4- to 5+, 5- to 7+.与minus对应
feasible = 0;  %初始化可行性标记为0，即可行；
num = size(minus,2);
for i = 1:num  %臂A已经拿起一个工件
    chrom = chrom0;
    num_minus = 0;
    first_point = find(chrom == minus(i));
    k_plus = find(chrom == dual_feasible(minus(i)));
    if k_plus < first_point
            chrom = [chrom(first_point:n),chrom(1:(first_point-1))]; %因加工次序是一个循环，可调整结构
            k_plus = n - first_point + k_plus + 1;  %更新(chrom==dual_feasible(minus(i)))的位置
            first_point = 1;            
    end
    for j = first_point+1 : k_plus      
       if ismember(chrom(j),check)  %如果j动作是拿起（属于minus）
           if chrom(j) ~= 1  %chrom中目前就没有元素1？
                   if ~ismember(dual_feasible(chrom(j)),chrom(j+1:k_plus)) %拾取n-后如果在有（n+1）+操作，则不违反。
                        num_minus = num_minus + 1; %？             若后序不是放下操作
                        %disp(-1);
                        feasible = 1;
                        break;
                   else
                       if chrom(j+1) ~= dual_feasible(chrom(j))  %若下一动作不是放下两爪中的任一工件，则违反
                           feasible = 1;
                           break;
                       end
                   end
           else         
%                if ~ismember(station1_line(1),chrom(j+1:k_plus))&&~ismember(station1_line(2),chrom(j+1:k_plus)) %拾取n-后如果在有n+(chrom(j)+1)操作则不违反。
%                         num_minus = num_minus + 1;
%                         %disp(-1);
%                         feasible = 1;
%                end
           end
       end       
    end
 
  %进入可重入约束（reentrant）判断
  reentrant_ws = [6,7,14,15]; %可重入部分的工站编号
  first_ws = [2,3,10,11];  % 首次加工部分的工站编号
  if  feasible == 0
	% 第一个可重入工站
    pos1_begin = find(chrom == reentrant_ws(2));
    pos1_end = find(chrom == reentrant_ws(1));
     if pos1_end < pos1_begin
            chrom = [chrom(pos1_begin:n),chrom(1:(pos1_begin-1))]; %因加工次序是一个循环，可调整结构
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
  % 第二个可重入工站
    pos2_begin = find(chrom == reentrant_ws(4));
    pos2_end = find(chrom == reentrant_ws(3));
    if pos2_end < pos2_begin
            chrom = [chrom(pos2_begin:n),chrom(1:(pos2_begin-1))]; %因加工次序是一个循环，可调整结构
            pos2_end = n - pos2_begin + pos2_end + 1; 
            pos2_begin = 1;      
%         [pos2_begin,pos2_end] = exchange(pos2_begin,pos2_end); 
    end
    chrom_re2 = chrom(:,pos2_begin:pos2_end);
    if (ismember(first_ws(3),chrom_re2)) || (ismember(first_ws(4),chrom_re2))
        feasible = 1;
     end
  end
 %再考虑2—、2+之间是不是有4-、4+，6-、6+之间是不是有8-、8+
  if  feasible == 0
	% 第一个可重入工站
    pos1_begins = find(chrom ==  first_ws(2));
    pos1_ends = find(chrom ==  first_ws(1));
     if pos1_ends < pos1_begins
            chrom = [chrom(pos1_begins:n),chrom(1:(pos1_begins-1))]; %因加工次序是一个循环，可调整结构
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
	% 第二个可重入工站
    pos2_begins = find(chrom ==  first_ws(4));
    pos2_ends = find(chrom ==  first_ws(3));
     if pos2_ends < pos2_begins
            chrom = [chrom(pos2_begins:n),chrom(1:(pos2_begins-1))]; %因加工次序是一个循环，可调整结构
            pos2_ends = n - pos2_begins + pos2_ends + 1; 
            pos2_begins = 1;       
%         [pos2_begins,pos2_ends] = exchange(pos2_begins,pos2_ends);       
     end
    chrom_re2s = chrom(:,pos2_begins:pos2_ends);
    if (ismember(reentrant_ws(3),chrom_re2s)) || (ismember(reentrant_ws(4),chrom_re2s))
        feasible = 1;
    end 
 end
 %可重入约束-------------------
    if feasible == 1  %若不可行，则立即调出循环
        break;
    end
end
