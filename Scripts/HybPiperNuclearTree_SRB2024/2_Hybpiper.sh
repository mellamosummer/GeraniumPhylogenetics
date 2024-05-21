#!/bin/bash
#SBATCH --mail-type=ALL
#SBATCH --mail-user=srb67793@uga.edu
#SBATCH --output=HybPiper.%j.out
#SBATCH --error=HybPiper.%j.err
#SBATCH --job-name=Hybpiper_array
#SBATCH --ntasks=30
#SBATCH --partition=batch
#SBATCH --mem=200gb
#SBATCH --time=72:00:00
#SBATCH --array=1-47

module load HybPiper/2.1.6-conda

file=$(awk "NR==${SLURM_ARRAY_TASK_ID}" namelist.txt)

hybpiper assemble -t_dna /scratch/srb67793/GeraniumPhylogenomics_April32024/mega353.fasta  -r /scratch/srb67793/GeraniumPhylogenomics_April32024/trimmedreads/paired/${file}* --prefix $file --timeout_exonerate_contigs 10000 --bwa
