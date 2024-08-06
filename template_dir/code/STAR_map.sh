#!/bin/sh
#SBATCH --job-name=star_map
#SBATCH -o /home/zhuyong/smartseq3_analysis/outputs/2024.01.08/logs/%j_%x.log 
#SBATCH -e /home/zhuyong/smartseq3_analysis/outputs/2024.01.08/logs/%j_%x.log 
#SBATCH --nodes=1
#SBATCH --nodelist=cpu07
#SBATCH --ntasks-per-node=4 # specify number of CPUs to use here
#SBATCH --mem-per-cpu=10gb

## zhu yong
## 27 Feb 2024

inputdir="/home/zhuyong/smartseq3_analysis/rawdata/20240108/merge_fastq" # your path
outdir="/home/zhuyong/smartseq3_analysis/outputs/2024.01.08"
ref="/home/zhuyong/smartseq3_analysis/ref/hg38/hg38_STAR_idx_noGTF" # the reference directory

# make sub directories for trimmed reads and star output
if [ ! -d ${outdir}/trimmed ]; then
mkdir ${outdir}/trimmed
mkdir ${outdir}/star
fi

module load trim_galore/0.6.10   
module load star/2.7.3a

for i in S1-1 S1-2 S1-3 S2-5 S2-6 S2-7 S3-9 S3-10 S3-11
do
		s=${i} # sample ID
		echo $s

		r1=${inputdir}/${s}_R1_001.fq.gz # read 1 raw data fastq gz
		r2=${inputdir}/${s}_R2_001.fq.gz # read 2 raw data fastq gz
		trim_galore --paired --clip_R1 15 --clip_R2 15 \
		--three_prime_clip_R1 3 --three_prime_clip_R2 3 \
		-o ${outdir}/trimmed/ \
		$r1 $r2 \

		trimmed1=${inputdir}/trimmed/${s}_*_val_1.fq.gz # trimmed read 1
		trimmed2=${inputdir}/trimmed/${s}_*_val_2.fq.gz # trimmed read 2

		STAR --genomeDir ${ref} \
		--readFilesIn $trimmed1 $trimmed2 \
		--readFilesCommand zcat \
		--outFileNamePrefix ${outdir}/star/${s} \
		--runThreadN 4 --outSAMtype BAM SortedByCoordinate

	
done
