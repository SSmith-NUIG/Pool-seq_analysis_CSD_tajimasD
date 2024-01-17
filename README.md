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
