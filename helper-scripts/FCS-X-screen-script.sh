#!/usr/bin/env bash

#set variables and paths
sequence_file='/data2/nletien2/sample-assembly-practice/Pbrachy.hic.p_ctg.fa'
tax_id=36221
database_path='/data2/FCS_dbs/gxdb'

assembly_name='Pbrachy'

#Do not edit below this line
python3 fcs.py screen genome --fasta ${sequence_file} --out-dir ${assembly_name}.FCSX-screen --gx-db ${database_path} --tax-id ${tax_id} |& tee ${assembly_name}.FCSX-screen.log
