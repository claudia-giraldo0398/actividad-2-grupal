#!/bin/bash

echo "Usar la herramienta prefetch del SRA Toolkit para descargar los datos:"
prefetch SRR29325052

echo "Convertir el archivo SRA descargado a formato FASTQ:"
fasterq-dump SRR29325052

echo "Ejecutar FastQC para evaluar la calidad de las lecturas de RNA-Seq:"
fastqc SRR29325052_1.fastq SRR29325052_2.fastq

echo "Recortar las lecturas usando Trimmomatic o Cutadapt para eliminar adaptadores y bases de baja calidad:"
trimmomatic PE SRR29325052_1.fastq SRR29325052_2.fastq output_forward_paired.fq output_forward_unpaired.fq output_reverse_paired.fq output_reverse_unpaired.fq ILLUMINACLIP:/opt/trimmomatic/Trimmomatic-0.39/adapters/TruSeq3-PE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36

echo "Construir un índice a partir del archivo de secuencia del genoma de referencia Escherichia coli"
hisat2-build GCA_000005845.2_ASM584v2_genomic.fna genome_index

echo "Alinear las lecturas recortadas al genoma de referencia usando HISAT2:"
hisat2 -p 8 -x genome_index -1 output_forward_paired.fq -2 output_reverse_paired.fq -S output.sam

echo "Convertir el archivo SAM a un archivo BAM ordenado:"
samtools view -bS output.sam | samtools sort -o sorted_output.bam

echo "Usar StringTie o Cufflinks para ensamblar y cuantificar transcritos:"
stringtie sorted_output.bam -o genes.gtf

echo "Cuantificar genes y estimar la abundancia de transcritos"
stringtie -e -B -p 8 -G genes.gtf -o gene_abundances.gtf sorted_output.bam
