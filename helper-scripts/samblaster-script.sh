#!/usr/bin/env bash

#set variables and paths
aligned_file="/data2/nletien2/Pbrachy-assembly/bwa/Pbrachy.bwa-mem2.sam"

number_of_threads=16
assembly_name='Pbrachy'

#do not edit below this line
${aligned_file} | samblaster | samtools view -Sb - > ${assembly_name}.sam.out.bam