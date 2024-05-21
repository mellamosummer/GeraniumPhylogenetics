#!/bin/bash
#SBATCH --job-name=array_mafft_iq
#SBATCH --partition=batch
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=30
#SBATCH --mem=25G
#SBATCH --time=25:00:00
#SBATCH --output=%j.mafft_iq.out
#SBATCH --error=%j.mafft_iq.error
#SBATCH --array=2-353

#set output directory variable
OUTDIR="/scratch/srb67793/GeraniumPhylogenomics_April32024/NewRun/supercontigs"

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

file=$(basename ${base} _supercontig.fasta)

#Align sequences with MAFFT
mafft --thread 8 --auto ${base} > mafft/${file}.mafft.aln

#TRIMAL
trimal -in mafft/${file}.mafft.aln -out trimal/${file}.mafft.aln.trimal

#IQ TREE
iqtree -s trimal/${file}.mafft.aln.trimal -m MFP -bb 1000 -nt 8 -redo -pre iqtree/${file}
