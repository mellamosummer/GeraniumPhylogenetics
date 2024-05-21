#!/bin/bash
#SBATCH --mail-type=ALL
#SBATCH --mail-user=srb67793@uga.edu
#SBATCH --output=HybPiper.%j.out
#SBATCH --error=HybPiper.%j.err
#SBATCH --job-name=Hybpiper_retrieveseqs
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=30
#SBATCH --partition=batch
#SBATCH --mem=200gb
#SBATCH --time=2:00:00

#Load module
module load HybPiper/2.1.6-conda

#Get genes assembled by hybpiper
hybpiper retrieve_sequences --targetfile_dna /scratch/srb67793/GeraniumPhylogenomics_April32024/mega353.fasta supercontig --sample_names /scratch/srb67793/GeraniumPhylogenomics_April32024/NewRun/HybPiperDirs/namelist.txt
