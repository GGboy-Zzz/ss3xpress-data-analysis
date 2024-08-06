### merge demultiplexed fastq files
## zhu yong
## 27 Feb 2024
## refer to: /home/zhuyong/package_repository/zUMIs/misc/merge_demultiplexed_fastq.R

library(stringi)
library(optparse)
library(data.table)
setDTthreads(1)

fastq_directory <- '/home/zhuyong/smartseq3_analysis/rawdata/20240130/'
fastq_files <- list.files(path = fastq_directory, pattern = ".[fastq|fq].gz",recursive = TRUE)   # set 'recursive=TRUE' to scan the subdirectory

### first check if the fastq file names are bcl2fastq style or SRA style:
num_files_sra <- sum(grepl(pattern = '_[1-2].fastq.gz', fastq_files))
num_files_bcl <- sum(grepl(pattern = '_R[1-2]_', fastq_files))

if(num_files_bcl >= num_files_sra){
  style <- 'bcl2fastq'
  file_delim_r1 <- "_R1_"
  file_delim_r2 <- "_R2_"
}else{
  style <- 'SRA'
  file_delim_r1 <- "_1.fastq.gz"
  file_delim_r2 <- "_2.fastq.gz"
}
print(paste("Detected files to be in",style,"format."))

read1_files <- grep(file_delim_r1, fastq_files, value = TRUE)
read2_files <- grep(file_delim_r2, fastq_files, value = TRUE)

#check if SE or PE data
if(length(read2_files) == 0){
  mode <- "SE"
}else{
  mode <- "PE"
}

#terminate if there is no data!
if(length(read1_files) == 0){
  print("No valid fastq files found!")
  stop()
}

samples <- data.table(r1 = read1_files)
if(mode == "PE") samples[,r2 := read2_files]
samples[, sample := tstrsplit(r1, file_delim_r1, keep = 1)][, BC := stringi::stri_rand_strings(.N, 8, pattern = "[A-Z]")]

outfile_r1 <- paste0(fastq_directory,"/reads_for_zUMIs.R1.fastq.gz")
outfile_r2 <- paste0(fastq_directory,"/reads_for_zUMIs.R2.fastq.gz")
outfile_index <- paste0(fastq_directory,"/reads_for_zUMIs.index.fastq.gz")

for(i in seq(nrow(samples))){
  system(paste("cat", paste(fastq_directory,samples[i]$r1,sep = "/"), ">>", outfile_r1))
  if(mode == "PE") system(paste("cat", paste(fastq_directory,samples[i]$r2,sep = "/"), ">>", outfile_r2))
  system(paste0('/home/zhuyong/miniconda3/bin/pigz'," -p2 -dc ", paste(fastq_directory,samples[i]$r1,sep = "/"), 
                " | awk -v bc=\"",samples[i]$BC,"\" '{i++;if(i==1 || i==3){print;}if(i==2){print bc;}if(i==4){i=0;print \"AAAAAAAA\";}}' | ",'/home/zhuyong/miniconda3/bin/pigz'," -c -p",1," >> ",outfile_index))
}

#system(paste(opt$pigz,"-p",opt$threads,outfile_r1))
#if(mode == "PE") system(paste(opt$pigz,"-p",opt$threads,outfile_r2))
#system(paste(opt$pigz,"-p",opt$threads,outfile_index))

fwrite(samples, file =  paste0(fastq_directory,"/reads_for_zUMIs.samples.txt"), quote = F, sep = "\t")
write(samples$BC, file = paste0(fastq_directory,"/reads_for_zUMIs.expected_barcodes.txt"))
print('Done')

### check outputs in shell
# zcat reads_for_zUMIs.R1.fastq.gz |wc -l
# zcat reads_for_zUMIs.R2.fastq.gz |wc -l
# zcat reads_for_zUMIs.index.fastq.gz |wc -l