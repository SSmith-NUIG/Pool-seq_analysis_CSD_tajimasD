
#This script will combine all of the pi, D, or theta files into one for ease of analysis. We lose the number of SNPs in each window here but they are in the original files and can be pulled out if needed


#!/bin/bash 
#SBATCH --job-name="combine"
#SBATCH -o /data/ssmith/logs/combine_%A_%a.out
#SBATCH -e /data/ssmith/logs/combine_%A_%a.err
#SBATCH -N 1
#SBATCH -n 4


cp 34_*_csd.theta csd_all_pi.txt
 
for file in /data3/ssmith/ena/pi/{34..192}*_csd.pi; do
echo "$file"
paste /data3/ssmith/ena/pi/csd_all_pi.txt <(awk -F '\t' 'NR==1{print FILENAME; next} {print $5}' "$file") > /data3/ssmith/ena/pi/temp && mv -f
 /data3/ssmith/ena/pi/temp /data3/ssmith/ena/pi/csd_all_pi.txt
done
