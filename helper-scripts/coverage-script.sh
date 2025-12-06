#!/usr/bin/env bash

fasta_file='/data2/nletien2/Pbrachy-assembly/yahs/Pbrachy.yahs.out_scaffolds_final.fa'
read_lengths_file='/data2/nletien2/Pbrachy-assembly/analysis/hifi-read-lengths.txt'

#do not edit below this line
genome_length=$(cat ${fasta_file} | grep -v '>' | wc -c)
read_lengths_total=$(awk '{s+=$1} END {print s}' ${read_lengths_file})
echo $((read_lengths_total/1700000000))
