#!/bin/bash
#SBATCH --job-name=ParalogRetriever
#SBATCH --partition=batch
#SBATCH --mail-type=ALL
#SBATCH --mail-user=srb67793@uga.edu
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=50
#SBATCH --mem=50gb
#SBATCH --time=024:00:00
#SBATCH --output=ParalogRetriever.%j.out
#SBATCH --error=ParalogRetriever.%j.err

module load HybPiper/2.1.6-conda

hybpiper paralog_retriever namelist.txt -t_dna /scratch/srb67793/GeraniumPhylogenomics_April32024/mega353.fasta
