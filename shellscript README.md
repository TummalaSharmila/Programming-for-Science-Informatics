###**COURSE NAME AND CODE:** ###Programming for Science Informatics - B573

###**Programmer:** Sharmila Tummala

###**Script Language:** Unix, Bash shell

###**Bash version:** GNU bash, version 3.2.57(1) - release \(arm64-apple-darwin23\)

###**Description:** I am submitting a shell script that allows to procure all secondary assemblies for human chromosome 1 from University of California, Santa Cruz (UCSC) Genome browser \(all chromosome 1 assemblies except “chr1.fa.gz”\) at (https://hgdownload.soe.ucsc.edu/goldenPath/hg38/chromosomes/) and creates a data summary file which includes name of the assembly file, size, permissions, number of lines in the assembly file, first 10 lines in the file from all the chromosome 1 downloaded files. The purpose of the script is to access the chromosome sequence files and download them from UCSC genome browser, extract the required information and append it into a file. 

The commands used in this file and their purpose

* *cd \~* : navigate to home directory

* *mkdir Informatics_573* :  used to create directory

* *cd Informatics_573* : used to navigate to the specified directory
  
* *wget* is used to download files from a browser
we can download each file separately with this command or use optional flags and wildcards to download mutliple files at a time as shown in this script
  
*wget -r -np -nd -A 'chr1_\*' https://hgdownload.soe.ucsc.edu/goldenPath/hg38/chromosomes/*
  in this script 3 optional flags \(-r, -nd, -A\) are used to customize downloading 
  The "recursive" option (-r) instructs wget to download all files recursively. 
  "No directory" is represented by the option -nd, which instructs wget not to build a directory structure when downloading files. 
  The kinds of files that will be downloaded are specified by -A option. "Accept" is represented by A.

* *gunzip chr1_\** command is used to unzip the downloaded files
  
* *touch data_summary.txt* is used to create an empty text file
  
* *ls -l >> data_summary.txt* ls -l gives information \(size, name, permissions etc\) of all the files in the directory and  \'>>' is used to append the result of this command to data_summary.txt file
  
*  *head >> data_summary.txt* is used to append first 10 lines of the files into summary text file
  
*  *wc -l >> data_summary.txt* is used to append number of lines and name of each file present in the directory
  
*  *cat >> data_summary.txt* is used to display all the information present in the data_summary.txt file



