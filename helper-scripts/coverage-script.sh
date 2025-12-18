
#!/usr/bin/env bash

genome_length=1427880000
read_lengths_file='/data2/nletien2/Pbrachy-assembly/analysis/hifi-read-lengths.txt'

#do not edit below this line
read_lengths_total=$(awk '{s+=$1} END {print s}' ${read_lengths_file})
coverage=$((read_lengths_total / genome_length))
echo ${coverage}

