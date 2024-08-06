#!/bin/bash
#SBATCH --job-name=zumis
#SBATCH --partition cpu
#SBATCH -o /home/zhuyong/smartseq3_analysis/outputs/2024.01.30/logs/%j_%x.log
#SBATCH -e /home/zhuyong/smartseq3_analysis/outputs/2024.01.30/logs/%j_%x.log 
#SBATCH --nodes 1 
#SBATCH --ntasks-per-node=16 # specify number of CPUs to use here
#SBATCH --mem-per-cpu=10gb

## zhu yong
## 20 Feb 2024

## Manually activating the Conda environment
# eval "$(conda shell.bash hook)"
# cd  /home/zhuyong/package_repository/zUMIs/
# tar -xj --overwrite -f zUMIs-miniconda.tar.bz2 -C zUMIs-env
# source zUMIs-env/bin/activate 
# conda-unpack
# echo "done"


/home/zhuyong/package_repository/zUMIs/zUMIs.sh -c -y /home/zhuyong/smartseq3_analysis/code/smartseq3.yaml
