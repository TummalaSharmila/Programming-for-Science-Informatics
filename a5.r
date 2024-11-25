install.packages("readxl")
install.packages("dplyr")
install.packages("tidyr")

# 1a
# Loading the libraries
library(readxl) # to read the excel file
library(dplyr) # to manipulate data
library(tidyr) # for reshaping the data

# Loading all the three files 
gene_expression_data <- read_excel("/Users/sharmilatummala/Documents/Programming/data files/Gene_Expression_Data (1).xlsx")
gene_information <- read.csv("/Users/sharmilatummala/Documents/Programming/data files/gene_information (1).csv")
sample_information <- read.table("/Users/sharmilatummala/Documents/Programming/data files/Sample_Information (1).tsv")

#1b Changing the sample names from the “Gene_Expression_Data.xlsx”, based upon the phenotype presented in “Sample_Information.tsv”
# Extract the phenotype part of the group names (before the first space)
phtype <- gsub("\\s.*", "", sample_information$group)
# Combine phenotype and sample names to create new column names
changed_column_names <- paste0(phtype, '_', colnames(gene_expression_data)[-1])
# Assign the new column names to the gene expression data, excluding the first column
colnames(gene_expression_data)[-1] <- changed_column_names
colnames(gene_expression_data)[-1] <- changed_column_names
# Print the updated gene expression data to verify changes
print(gene_expression_data)

#1c Splitting the merged data into two parts based upon their labeled phenotype
# Extract columns with names starting with 't' (tumor)
tumor_data <- gene_expression_data[, grepl("^t", colnames(gene_expression_data))]
# Extract columns with names starting with 'n' (normal)
normal_data <- gene_expression_data[, grepl("^n", colnames(gene_expression_data))]
# Display the first few rows of the tumor data
head(tumor_data)
# Display the first few rows of the normal data
head(normal_data)


#1d Computing the average expression for each probe from the two data sets
# Calculate the row-wise mean for the tumor samples (exclude Probe_ID)
tumoraverages <- rowMeans(tumor_data[, -1])
# Calculate the row-wise mean for the normal samples (exclude Probe_ID)
normalaverages <- rowMeans(normal_data[, -1])
# Display the first few values of the average tumor expression
head(tumoraverages)
# Display the first few values of the average normal expression
head(normalaverages)
print(tumoraverages)

#1e Determining the fold change for each probe between the two groups
# Calculate the fold change (tumor / normal)
fold_change <- (tumoraverages - normalaverages) / normalaverages
# Print the fold change for each probe
fold_change


#1f Filtering genes with a fold change greater than 5
# Create a data frame with fold change values
Foldchangedf <- data.frame(Index = 1:length(fold_change),fold_change = fold_change)
# Filter to keep only those with an absolute fold change greater than 5
Foldchangedf <- Foldchangedf[abs(Foldchangedf$fold_change) > 5,]


#1g Creating a new data frame with fold change and categorizing genes based on higher expression
# Create a new data frame with fold change and probe IDs
newdf <- data.frame(Probe_ID = gene_expression_data$Probe_ID, fold_change = fold_change)
# Categorize genes as having higher expression in tumor or normal based on fold change
newdf$Higher_Expression <- ifelse(newdf$fold_change > 0, "Tumor", "Normal")
# Merge with gene info to add chromosome information
newdf <- merge(newdf, gene_information[, c("Probe_ID", "Chromosome")], by = "Probe_ID", all.x = TRUE)
# Print the filtered data
print(Foldchangedf)
# Print the fold change gene data with chromosome information
print(newdf)

#2b Create a histogram showing the distribution of DEGs by chromosome
library(ggplot2) # Load ggplot2 for creating the plot
# Remove NA values from the Chromosome column
deg_chromosomes <- na.omit(newdf$Chromosome)  

# Create histogram
ggplot(data.frame(Chromosome = deg_chromosomes), aes(x = Chromosome)) +
  # Create a histogram with count of DEGs by chromosome
  geom_histogram(stat = "count", fill = "pink", color = "black") +
  # Apply a minimal theme to the plot
  theme_minimal() +
  # Add title and axis labels
  labs(title = "Distribution of DEGs by Chromosome", x = "Chromosome", y = "Number of DEGs")+
  theme(axis.text.x = element_text(angle = 90, hjust = 1))  # Tilt x-axis labels to a right angle


#2c
# Create a new column for Sample Type
newdf$Sample_Type <- ifelse(newdf$Higher_Expression == "Tumor", "Tumor", "Normal")

# Filter DEGs with fold change greater than a threshold
new_deg <- newdf[abs(newdf$fold_change) > 1,]

# Create histogram segregated by Sample_Type
ggplot(new_deg, aes(x = Chromosome, fill = Sample_Type)) +
  geom_histogram(stat = "count", position = "dodge", color = "black") +
  theme_minimal() +
  labs(title = "DEGs by Chromosome and Sample Type", x = "Chromosome", y = "Number of DEGs") +
  scale_fill_manual(values = c("Normal" = "lightblue", "Tumor" = "yellow"))


#2d
# Count the number of upregulated and downregulated genes
upregulated <- sum(newdf$Higher_Expression == "Tumor" & newdf$fold_change > 0)
downregulated <- sum(newdf$Higher_Expression == "Normal" & newdf$fold_change < 0)

# Create bar chart
deg_counts <- data.frame(
  Expression = c("Upregulated", "Downregulated"),
  Count = c(upregulated, downregulated)
)

ggplot(deg_counts, aes(x = Expression, y = Count, fill = Expression)) +
  geom_bar(stat = "identity", color = "black") +
  theme_minimal() +
  labs(title = "Upregulated vs Downregulated DEGs in Tumor Samples", x = "Expression", y = "Count") +
  scale_fill_manual(values = c("Upregulated" = "green", "Downregulated" = "red"))

#2e
install.packages("pheatmap")
library(pheatmap)

# Subset gene expression data (without Probe_ID column)
gene_expression_matrix <- as.matrix(gene_expression_data[,-1])

# Generate heatmap
pheatmap(gene_expression_matrix, scale = "row", clustering_distance_rows = "euclidean", clustering_distance_cols = "euclidean",
         clustering_method = "complete", show_rownames = FALSE, show_colnames = FALSE, 
         color = colorRampPalette(c("orange", "pink", "yellow"))(100), 
         main = "Heatmap of Gene Expression by Sample")

#2f
# Create clustermap (similar to heatmap but with hierarchical clustering)

# Load pheatmap library
library(pheatmap)

# Create the clustermap in R
pheatmap(gene_expression_matrix, 
         scale = "row", 
         clustering_distance_rows = "euclidean", 
         clustering_distance_cols = "euclidean",
         clustering_method = "complete", 
         show_rownames = FALSE, 
         show_colnames = FALSE, 
         color = colorRampPalette(c("green", "black", "blue"))(100), 
         main = "Clustermap of Gene Expression")

#2g.Write a few sentence explaining the findings of your analysis, feel free to reference any of visualizations
#The chromosomal distribution patterns are better understood by the histograms that display the distribution of differentially expressed genes by chromosome—both tumor and normal—and by sample type. Greater frequencies of differently expressed genes were found on several chromosomes, suggesting potential genetic regions connected to the symptoms reported. A considerable frequency of upregulated genes was shown in the bar chart representing the percentages of upregulated and downregulated genes in tumor samples, suggesting a potential gene regulatory mechanism influencing the tumor phenotype.
#Furthermore, it was feasible to discover clusters of co-expressed genes and samples thanks to the heatmap and clustermap visualizations, which offered clear views of gene expression patterns across samples.




