#!/bin/bash
#SBATCH --mail-type=ALL
#SBATCH --mail-user=srb67793@uga.edu
#SBATCH --output=ASTRAL.%j.out
#SBATCH --error=ASTRAL.%j.err
#SBATCH --job-name=ASTRAL
#SBATCH --ntasks=1
#SBATCH --partition=batch
#SBATCH --mem=20gb
#SBATCH --time=20:00

#Make species tree from gene trees
mkdir ASTRAL

#load module
module load ASTRAL-PRO2/1.15.2.4-GCC-11.3.0

#concatenate gene trees into one file 
astral -i estimated_gene_trees.tree -o ASTRAL/astral_353_supercontigs.tre
