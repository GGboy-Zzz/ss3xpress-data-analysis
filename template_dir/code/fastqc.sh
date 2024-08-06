#!/bin/bash
#SBATCH --job-name=fastqc
#SBATCH --partition cpu
#SBATCH -o /home/zhuyong/smartseq3_analysis/outputs/2024.01.30/logs/%j_%x.log
#SBATCH -e /home/zhuyong/smartseq3_analysis/outputs/2024.01.30/logs/%j_%x.log
#SBATCH --nodes 1 
#SBATCH -n 5

# 27 Feb 2024
# zhu yong

fastqc /home/zhuyong/smartseq3_analysis/rawdata/20240130/S*/*.gz -o /home/zhuyong/smartseq3_analysis/outputs/2024.01.30/fastqc