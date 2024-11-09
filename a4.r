#### Question 1
# Opening the sequence file in read mode and reading the content
file_conn <- file("/Users/sharmilatummala/Documents/Programming/chr1_GL383518v1_alt.fa", "r")
seq <- readLines(file_conn)[-1]  # Remove the first line (sequence name)
close(file_conn)
seq <- paste(seq, collapse = "")  # Remove newline characters

# Print the 10th letter of this sequence
cat("10th letter of the sequence:", substr(seq, 10, 10), "\n")

# Print the 758th letter of this sequence
cat("758th letter of the sequence:", substr(seq, 758, 758), "\n")


#### Question 2
# Creating reverse complementary sequence
revseq <- ""
revbase <- list('a' = 't', 'A' = 'T', 'g' = 'c', 'G' = 'C', 't' = 'a', 'T' = 'A', 'c' = 'g', 'C' = 'G')

# Split the sequence into individual characters
seq_split <- strsplit(seq, NULL)[[1]]

# Reverse the sequence and map each base to its complement
revseq <- paste(sapply(seq_split[length(seq_split):1], function(base) revbase[[base]]), collapse = "")

# Print the 79th letter of the reverse complementary sequence
cat("79th letter of reverse complementary DNA sequence:", substr(revseq, 79, 79), "\n")

# Print the 500th through the 800th letters of the reverse complementary sequence
cat("Letters from 500th to 800th of reverse complementary DNA sequence:", substr(revseq, 500, 800), "\n")


#### Question 3
# Convert all lowercase letters to uppercase
seq <- toupper(seq)

# Define function to count bases in each kilobase (1000 base pairs)
count_bases <- function(seq) {
  my_dict <- list()  # Initialize empty list to store kilobase position and base counts
  
  # Loop through each kilobase of the sequence
  for (i in seq(1, nchar(seq), by = 1000)) {
    kilobase <- (i - 1) /1000
    subseq <- substr(seq, i, min(i + 999, nchar(seq)))  # Extract the current 1000 base pair segment
    
    # Count occurrences of each base (A, C, G, T) in the current segment
    base_counts <- sapply(c("A", "C", "G", "T"), function(nuc) {
      sum(unlist(strsplit(subseq, NULL)) == nuc)
    })
    
    # Store the base counts in the dictionary with the kilobase position as the key
    my_dict[[as.character(kilobase)]] <- base_counts
  }
  
  return(my_dict)
}

# Count bases per kilobase in sequence
my_dict <- count_bases(seq)
print(my_dict)


#### Question 4a
# Create a list with base counts for the first 1000 base pairs
base_counts <- my_dict[["0"]]
print(base_counts)


#### Question 4b
# Iterate through each kilobase and print nucleotide count as a list
for (i in names(my_dict)) {
  base_count <- my_dict[[i]]
  cat(i, "=", base_count, "\n")
}


#### Question 4c
# Create a list to store base counts for each kilobase
base_count_list <- lapply(names(my_dict), function(i) list(my_dict[[i]]))
print(base_count_list)


#### Question 4d
# Calculate the sum of each base count list in base_count_list
x <- sapply(base_count_list, function(base_count) sum(unlist(base_count)))



#### Question 4e
# Explanation of the expected sum
cat("The expected answer is 1000 as the sum for each list, as this is the total number of nucleotides for every 1000 nucleotides, except for the last list, which has fewer nucleotides if the total length is not divisible by 1000.\n")

# To verify, run the following lines (uncomment if needed)
#cat("Total length of sequence:", nchar(seq), "\n")
#print(x)


