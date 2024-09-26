COURSE NAME AND CODE: Programming for Science Informatics - B573
Programmer: Sharmila Tummala
Date: 09/14/2024

Script Language:
Unix, Bash shell

Bash version:
GNU bash, version 3.2.57(1) - release (arm64-apple-darwin23)

Description:
I am submitting a shell script that allows procuring all secondary assemblies for human chromosome 1 from the University of California, Santa Cruz (UCSC) Genome Browser (all chromosome 1 assemblies except “chr1.fa.gz”) at (https://hgdownload.soe.ucsc.edu/goldenPath/hg38/chromosomes/) and creates a data summary file which includes the name of the assembly file, size, permissions, number of lines in the assembly file, first 10 lines in the file from all the chromosome 1 downloaded files. The script aims to access and download the chromosome sequence files from the UCSC genome browser, extract the required information, and append it into a file.

The commands used in this file and their purpose

cd ~: navigate to the home directory.

mkdir Informatics_573: used to create directory named Informatics_573.

cd Informatics_573: used to navigate to the specified directory.

wget is used to download files from a browser we can download each file separately with this command or use optional flags and wildcards to download multiple files at a time as shown in this script.

wget -r -np -nd -A 'chr1_*' https://hgdownload.soe.ucsc.edu/goldenPath/hg38/chromosomes/ in this script 3 optional flags (-r, -nd, -A) are used to customize downloading The "recursive" option (-r) instructs wget to download all files recursively. "No directory" is represented by the option -nd, which instructs wget not to build a directory structure when downloading files. The kinds of files that will be downloaded are specified by -A option. "Accept" is represented by A.

gunzip chr1_* command is used to unzip the downloaded files.

touch data_summary.txt is used to create an empty text file.

ls -l >> data_summary.txt ls -l gives information (size, name, permissions, etc) of all the files in the directory and '>>' is used to append the result of this command to the data_summary.txt file.

head >> data_summary.txt is used to append the first 10 lines of the files into the summary text file.

wc -l >> data_summary.txt is used to append number of lines and name of each file present in the directory.

cat >> data_summary.txt is used to display all the information present in the data_summary.txt file.

Files needed:
you need bash shell to run this script

Packages needed:
make sure you have wget installed prior to running my script.

How to run my script
download the shatumma.sh script to your local system
open the terminal and navigate to the directory which contains this script
make sure this file is executable with command " chmod +x shatumma.sh"
enter "./shatumma.sh" to run the script.
NOTE:
The script will download 21 chromosome sequence files and creates a data summary text file with first 10 lines, size, name, permissions, and no.of lines of each downloaded file.
