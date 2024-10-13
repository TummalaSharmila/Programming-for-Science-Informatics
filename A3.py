#1a. Load the data in “Gene_Expression_Data.xlsx”, “Gene_Information.csv”, and “Sample_Information.tsv” into Python
# importing pandas package
import pandas as pd
#importing numpy package
import numpy as np
#loading the data in the 3 files into data frames
sample_information = pd.read_csv('/content/drive/MyDrive/Colab Notebooks/Sample_Information.tsv', sep='\t')
gene_information = pd.read_csv('/content/drive/MyDrive/Colab Notebooks/Gene_Information.csv')
gene_expression_data = pd.read_excel('/content/drive/MyDrive/Colab Notebooks/Gene_Expression_Data.xlsx')

#1b.Change the sample names from the “Gene_Expression_Data.xlsx”, based upon the phenotype presented in “Sample_Information.tsv” (you can keep unique column names by adding a suffix like "_1", "_2" etc)
#creating a series to retrieve Probe_ID column in gene_expression_data
sampleId=gene_expression_data['Probe_ID']
#removing the Probe_ID from the gene_expression_data data frame
gene_expression_data.drop("Probe_ID", axis=1, inplace=True)
#retrieving group column from the sample_information data frame
phtype = sample_information["group"]
#changing sample name based on the phenotype   
changed_col_names = [group + '_' + str(col) for col, group in enumerate(phtype, start=1)]
gene_expression_data.columns = changed_col_names
#inserting the Probe_ID in the gene_expression_data data frame
gene_expression_data.insert(0,'Probe_ID',sampleId)
print(gene_expression_data)

#1c. Split the merged data from part b, into to 2 parts, based upon their labeled phenotype (ie. tumor or normal)

col=gene_expression_data.columns
length=len(col)
#creating two dataframes to split the data based on tumor or normal label
tumordataframe=pd.DataFrame()
normaldataframe=pd.DataFrame()
#x variable indicates each value in the col 
for x in col:
    if x[0]=='t':
        tumordataframe[x]=gene_expression_data[x]
    if x[0]=='n':
        normaldataframe[x]=gene_expression_data[x]
tumordataframe.insert(0,'Probe_ID',sampleId)
print(tumordataframe)
normaldataframe.insert(0,'Probe_ID',sampleId)
print(normaldataframe)

#1d. Compute the average expression for each probe from the 2 data sets from part c
#using mean method to calculate the average expression 
tumoraverages=tumordataframe.iloc[:,1:].mean(axis=1)
print(tumoraverages)
normalaverages=normaldataframe.iloc[:,1:].mean(axis=1)
print(normalaverages)

#1e. Determine the fold change for each probe between the two groups ((Tumour – Control) / Control)
foldchange=(tumoraverages-normalaverages)/normalaverages
print(foldchange)

#1f. Use the data from part e and “Gene_Information.csv” to identify all genes fold change magnitude (absolute value) was greater than 5
table=pd.DataFrame(foldchange)
table.columns=['foldchange']
identified_data = table[table['foldchange'] > 5]
i=identified_data.index.tolist()
identified_data = identified_data.reset_index().rename(columns={'index': 'Index'})
print(identified_data)

#1g. Add a column to the result of part f to include if the gene was higher expressed in “Normal” or “Tumor” samples
expression = pd.DataFrame({'Probe_ID': gene_information['Probe_ID'], 'Fold_Change': foldchange})
expression['Higher_Expression'] = np.where(expression['Fold_Change'] > 0, 'Tumor', 'Normal')
expression = pd.merge(expression, gene_information[['Probe_ID', 'Chromosome']], on='Probe_ID', how='left')
expression

#2a. Perform exploratory data analysis on the genes from part 1g
print(expression['Fold_Change'].describe())
print(expression['Higher_Expression'].value_counts())
import seaborn as sns
import matplotlib.pyplot as plt

sns.histplot(expression['Fold_Change'], bins=40)
plt.title('Distribution of Fold Change')
plt.xlabel('Fold Change')
plt.ylabel('Frequency')
plt.show()
print(expression['Chromosome'].value_counts())

#2b. histogram showing the distribution of the number of differentially expressed genes (DEGs) by chromosome
# Plot the histogram
DEG_vs_chromosome = expression.groupby('Chromosome').size()
DEG_vs_chromosome.plot(kind='bar', figsize=(10,6))
plt.title('No.of DEG by Chromosome')
plt.xlabel('CHROMOSOME')
plt.ylabel('FREQUENCY')
plt.xticks(rotation=45)
plt.show()

#2c. histogram showing the distribution of DEGs by chromosome segregated by sample type (Normal or Tumor)
normal = expression[expression['Higher_Expression'] == 'Normal']
tumor = expression[expression['Higher_Expression'] == 'Tumor']
plt.figure(figsize=(12, 6))
plt.hist(tumor['Chromosome'].astype(str), color='red', label='Tumor', bins=20, alpha=0.7)
plt.hist(normal['Chromosome'].astype(str), color='green', label='Normal', bins=20, alpha=0.5)
plt.title('Distribution of DEGs by Chromosome segregated by sample type (Normal or Tumor)')
plt.xlabel('CHROMOSOME')
plt.ylabel('FREQUENCY')
plt.xticks(rotation=90)
plt.legend(title='Higher Expression')
plt.show()

#2d. bar chart showing the percentages of the DEGs that are upregulated (higher) in Tumor samples and down regulated (lower) in Tumor samples
upregulated_percentage = (expression[expression['Higher_Expression'] == 'Tumor'].shape[0] / expression.shape[0]) * 100
downregulated_percentage = 100 - upregulated_percentage
plt.bar(['Upregulated', 'Downregulated'], [upregulated_percentage, downregulated_percentage], color=['grey', 'yellow'])
plt.xlabel('Gene Expression')
plt.ylabel('Percentage')
plt.title('Percentage of DEGs Upregulated and Downregulated in Tumor Samples')
plt.show()

#2e. Using the raw data from part 1b to create a heatmap visualizing gene expression by sample
import seaborn as sns
plt.figure(figsize=(12, 8))
sns.heatmap(gene_expression_data.set_index('Probe_ID'), cmap='turbo')  # Create heatmap
plt.title('Heatmap of Gene Expression by Sample')
#plt.savefig('gene_expression_heatmap.png')
plt.show()

#2f. Using the same data from the previous part to create a clustermap visualizing gene expression by sample
gene_expression_data_cluster = gene_expression_data.drop("Probe_ID", axis=1)
sns.clustermap(gene_expression_data_cluster, cmap="magma", figsize=(10, 8))
plt.tight_layout()
plt.show()

