##*****************************
##Thomas Tekle - 1079669
##
##University of Guelph
##Genomics for Bioinformatics - Assignment 1: Conducting Evaluation of Fst - Statistic across all chromosomes with the Rochette and Catchens defined parameters and my own defined parameters in the population function found in stacks module.
##
##February 11, 2025
##
##******************************

library(ggplot2)
library(glue)
library(stringr)
library(ggpubr)

fstat_old <-  read.delim('C:/Users/thoma/Desktop/pop_test.fst_oceanic-freshwater.tsv')

fstat_new <- read.delim('C:/Users/thoma/Desktop/populations_new.fst_oceanic-freshwater.tsv')

scaffold_remover <- function(data_frame){
  
  data_frame <- subset(data_frame, !grepl("JACD+", Chr, ignore.case = T))
  
  return(data_frame)
}

fstat_old <- scaffold_remover(fstat_old)
fstat_new <- scaffold_remover(fstat_new)

fstat_plotter  <- function(data_frame, parameters){
ggplot(data_frame, aes(x=Chr, y=Smoothed.AMOVA.Fst, fill=Chr)) +
     geom_violin(trim=F) +
     labs(title= glue("Distribution of FST Values Across Chromosomes - {parameters}")) +
    xlab('Chromosomes')+
    ylab('Degree of variation - Smoothed ANOVA FST values')+
     theme_minimal()+
    theme(plot.title = element_text(size =8))+
    guides(fill = guide_legend(ncol = 1))
}

fstat_old_plot <- fstat_plotter(fstat_old, "Using Paper Derived Parameters")
fstat_new_plot <- fstat_plotter(fstat_new, "Using my own Paramters")

ggarrange(fstat_old_plot,fstat_new_plot)
                   