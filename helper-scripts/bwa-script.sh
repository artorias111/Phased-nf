#!/usr/bin/env bash

#set variables and paths
reference_genome='/data2/nletien2/cont.clean.fasta'
R1_file='/data2/nletien2/Zoarcid-hic-files/Pbrachy1_HiC_data/Pbra1_GGTTAGCT-GTACCACA_L004_R1_001.fastq.gz'
R2_file='/data2/nletien2/Zoarcid-hic-files/Pbrachy1_HiC_data/Pbra1_GGTTAGCT-GTACCACA_L004_R2_001.fastq.gz'

number_of_threads=16
assembly_name='Pbrachy'
tool_path='/data2/nletien2/tools/bwa-mem2-2.2.1_x64-linux/bwa-mem2'

#do not edit below this line
${tool_path} index -p ${assembly_name}.index ${reference_genome}
${tool_path} mem -t ${number_of_threads} -o ${assembly_name}.bwa-mem2.sam ${assembly_name}.index <(zcat ${R1_file}) <(zcat ${R2_file}) |& tee ${assembly_name}.hic.sam.log