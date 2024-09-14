# Navigate to the user’s home directory
cd ~

#To create the directory titled “Informatics_573”
mkdir Informatics_573

#naviagting to Informatics_573
cd Informatics_573

#downloading all secondary assemblies for human chromosome 1 except "chr1.fa.gz"
wget -r -np -nd -A 'chr1_*' https://hgdownload.soe.ucsc.edu/goldenPath/hg38/chromosomes/

#unzipping the files downloaded
gunzip chr1_*

# using touch command to create a new empty file with the name "data_summary.txt"
touch data_summary.txt

#Appending the list of the all detailed information (including file name, size in bytes, date and time the file last modified and permissions) of chromosome 1 assembly fles to “data_summary.txt”
ls -l >> data_summary.txt
#appending first 10 lines of each chromosome assembly files to data_summary.txt
head chr1_* >> data_summary.txt
#appending the name of assembly and the number of lines in each file to data_summary.txt
wc -l chr1_*>> data_summary.txt
#to display the contents of data_summary.txt file
cat data_summary.txt
