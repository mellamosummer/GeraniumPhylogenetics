#!/bin/bash
#SBATCH --job-name=paralog_array_mafft_iq
#SBATCH --partition=batch
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=5
#SBATCH --mem=25G
#SBATCH --time=1:00:00
#SBATCH --output=%j.paralogmafft_iq.out
#SBATCH --error=%j.paralogmafft_iq.error
#SBATCH --array=2-353

#run array job for each of the 353 HybPiper Genes
base=$(awk "NR==${SLURM_ARRAY_TASK_ID}" namelist.txt)

#Load modules
module load MAFFT/7.505-GCC-11.3.0-with-extensions
module load trimAl/1.4.1-GCCcore-11.3.0
module load IQ-TREE/1.6.12-foss-2022a

# make output directories
mkdir mafft
mkdir iqtree
mkdir trimal

file=$(basename ${base} .fasta)

#Align sequences with MAFFT
mafft --thread 8 --auto ${base} > mafft/${file}.mafft.aln

#TRIMAL
trimal -in mafft/${file}.mafft.aln -out trimal/${file}.mafft.aln.trimal

#IQ TREE
iqtree -s trimal/${file}.mafft.aln.trimal -m MFP -bb 1000 -nt 8 -redo -pre ${file}
