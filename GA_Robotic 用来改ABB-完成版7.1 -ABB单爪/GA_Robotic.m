%遗传算法
%D是距离矩阵，n为种群个数、C为停止代数、m为适值淘汰加速指数、交叉概率Pc,变异概率Pm、R为最短路径,Rlength为路径长度
function [R,minlen,length_ave,length_best]=GA_Robotic(D,C,n,N,Pc,Pm,EL,ET)
        farm=initpop(n,N);
         
        len_fitness=zeros(n,1);%存储适配值 
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
            rr=find(len==minlen);%返回的是在len中路径最短的路径坐标(i,1)
            if minlen<minlenbefore
            R=farm(rr(1,1),:);%更新最短路径
            end
            FARM=farm;%优胜劣汰，nn记录了复制个数
%选择  
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
%交叉
              [aa,bb]=size(FARM);
               FARM2=FARM;
               for i=1:2:aa
                       if Pc>rand&&i<aa %交叉概率Pc
                            A=FARM(i,:);
                            B=FARM(i+1,:);
                            [A,B]=CrossOperation(A,B);
             
                            FARM(i,:)=A;
                            FARM(i+1,:)=B;
                       end   
               end
               clear FARM2
%变异   
            FARM2=FARM;
            for i=1:aa
                if Pm>=rand
                  A=MutateOperation(FARM(i,:));  
                  FARM(i,:)=A;
                end
            end
               clear FARM2
%群体更新
           FARM=[R;FARM];%将随机产生的n-aa个体加入从后面种群,将上次迭代的最优解从前面加入种群
           [aa,bb]=size(FARM);                                            
             %保持种群规模为n                                         
            if aa>n
                FARM=FARM(1:n,:);
            end   
            farm=FARM; %更新farm
            clear FARM
            counter=counter+1 ; %更新迭代次数
            
            if minlenbefore==minlen
                flagg=flagg+1;
            else
                flagg=0;
            end
            if flagg==300
                break;
            end
       end
 %结果输出
disp('近似最优解');
disp(R);
disp('近似最优解目标函数');
disp(minlen);


        toc