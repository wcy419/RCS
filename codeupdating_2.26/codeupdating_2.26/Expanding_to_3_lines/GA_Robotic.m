%�Ŵ��㷨
%D�Ǿ������nΪ��Ⱥ������CΪֹͣ������mΪ��ֵ��̭����ָ�����������Pc,�������Pm��RΪ���·��,RlengthΪ·������
function [R,minlen,length_ave,length_best] = GA_Robotic(D,C,n,N,Pc,Pm,EL,ET)
        farm = initpop(n,N);
        len_fitness = zeros(n,1);%�洢����Ⱦɫ�����Ӧ��ֵ������Ⱦɫ�����ʤ��̭��
        counter=0;%�Ŵ���������
        minlen_array = [];
        minlen = 600; %���б䳤ʱ�����
        flagg = 0;  % ���ã�
        while counter < C
            minlenbefore = minlen;%��һ����Ŀ�꺯����Сֵ�������뱾���Ƚϣ�
            [len,farm] = fitness(D,farm,ET,EL,N,n);%�����n����Ⱥ��ÿ��Ⱦɫ���Ŀ�꺯��ֵ
            length_ave(counter+1) = mean(len);
            minlen = min(len);
            length_best(counter+1) = minlen;     
            rr = find(len==minlen);%���ص�����len��·����̵�·������(i,1)
            if minlen > minlenbefore
                minlen = minlenbefore;
                length_best(counter+1) = minlen;
            end
            if minlen < minlenbefore
            R = farm(rr(1,1),:);%�������·��
            end
            FARM = farm;%��ʤ��̭��nn��¼�˸��Ƹ���
%ѡ��  
          [aa,~] = size(FARM);
          FARM2 = FARM;
          len2 = len;
          [len] = sort(len);
          i = 1;
          while i <= aa        %*����lenֵ��ͬ�������Ƿ������⣿���ܻὫlenֵ��ͬ������ɾ����
              tt = find(len2 == len(1,i));
              FARM(i:(i+numel(tt)-1),:) = FARM2(tt,:);
              i = i + numel(tt);
          end   %������ѡ�񷨣�����Ⱦɫ�尴��Ӧ��ֵ��С����
          clear i;
%����
              [aa,~] = size(FARM);
               FARM2 = FARM; % ��ҪFARM2�𣿻���ֱ�ӿ���FARM
               for i = 1:2:aa
                       if Pc > rand && i < aa  %�������Pc
                            A = FARM2(i,:);
                            B = FARM2(i+1,:);
                            [A,B] = CrossOperation(A,B);             
                            FARM(i,:) = A;
                            FARM(i+1,:) = B;
                       end   
               end
               clear FARM2
%����   
            FARM2 = FARM;
            for i = 1:aa
                if Pm >= rand
                  A = MutateOperation(FARM2(i,:));  
                  FARM(i,:) = A;
                end
            end
               clear FARM2
%Ⱥ�����
           FARM = [R;FARM];%���ϴε��������Ž��ǰ�������Ⱥ
           [aa,~] = size(FARM);                                            
             %������Ⱥ��ģΪn                                         
            if aa > n
                FARM = FARM(1:n,:);
            end   
            farm = FARM; %����farm
            clear FARM
            counter = counter + 1 ; %���µ�������            
            if minlenbefore == minlen
                flagg = flagg + 1;
            else
                flagg = 0;
            end
            if flagg == 300  % �ɿ��ǸĽ�
                break;
            end
       end
 %������
disp('�������Ž�:');
disp(R);
% disp('�������Ž�Ŀ�꺯��');
% disp(minlen);
display_seq(R,minlen);
        