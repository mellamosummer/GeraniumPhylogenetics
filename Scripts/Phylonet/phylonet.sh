#!/bin/bash
#SBATCH --job-name=testphylonet         # Job name
#SBATCH --partition=batch             # Partition (queue) name
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16                    # Run on a single CPU
#SBATCH --mem=100gb                     # Job memory request
#SBATCH --time=12:00:00               # Time limit hrs:min:sec
#SBATCH --output=%x.%j.out            # Standard output log
#SBATCH --error=%x.%j.err             # Standard error log
#SBATCH --mail-type=END,FAIL          # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=srb67783@uga.edu  # Where to send mail



ml purge
ml PhyloNet/3.8.3-Java-1.8.0_241
java -jar ${EBROOTPHYLONET}/PhyloNet_3.8.3.jar phylonet.IN_5_allopp.nex
