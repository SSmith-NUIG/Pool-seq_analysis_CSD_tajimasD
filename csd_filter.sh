#!/bin/sh 
#SBATCH --job-name="smtls"
#SBATCH -o /data/ssmith/logs/smtls_%A_%a.out
#SBATCH -e /data/ssmith/logs/smtls_%A_%a.err
#SBATCH --array=34-192
#SBATCH -N 1
#SBATCH -n 4
#"$SLURM_ARRAY_TASK_ID"
# grab our sample names for output naming
samples_name=$(basename /data3/ssmith/ena/pi/"$SLURM_ARRAY_TASK_ID"_*_csd.pi _csd.pi)

echo $samples_name

# get only the chromosome 1 locations as CSD is on LG1
grep "LG1" "$samples_name".theta > /data3/ssmith/ena/pi/"$samples_name"_LG1.theta

# get all positions between the start and end of the gene
awk '$2 > 11771000' /data3/ssmith/ena/pi/"$samples_name"_LG1.theta > /data3/ssmith/ena/pi/"$samples_name"_csd_fixed.theta

rm /data3/ssmith/ena/pi/"$samples_name"_LG1.theta

awk '$2 < 11781750' /data3/ssmith/ena/pi/"$samples_name"_csd_fixed.theta > /data3/ssmith/ena/pi/"$samples_name"_csd_final.theta

rm /data3/ssmith/ena/pi/"$samples_name"_csd_fixed.theta


# simply renaming the files
mv /data3/ssmith/ena/pi/"$samples_name"_csd_final.theta /data3/ssmith/ena/pi/"$samples_name"_csd.theta
