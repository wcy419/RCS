function fitness=fit(len,maxlen,minlen)
fitness=len;
for i=1:length(len)
    fitness(i,1)=(1-(len(1,i)-minlen)/(maxlen-minlen+0.0001));
end