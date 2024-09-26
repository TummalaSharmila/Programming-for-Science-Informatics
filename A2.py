####question 1
#opening the sequence file in read mode with open()
with open('chr1_GL383518v1_alt.fa', 'r')as file:
    #removing the first line as it is the name of the sequence
    next(file)
    #reading the sequence into a string variable
    seq=file.read()
#removing the new line characters
seq=seq.replace("\n","")
#Print the 10th letter of this sequence.
print("10th letter of the sequence:",seq[9])
#Print the 758th letter of this sequence.
print("758th letter of the sequene: ", seq[757])


####question 2
#creating an empty string
revseq= ''
#creating a dictionary to substitute the base as per Watson-Crick-Franklin pair
revbase = {'a': 't', 'A':'T', 'g':'c', 'G':'C', 't':'a', 'T':'A','c':'g', 'C':'G' }
#writing a for loop to access each base from the end of the sequence and substitute it by passing it into the dictionary
for base in seq [::-1]:
  revseq += revbase[base]
#to print 79th letter of the sequence
print ("79th letter of reverse complementary DNA sequence:", revseq[78])
#to print the 500th through the 800th letters of this sequence.
print("letters from 500th letter to 800th letter of reverse complementary DNA sequence:", revseq[499:799])


####question 3
#converting all the lowercase letters to uppercase
seq= seq.upper()
def count_bases(seq):
    # creating an empty dictionary
    my_dict = {}

    # Iterate over the sequence for every 1000 nucleotides using step option in range function
    for i in range(0, len(seq), 1000):
        # taking key value as kilobase position
        kilobase = i

        # creating an empty dictionary for base and its count pair
        base_counts = {}

        # Extracting the current sub sequence of the DNA sequence
        subseq = seq[i:i+1000]

        # For each nucleotide (A, C, G, T)
        for nuc in "ACGT":
            # Counting the occurrences of the base in the current sub sequence using count()
            count = subseq.count(nuc)

            # Storing the count in the base_counts dictionary with the nuc as the key
            base_counts[nuc] = count

        # Storing the base_counts dictionary in the my_dict dictionary with the kilobase position as the key
        my_dict[kilobase] = base_counts

    # Return the my_dict dictionary
    return my_dict
my_dict= count_bases(seq)
print(my_dict)


####question 4a
#creating a list  with 4 elements, containing the number of times each nucleotide (A,C,G,T) is contained in the first 1000 base pairs.
base_counts=[my_dict[0]['A'],my_dict[0]['C'],my_dict[0]['G'],my_dict[0]['T']]
#printing the list created
print(base_counts)


#####question 4b
#Repeat question 4a for each kilobase contained in the dictionary
#using for loop to iterate through each kilobase
for i in my_dict:
  #appending the nucleotide count as a list
  base_count=[my_dict[i]['A'],my_dict[i]['C'],my_dict[i]['G'],my_dict[i]['T']]
  #printing the kilobase and list of 4 elements
  print (i,"=", base_count)


####question 4c
base_count_list=[]
for i in my_dict:
  base_count=[my_dict[i]['A'],my_dict[i]['C'],my_dict[i]['G'],my_dict[i]['T']]
  #saving the basecount of 4 nucleotides list in each kilobase as an element in base_count_list (list variable)
  base_count_list.append([base_count])
print (base_count_list)


###question 4d
#create a list to add sum of each list in base_count_list 
x=[]
for i in base_count_list:
#adding the sum of each list into the variable created
  x.append(sum(i[0]))


####question 4e
'''1. The expected answer is 1000 as the sum for each list since the sum is nothing but the total number of nucleotides for every 1000 nucleotides except for the last list  
2. no
3. here is my explanation for the deviation of sum of last list from the standard 1000
the sequence has 182439 nucleotides. since the step size is 1000 for creating the dictionary named my_dict, the last itertion only has 439 nucleotides left. We made a list from the same dictionary thus the sum of all nucleotide base count in the last list is 439'''

#to verify please use this code. I am mentioning as comments here
#print(len(seq))
#print(x)
