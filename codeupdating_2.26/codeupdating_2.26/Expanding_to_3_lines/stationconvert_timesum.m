function solusion = stationconvert_timesum (n,R)
%��ConvertToVRPSolution�����õ�������ת����ʵ�ʵĻ�����ţ������ߣ�1~5�������ߣ�1~7��
%���ں������ô������D���д���ʱ��ļ��㡣
  for j = 1 : n
    workpoint = numel(R(j,:));  %���Ľ�&
   %��һ���ߵĿ�����վ    
    line1_c1= R(j,:) == 4;  
    R(j,line1_c1) = 2;
    % �ڶ����ߵ�ת��
    line2_c1 = R(j,:) == 6;
    line2_c2 = R(j,:) == 7;      
    line2_c3 = R(j,:) == 8;
    R(j,line2_c1) = 4;
    R(j,line2_c2) = 5;       
    R(j,line2_c3) = 4;
     % ��������
    line3_c1 = R(j,:) == 10;
    line3_c2 = R(j,:) == 11;
    line3_c3 = R(j,:) == 12;
      
    R(j,line3_c1) = 6;
    R(j,line3_c2) = 7;
    R(j,line3_c3) = 6;
   
    solusion(j,:)=R(j,:);  % ���Ľ�����ÿɽ��г�ʼ��&
end
