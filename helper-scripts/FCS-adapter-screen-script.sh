#!/usr/bin/env bash

#set variables and paths
sequence_file='/data2/nletien2/sample-assembly-practice/Pbrachy.hic.p_ctg.fa'

assembly_name='Pbrachy'

#Do not edit below this line
./run_fcsadaptor.sh --fasta-input ${sequence_file} --output-dir ${assembly_name}.FCS-adapter-screen --euk |& tee ${assembly_name}.fcs-adapter-screen.log