#!/bin/sh 
#SBATCH --job-name="pileups"
#SBATCH -o /data/ssmith/logs/pileups_%A_%a.out
#SBATCH -e /data/ssmith/logs/pileups_%A_%a.err
#SBATCH --array=33-35,190-192
#SBATCH -N 1
#SBATCH -n 4
#"$SLURM_ARRAY_TASK_ID"
#33-62,64-69,71-73,75-80,82-91%10
module load Anaconda3
source activate wgs_env

string="$SLURM_ARRAY_TASK_ID"
col_pool_size=$(awk -F "," -v var="$string" '$1 == var { print $3 }' /data3/ssmith/novo2pool.csv)
col_name=$(awk -F "," -v var="$string" '$1 == var { print $2 }' /data3/ssmith/novo2pool.csv)
echo $col_pool_size

/home/ssmith/samtools-0.1.16/samtools pileup /data2/ssmith/bams/"$SLURM_ARRAY_TASK_ID"_*.bam \
-f /data/ssmith/c_l_genome/apis_c_l_genome.fa \
> /data3/ssmith/ena/pileups/"$SLURM_ARRAY_TASK_ID"_"$col_name".pileup

perl /home/ssmith/popoolation_1.2.2/basic-pipeline/subsample-pileup.pl \
--input /data3/ssmith/ena/pileups/"$SLURM_ARRAY_TASK_ID"_"$col_name".pileup \
--output /data3/ssmith/ena/pileups/subsamples/"$SLURM_ARRAY_TASK_ID"_"$col_name".pileup \
--fastq-type sanger \
--target-coverage 30 \
--max-coverage 200 \
--min-qual 20 \
--method fraction

rm /data3/ssmith/ena/pileups/"$SLURM_ARRAY_TASK_ID"_"$col_name".pileup

perl /home/ssmith/popoolation_1.2.2/Variance-sliding.pl \
--input /data3/ssmith/ena/pileups/subsamples/"$SLURM_ARRAY_TASK_ID"_"$col_name".pileup \
--output /data3/ssmith/ena/pi/"$SLURM_ARRAY_TASK_ID"_"$col_name".pi \
--measure pi \
--window-size 100 \
--step-size 100 \
--min-count 2 \
--min-coverage 4 \
--max-coverage 5000 \
--min-qual 20 \
--min-covered-fraction 0.01 \
--fastq-type sanger \
--pool-size "$col_pool_size"

perl /home/ssmith/popoolation_1.2.2/Variance-sliding.pl \
--input /data3/ssmith/ena/pileups/subsamples/"$SLURM_ARRAY_TASK_ID"_"$col_name".pileup \
--output /data3/ssmith/ena/pi/"$SLURM_ARRAY_TASK_ID"_"$col_name".theta \
--measure theta \
--window-size 100 \
--step-size 100 \
--min-count 2 \
--min-coverage 4 \
--max-coverage 5000 \
--min-qual 20 \
--min-covered-fraction 0.01 \
--fastq-type sanger \
--pool-size "$col_pool_size"

perl /home/ssmith/popoolation_1.2.2/Variance-sliding.pl \
--input /data3/ssmith/ena/pileups/subsamples/"$SLURM_ARRAY_TASK_ID"_"$col_name".pileup \
--output /data3/ssmith/ena/pi/"$SLURM_ARRAY_TASK_ID"_"$col_name".D \
--measure D \
--window-size 100 \
--step-size 100 \
--min-count 2 \
--min-coverage 4 \
--max-coverage 5000 \
--min-qual 20 \
--min-covered-fraction 0.01 \
--fastq-type sanger \
--pool-size "$col_pool_size"

perl /home/ssmith/popoolation_1.2.2/Variance-at-position.pl \
--pool-size "$col_pool_size" \
--min-qual 10 \
--min-coverage 1 \
--min-count 2 \
--fastq-type sanger \
--max-coverage 5000 \
--pileup /data3/ssmith/ena/pileups/subsamples/"$SLURM_ARRAY_TASK_ID"_"$col_name".pileup \
--gtf /data/ssmith/c_l_genome/cl_exons.gtf \
--output /data3/ssmith/ena/pi/"$SLURM_ARRAY_TASK_ID"_"$col_name".genes.pi \
--measure pi

perl /home/ssmith/popoolation_1.2.2/Variance-at-position.pl \
--pool-size "$col_pool_size" \
--min-qual 10 \
--min-coverage 1 \
--min-count 2 \
--fastq-type sanger \
--max-coverage 5000 \
--pileup /data3/ssmith/ena/pileups/subsamples/"$SLURM_ARRAY_TASK_ID"_"$col_name".pileup \
--gtf /data/ssmith/c_l_genome/cl_exons.gtf \
--output /data3/ssmith/ena/pi/"$SLURM_ARRAY_TASK_ID"_"$col_name".genes.theta \
--measure theta

perl /home/ssmith/popoolation_1.2.2/Variance-at-position.pl \
--pool-size "$col_pool_size" \
--min-qual 10 \
--min-coverage 1 \
--min-count 2 \
--fastq-type sanger \
--max-coverage 5000 \
--pileup /data3/ssmith/ena/pileups/subsamples/"$SLURM_ARRAY_TASK_ID"_"$col_name".pileup \
--gtf /data/ssmith/c_l_genome/cl_exons.gtf \
--output /data3/ssmith/ena/pi/"$SLURM_ARRAY_TASK_ID"_"$col_name".genes.D \
--measure D

rm /data3/ssmith/ena/pileups/subsamples/"$SLURM_ARRAY_TASK_ID"_"$col_name".pileup
