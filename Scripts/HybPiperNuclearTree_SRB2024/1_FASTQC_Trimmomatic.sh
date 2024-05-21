#!/bin/bash
#SBATCH --job-name=HybPiper
#SBATCH --partition=batch
#SBATCH --mail-type=ALL
#SBATCH --mail-user=srb67793@uga.edu
#SBATCH --ntasks=8
#SBATCH --mem=100gb
#SBATCH --time=048:00:00
#SBATCH --output=BLAST.%j.out
#SBATCH --error=BLAST.%j.err

##################################
# SET UP
##################################

#set output directory variable
OUTDIR="/scratch/srb67793/GeraniumPhylogenomics_April32024"

#if output directory doesn't exist, create it

# if [ ! -d $OUTDIR ]
# then
#     mkdir -p $OUTDIR
# fi

##################################
# Load Modules
##################################

module load Trimmomatic/0.39-Java-13
module load FastQC/0.11.9-Java-11
module load MultiQC/1.14-foss-2022a

##################################
# 1) Pre Trim QC 
##################################

QC pre-trim with FASTQC & MultiQC
mkdir $OUTDIR/FastQC
mkdir $OUTDIR/FastQC/pretrim
fastqc -o $OUTDIR/FastQC/pretrim/ $OUTDIR/*
multiqc $OUTDIR/FastQC/pretrim/*.zip -o $OUTDIR/FastQC/pretrim/

##################################
# 2) Trimmomatic
##################################

mkdir $OUTDIR/trimmedreads
for infile in $OUTDIR/*1_001.fastq.gz; do
       base=$(basename ${infile} 1_001.fastq.gz);
       java -jar $EBROOTTRIMMOMATIC/trimmomatic-0.39.jar PE -threads 8 \
       ${infile} \
       $OUTDIR/${base}2_001.fastq.gz \
       $OUTDIR/trimmedreads/${base}1_paired.fastq \
       $OUTDIR/trimmedreads/${base}1_unpaired.fastq \
       $OUTDIR/trimmedreads/${base}2_paired.fastq \
       $OUTDIR/trimmedreads/${base}2_unpaired.fastq \
       ILLUMINACLIP:$EBROOTTRIMMOMATIC/adapters/TruSeq3-PE-2.fa:2:30:10 \
       LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36
done

mkdir $OUTDIR/trimmedreads/paired
mkdir $OUTDIR/trimmedreads/unpaired
mv $OUTDIR/trimmedreads/*_paired.fastq $OUTDIR/trimmedreads/paired
mv $OUTDIR/trimmedreads/*_unpaired.fastq $OUTDIR/trimmedreads/unpaired

####################################################################
# 3) Post-Trim QC
####################################################################

#QC post-trim with FASTQC & MultiQC
mkdir $OUTDIR/FastQC/trimmed
fastqc -o $OUTDIR/FastQC/trimmed $OUTDIR/trimmedreads/paired/*
multiqc $OUTDIR/FastQC/trimmed/*.zip -o $OUTDIR/FastQC/trimmed
