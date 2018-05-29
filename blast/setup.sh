wget ftp://ftp.ncbi.nih.gov/refseq/B_taurus/mRNA_Prot/cow.1.protein.faa.gz
wget ftp://ftp.ncbi.nih.gov/refseq/H_sapiens/mRNA_Prot/human.1.protein.faa.gz
gunzip *gz
makeblastdb -in human.1.protein.faa -dbtype prot
head -6 cow.1.protein.faa > cow.small.faa
head -199 cow.1.protein.faa > cow.medium.faa
