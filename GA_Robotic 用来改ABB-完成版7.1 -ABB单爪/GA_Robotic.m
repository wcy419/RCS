%�Ŵ��㷨
%D�Ǿ������nΪ��Ⱥ������CΪֹͣ������mΪ��ֵ��̭����ָ�����������Pc,�������Pm��RΪ���·��,RlengthΪ·������
function [R,minlen,length_ave,length_best]=GA_Robotic(D,C,n,N,Pc,Pm,EL,ET)
        farm=initpop(n,N);
         
        len_fitness=zeros(n,1);%�洢����ֵ 
        counter=0;
        minlenbefore=200;
        minlen=200;
        flagg=0;
        while counter<C
            minlenbefore=minlen;
            len=fitness(D,farm,ET,EL,N,n);
            length_ave(counter+1)=mean(len);
            length_best(counter+1)=min(len);
            maxlen=max(len);
            minlen=min(len);
            rr=find(len==minlen);%���ص�����len��·����̵�·������(i,1)
            if minlen<minlenbefore
            R=farm(rr(1,1),:);%�������·��
            end
            FARM=farm;%��ʤ��̭��nn��¼�˸��Ƹ���
%ѡ��  
          K=1;
          [aa,bb]=size(FARM);
          FARM2=FARM;
          len2=len;
          [len]=sort(len);
          for i=1:aa
              tt= find(len2==len(1,i));
              FARM(i,:)=FARM2(tt(1,1),:);
          end   
          for i=1:K
              j=aa+1-i;
              FARM(j,:)=FARM(i,:);          
          end
%����
              [aa,bb]=size(FARM);
               FARM2=FARM;
               for i=1:2:aa
                       if Pc>rand&&i<aa %�������Pc
                            A=FARM(i,:);
                            B=FARM(i+1,:);
                            [A,B]=CrossOperation(A,B);
             
                            FARM(i,:)=A;
                            FARM(i+1,:)=B;
                       end   
               end
               clear FARM2
%����   
            FARM2=FARM;
            for i=1:aa
                if Pm>=rand
                  A=MutateOperation(FARM(i,:));  
                  FARM(i,:)=A;
                end
            end
               clear FARM2
%Ⱥ�����
           FARM=[R;FARM];%�����������n-aa�������Ӻ�����Ⱥ,���ϴε��������Ž��ǰ�������Ⱥ
           [aa,bb]=size(FARM);                                            
             %������Ⱥ��ģΪn                                         
            if aa>n
                FARM=FARM(1:n,:);
            end   
            farm=FARM; %����farm
            clear FARM
            counter=counter+1 ; %���µ�������
            
            if minlenbefore==minlen
                flagg=flagg+1;
            else
                flagg=0;
            end
            if flagg==300
                break;
            end
       end
 %������
disp('�������Ž�');
disp(R);
disp('�������Ž�Ŀ�꺯��');
disp(minlen);


        toc