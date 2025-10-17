genome_length=$(cat Pbrachy.hic.p_ctg.fa | wc -c)
read_lengths_total=$(awk '{s+=$1} END {print s}' hifi-read-lengths.txt)
echo $((read_lengths_total/genome_length))
