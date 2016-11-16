function chrom=positionchange(farm)

q=find(farm==14);
p=find(farm==1); 
if q<14

temp=farm(p);
farm(p)=farm(q+1);
farm(q+1)=temp;
else
    farm(p:13)=farm(p+1:14);
    farm(14)=1;
end
chrom=farm;