# Pool-seq_analysis_CSD_tajimasD
Scripts to analyse the nucleotide diversity of the CSD gene and genome wide tajimas D values

## Step one
First run ```population_measure.sh```. This uses Popoolation 1 to calculate multiple population parameters.

## Step two
Now run ```csd_filter.sh``` to focus on the CSD gene

## Step three
Combine all of the files using ```combine_files.sh```
Next we clean up this combined file with some sed. This will of course be different for you based on your filename structure. I am basically removing the
/data3/ssmith/ena/pi/ and _csd.theta from the column names. This could be done in the previous script by editing the FILENAME string but I find this easier.  
  
sed -i 's:/data3/ssmith/ena/pi/::g' csd_all_theta.txt  
sed -i 's:_csd.theta::g' csd_all_theta.txt  

## Step four
Make our plots for the CSD analysis using the ```csd_pi_analysis.R``` script

## Step five
Run ```TajimasD_window.sh``` to calculate Tajimas D for sliding windows over the whole genome to detect regions under selection.  
Combine the output files as we did earlier with the pi files.

## Step six
Use ```tajimasD_filtering.R``` to subset this combined D file based on the samples metadata  
e.g subset and get the average D of all pure honey bee colonies etc..
This script outputs csv files containing this information, we then use grep to keep only the locations 
that are on the main 16 chromosomes of the reference genome ```grep "LG" input_file.D > final_file_lg.csv  

# Step seven
We then create manhatten plots using ```plot_tajimas_D.py```
This creates 6 manhatten plots (wild, managed, treated, untreated, pure, hybrid)
