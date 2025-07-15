#!/bin/bash 
#SBATCH --job-name=array_mafft_iq 
#SBATCH --partition=batch 
#SBATCH --ntasks=1 
#SBATCH --cpus-per-task=8 
#SBATCH --mem=25G 
#SBATCH --time=25:00:00 
#SBATCH --output=%j.mafft_iq.out 
#SBATCH --error=%j.mafft_iq.error 
#SBATCH --array=1-346

#make seqs uniq
#ml SeqKit
#for i in *FNA; do seqkit rename $i > ${i}_renamed; done

#run array job for each of the 353 HybPiper Genes
#ls *FNA_renamed > genelist.txt
base=$(awk "NR==${SLURM_ARRAY_TASK_ID}" genelist.txt)

#Load modules
#module load MAFFT
#module load trimAl 
module load IQ-TREE

# make output directories
#mkdir mafft 
#mkdir iqtree 
#mkdir trimal 

file=$(basename ${base} .concat.FNA_renamed)

#Align sequences with MAFFT
#mafft --thread 8 --auto ${base} > mafft/${file}.mafft.aln

#TRIMAL
#trimal -in mafft/${file}.mafft.aln -out trimal/${file}.mafft.aln.trimal

#IQ TREE
iqtree2 -s trimal/${file}.mafft.aln.trimal -m MFP -bb 1000 -nt 8 -redo -pre iqtree/${file}

#reroot gene trees
#ml phyx
#for x in iqtree/*treefile;do pxrr -t $x -g og1 -o $x.rr;done
