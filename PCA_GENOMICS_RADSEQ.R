##*****************************
##Thomas Tekle - 1079669
##
##University of Guelph
##February 8, 2025
##
##Genomics for Bioinformatics - Assignment 1: Conducting PCA on RAD-seq data using vcf/plink generated eigen vector table
##
##******************************

library(ggplot2)
library(tidyverse)
library(stringr)

pca <- read.table("C:/Users/thoma/Desktop/PCA_data/pca_results.eigenvec", header = FALSE) %>% select(-V1)#Removing duplicate variable for samples

colnames(pca) <- c("Sample", "PC1", "PC2", "PC3", "PC4", "PC5", "PC6", "PC7", "PC8", "PC9", "PC10")#Adding column names 

pca.pop <- mutate(pca, Sample = str_extract(Sample, "[a-z][a-z]+"))#Removing sample identifiers, converting values to population identifier 

#Plotting first two principle components, labeling by populations 
ggplot(pca.pop, aes(x=PC1, y=PC2, color=Sample)) +
  geom_point(size=5) +
  theme_minimal() +
  labs(title="PCA Plot of RAD-seq Data", x="PC1", y="PC2")
