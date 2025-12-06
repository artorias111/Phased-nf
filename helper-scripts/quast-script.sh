#!/usr/bin/env bash

#set variables and paths
sequence_file='/data2/nletien2/Pbrachy-assembly/yahs/Pbrachy.yahs.out_scaffolds_final.fa'

assembly_name='Pbrachy'
num_threads=18


#do not edit below this line
quast -o ${assembly_name}.quast -t ${num_threads} ${sequence_file} |& tee ${assembly_name}.quast.log