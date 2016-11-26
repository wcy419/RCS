function convert_chrom = convert(chrom,minus,plus)
    n = size(chrom,2);
    p = find(chrom==plus);
    convert1 = [chrom(1:p-1),chrom(p+1:n)];
    insert = find(convert1==minus);
    convert_chrom = [convert1(1:insert),plus,convert1(insert+1:n-1)];
end