##*****************************
##Thomas Tekle - 1079669
##
##University of Guelph
##February 8, 2025
##
##Genomics for Bioinformatics - Assignment 1: Conducting PCA on RAD-seq data using vcf/plink generated eigen vector table with the Rochette and Catchens defined parameters and my own defined parameters in the population function found in stacks module.
##
##******************************

library(glue)
library(ggplot2)
library(ggpubr)
library(tidyverse)
library(stringr)

pca <- read.table("C:/Users/thoma/Desktop/PCA_data/pca_results.eigenvec", header = FALSE) %>% select(-V1)#Removing duplicate variable for samples

pca_new <- read.table("C:/Users/thoma/Desktop/PCA_data/pca_results_new.eigenvec", header = FALSE)%>% select(-V1)

colnamer <- function(data_frame){
    
 colnames(data_frame) <- c("Sample", "PC1", "PC2", "PC3", "PC4", "PC5", "PC6", "PC7", "PC8", "PC9", "PC10")
  
 return(data_frame)
}

pca <- colnamer(pca)
pca_new <- colnamer(pca_new)

pca.pop <- mutate(pca, Sample = as.factor(str_extract(Sample, "[a-z][a-z]+"))) #Removing sample identifiers, converting values to population identifier 

pca_new.pop <- mutate(pca_new, Sample = str_extract(Sample, "[a-z][a-z]+"))

pca_plotter <- function(data_frame, pc1, pc2, color_label, param_title) {
  ggplot(data_frame, aes(x = .data[[pc1]], y = .data[[pc2]], color = .data[[color_label]])) +
    geom_point(size = 4) +
    theme_minimal() +
    theme(plot.title = element_text(size=8)) +
    labs(title = glue("PCA Plot of RAD-seq Data of Three-spined Stickleback Sampled from Four Sites - {param_title}"),
         x = pc1, y = pc2)
}

pca_old <- pca_plotter(pca.pop, "PC1", "PC2", "Sample", "A. Using Paper's Parameters")

pca_new <- pca_plotter(pca_new.pop, "PC1", "PC2", "Sample", "B. Using new Parameters")

ggarrange(pca_old, pca_new)
