function solusion = stationconvert_timesum (n,R)
%将ConvertToVRPSolution（）得到的序列转化成实际的机器编号（两条线：1~5，三条线：1~7）
%便于后面利用传输矩阵D进行传输时间的计算。
  for j = 1 : n
    workpoint = numel(R(j,:));  %待改进&
   %第一条线的可重入站    
    line1_c1= R(j,:) == 4;  
    R(j,line1_c1) = 2;
    % 第二条线的转化
    line2_c1 = R(j,:) == 6;
    line2_c2 = R(j,:) == 7;      
    line2_c3 = R(j,:) == 8;
    R(j,line2_c1) = 4;
    R(j,line2_c2) = 5;       
    R(j,line2_c3) = 4;
     % 第三条线
    line3_c1 = R(j,:) == 10;
    line3_c2 = R(j,:) == 11;
    line3_c3 = R(j,:) == 12;
      
    R(j,line3_c1) = 6;
    R(j,line3_c2) = 7;
    R(j,line3_c3) = 6;
   
    solusion(j,:)=R(j,:);  % 待改进，最好可进行初始化&
end
