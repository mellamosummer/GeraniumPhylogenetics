#!/bin/bash
#SBATCH --job-name=HybPiperStats
#SBATCH --partition=batch
#SBATCH --mail-type=ALL
#SBATCH --mail-user=srb67793@uga.edu
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=10
#SBATCH --mem=50gb
#SBATCH --time=01:00:00
#SBATCH --output=HPStats.%j.out
#SBATCH --error=HPStats.%j.err

module load HybPiper/2.1.6-conda

hybpiper stats -t_dna /scratch/srb67793/GeraniumPhylogenomics_April32024/mega353.fasta gene /scratch/srb67793/GeraniumPhylogenomics_April32024/NewRun/scripts/namelist.txt

hybpiper recovery_heatmap /scratch/srb67793/GeraniumPhylogenomics_April32024/NewRun/HybPiperDirs/seq_lengths.tsv
