#!/bin/sh
#SBATCH --job-name=STAR_ref
#SBATCH -o /home/zhuyong/slurmJob/logs/%j_%x.log
#SBATCH -e /home/zhuyong/slurmJob/logs/%j_%x.log 
#SBATCH --nodes=1
#SBATCH -n 15

# 19 Feb 2024
# zhu yong
# refer to : https://github.com/sdparekh/zUMIs/wiki/Usage#config-file-generation-using-rshiny

module load samtools/1.14
module load star/2.7.3a

STAR --runMode genomeGenerate --runThreadN 15 --genomeDir /home/zhuyong/zumis/reference/hg38/hg38_STAR_idx_noGTF --limitGenomeGenerateRAM 111000000000 --genomeFastaFiles /home/zhuyong/zumis/reference/hg38/Homo_sapiens.GRCh38.dna.primary_assembly.fa