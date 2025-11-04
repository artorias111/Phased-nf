#!/usr/bin/env bash

# set all your variables
# make sure you use the absolute path, not relative paths in your scripts
reads='/data2/nletien2/Zoarcid-hifi-files/Pbrachy_Revio_hifi/m84221_240830_191904_s2.Pbra1.398_398.fastq.gz'

hic_read1='/data2/nletien2/Zoarcid-hic-files/Pbrachy1_HiC_data/Pbra1_GGTTAGCT-GTACCACA_L004_R1_001.fastq.gz'
hic_read2='/data2/nletien2/Zoarcid-hic-files/Pbrachy1_HiC_data/Pbra1_GGTTAGCT-GTACCACA_L004_R2_001.fastq.gz' 

num_threads=18

assembly_name='Pbrachy'

### Do not edit below this line

hifiasm -o ${assembly_name} -t ${num_threads} --h1 ${hic_read1} --h2 ${hic_read2} ${reads} |& tee ${assembly_name}.hifiasm.log