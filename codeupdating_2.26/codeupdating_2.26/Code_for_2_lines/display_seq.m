% Finding an intuitive way to show the operation sequence of the output 
function  display_seq(sequence,minlen_seq)
  num_encode = [1,2,3,4,5,6,7,8,10,11,12,13,14,15,16]; % the number way for encoding
  symbol_encode = [1-1i,2-1i,2+1i,3-1i,3+1i,4-1i,4+1i,1+1i,6-1i,6+1i,7-1i,7+1i,8-1i,8+1i,1+1i]; % the symbol way for encoding
  char_encode = {'1-','2-','2+','3-','3+','4-','4+','1+','6-','6+','7-','7+','8-','8+','1+'};
  display_mode = 1;
  sequence_with_1 = add_1minus(sequence);
  col = size(sequence_with_1,2);
  new_sequence1 = zeros(1,col);
  new_sequence2 = cell(1,col);
  if display_mode == 0
      for num = 1:size(num_encode,2)
         s_index = (sequence_with_1 == num_encode(num));
         new_sequence1(s_index) = symbol_encode(num);
      end
      disp('近似最优解：');
      disp(new_sequence1);
  else
     for num = 1:size(num_encode,2)
         s_index = (sequence_with_1 == num_encode(num));
         new_sequence2(s_index) = char_encode(num);
     end 
     disp('近似最优解：');
     disp(new_sequence2);
  end
  % display the results
% disp('近似最优解');
% disp(new_sequence);
disp('近似最优解目标函数值：');
disp(minlen_seq);
end
