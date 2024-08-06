#!/bin/sh
#SBATCH --job-name=qualimap
#SBATCH -o /home/zhuyong/ss3xpress_analysis/20240130/logs/%j_%x.log
#SBATCH -e /home/zhuyong/ss3xpress_analysis/20240130/logs/%j_%x.log 
#SBATCH --nodes=1
#SBATCH --nodelist=cpu07
#SBATCH -n 4
#SBATCH --mem-per-cpu=10gb

# 18 Mar 2024
# zhu yong

dir='/home/zhuyong/ss3xpress_analysis/20240130/outputs/star'
for i in 5 6 7 8
do
/home/zhuyong/package_repository/qualimap_v2.3/qualimap bamqc -bam $dir/S1-${i}Aligned.sortedByCoord.out.bam -outformat PDF -outfile ${i}bamqc.pdf -outdir $dir/bamqc -nt 4 --java-mem-size=10G
done


#/home/zhuyong/package_repository/qualimap_v2.3/qualimap bamqc -bam /home/zhuyong/ss3xpress_analysis/20240130/outputs/zumis/293T_ss3xpress.filtered.Aligned.GeneTagged.sorted.bam -outformat PDF -outfile bamqc.pdf  -outdir /home/zhuyong/ss3xpress_analysis/20240130/outputs -nt 4 --java-mem-size=10G