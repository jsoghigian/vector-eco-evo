library(ape)

dat<-read.dna(file="sco75_final.phy", format = "sequential", as.character=TRUE, skip=0)

dat<-as.DNAbin(dat)
dat_total <- dat
dat_total[,seq(1, length(dat_total[1,]), 3)] -> codon_1
dat_total[,seq(2, length(dat_total[1,]), 3)] -> codon_2
dat_total[,seq(3, length(dat_total[1,]), 3)] -> codon_3
write.FASTA(codon_1,file="codon1_mosq.fasta")
write.FASTA(codon_2,file="codons2_mosq.fasta")
write.FASTA(codon_3,file="codons3_mosq.fasta")