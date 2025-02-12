#Thomas Tekle
#Binf Genomics Assignment 1
#Conducting sequence alignments and population-relevant variant calling on population of Three-spined sickleback fish
#Conducted on the Digital Alliance Cedar cluster under Dr. Lewis Lukens' group 

#Retrieving most recent version of fish genome
wget https://ftp.ensembl.org/pub/release-113/fasta/gasterosteus_aculeatus/dna/Gasterosteus_aculeatus.GAculeatus_UGA_version5.dna.toplevel.fa.gz 

#Unzipping raw FastQ sample files, located in the Raw_files directory
gunzip *.fq.gz

#Initializing BWA alignment tools
module load bwa/0.7.18

#Indexing Genome 
bwa index Gasterosteus_aculeatus.GAculeatus_UGA_version5.dna.toplevel.fa.gz

#Iteratively conducting alignment of all samples on reference genome and renaming each file with .sam suffix using for loop, these files are stored in the Sam_files directory 
for file in *.fq;do name=$(echo "$file" | sed 's/\.fq/\.sam/'); bwa mem ../Gasterosteus_aculeatus.GAculeatus_UGA_version5.dna.toplevel.fa "$file" > "$name"

#Initializing samtools 
module load samtools/1.20

#Converting sam files to bam and sorting entries using samtools, these files are stored in the Sorted_bam_files directory
for i in *.sam; do samtools view -b "$i" > "${name}.bam"; samtools sort "${name}.bam" -o "${name}.sorted.bam"; done

#Initializing stacks tool suite
module load StdEnv/2023
module load stacks 

#Creating population map for use in gstacks tool
ls | sed 's/\.sorted/\.bam/' | awk -F '_' '{print $0 "\t" $1}  > popmap.tsv 

#Running gstacks variant calling on all sorted bam files using the created population map
gstacks -I /home/ttguelph/scratch/Raw_files/Assignment_1/Sorted_bam_files -M /home/ttguelph/scratch/Raw_files/Assignment_1/Sorted_bam_files/popmap.tsv -O /home/ttguelph/scratch/Raw_files/Assignment_1/gstacks_output/

#Converting gstacks ouput files into vcf file for subsequent PCA using parameters defined by Rochette and Catchen (2017). 
populations -P ../gstacks_output/ -M popmap.tsv --vcf -r 0.8 -p 2 --min-maf 0.05 --max-obs-het 0.70 -O /populations_output/ 

#Producing principle components from vcf file using Vcftools and plink
vcftools --vcf /home/ttguelph/scratch/Raw_files/Assignment_1/populations_output/populations.snps.vcf --plink --out /home/ttguelph/scratch/Raw_files/Assignment_1/PCA_data/pca_data
plink --file pca_data --make-bed --out pca_plink 
plink --bfile pca_plink --pca 10 --out pca_results

#Producing vcf file for PCA using altered -r paramter value
populations -P /home/ttguelph/scratch/Raw_files/Assignment_1/gstacks_output/ -M popmap.tsv --vcf -r 0.5 -p 2 --min-maf 0.05 --max-obs-het 0.70 -O /home/ttguelph/scratch/Raw_files/Assignment_1/new_params/vcf_files_new/  

#Producing principle components from vcf using new paramter
vcftools --vcf /home/ttguelph/scratch/Raw_files/Assignment_1/populations_output/populations.snps.vcf --plink --out /home/ttguelph/scratch/Raw_files/Assignment_1/PCA_data/pca_data_new 
plink --file pca_data_new --make-bed --out pca_plink_new
plink --bfile pca_plink_new --pca 10 --out pca_results_new

#Creating new popmap to produce fstat files, as done in the paper by Rochette and Catchen (2017).
cat popmap.tsv | sed -r 's/\t(cs|sj)/\toceanic/; s/\t(pcr|wc)/\tfreshwater/;' > popmap.oceanic_freshwater.tsv

#Producing fstat files with populations command, using parameters defined by Rochetter and Catchen (2017).
populations -P /home/ttguelph/scratch/Raw_files/Assignment_1/gstacks_output/ -M /home/ttguelph/scratch/Raw_files/Assignment_1/fstats_analysis/popmap.oceanic_freshwater.tsv -O /home/ttguelph/scratch/Raw_files/Assignment_1/fstat_files/ -p 2 -r 0.8 --min-maf 0.05 --fstats -k --sigma 100000 > /home/ttguelph/scratch/Raw_files/Assignment_1/fstat_files/pops.oceanic_freshwater.oe

#Producing fstat files with population command, using new parameter
populations -P /home/ttguelph/scratch/Raw_files/Assignment_1/gstacks_output/ -M /home/ttguelph/scratch/Raw_files/Assignment_1/fstats_analysis/popmap.oceanic_freshwater.tsv -O /home/ttguelph/scratch/Raw_files/Assignment_1/new_params/fstat_files_new/ -p 2 -r 0.5 --min-maf 0.05 --fstats -k --sigma 100000 > pops.oceanic_freshwater.oe

#From this pipeline, the pca_results.eigenvec and pca_results_new.eigenvec files were used to visualize the PCA clustering of the different populations in R, while the Fstats files pop_new.fst_oceanic-freshwater.tsv and populations.fst_oceanic-freshwater.tsv were used to evaluate the level of variation between the groups across all chromosomes available

#References:

#Rochette, N. C., & Catchen, J. M. (2017). Deriving genotypes from RAD-seq short-read data using Stacks. Nature Protocols, 12(12), 2640–2659. https://doi.org/10.1038/nprot.2017.123
