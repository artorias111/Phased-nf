#!/usr/bin/env bash

#set variables and paths
fasta_file='/data2/nletien2/Pbrachy-assembly/cont.clean.fasta'
bam_file='/data2/nletien2/Pbrachy-assembly/samblaster/Pbrachy.sam.out.bam'

PATH="$PATH:/data2/nletien2/tools/yahs"

number_of_threads=16
assembly_name='Pbrachy'

#do not edit below this line
yahs -o ${assembly_name}.yahs.out ${fasta_file} ${bam_file} |& tee ${assembly_name}.yahs.log