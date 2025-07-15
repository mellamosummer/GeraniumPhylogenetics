#!/bin/bash
#SBATCH --partition=batch
#SBATCH --job-name=blastdb
#SBATCH --ntasks=1
#SBATCH --time=2:00:00
#SBATCH --mem=20G


#first run hybpiper retrieve sequences for G_maculatum and diploid species separately

#load modules
#ml gffread
ml BLAST+/2.16.0-gompi-2023b

#get CDS seqs from genome annotation/genome
#gffread -g G_maculatum_BF73-hap1-JBAT.FINAL.clean.fa -x CDS_longest_isoform.fa G_maculatum.longest_isoforms.gff


#BLAST hybpiper seqs to genome
#makeblastdb -in CDS_longest_isoform.fa -dbtype 'nucl' -out G_maculatum_CDS
for i in gmac_cds_seqs/*; do blastn -db G_maculatum_CDS -query $i -evalue 1e-50 -outfmt 6 -out blasthits/${i}_blasthits.txt; done

#cut the sequences from the BALST hit comlumns to make new file with just seuqence names 
for i in *blasthits.txt ; do cut -f 2 $i | sort | uniq > ${i}_seqname; done

#Get sequences into file from BLAST hits
for i in *seqname; do seqkit grep -i -f $i ../CDS_longest_isoform.fa > ${i}.fasta; done

#Rename sequences headers to include G_maculatum 
for i in *.fasta; do sed 's/>/>G_maculatum /g' ${i} > ${i}.new; done

#Concatenate to gene files from hybpiper
 for i in *new ; do file=$(basename ${i} .FNA_blasthits.txt_seqname.fasta.new); cat $i ../diploid_cds_seqs/${file}* > ${file}.concat.FNA; done

#for i in *.FNA; do file=$(basename ${i} .FNA); cat G_maculatum/databases/genes_with_seqs/${file}* $i > ${i}_concat.FNA; done

#make gene trees using for loop mafft trimal iqtree2 script

#reroot gene trees
#for x in GeneTrees/*;do pxrr -t $x -g  -o $x.rr;done

#parse rooted gene trees to examine topologies for evidence of allopolyploidy

#make astralpro3 species tree using unrooted trees

#first need to rename multi copy genes
for i in *treefile; do sed -i 's/G_maculatum_2/G_maculatum/g' $i; sed -i 's/G_maculatum_3/G_maculatum/g' $i; sed -i 's/G_maculatum_4/G_maculatum/g' $i; sed -i 's/G_maculatum_5/G_maculatum/g' $i; done


#concatenate trees for astral
cat *treefile > astral_concat_trees.treefile

#Run astralpro3 (bc multicopy gene trees)
astral-pro3 -i astral_concat_trees.treefile -out astralpro3_speciestree.treefile
