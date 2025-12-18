#!/usr/bin/env bash

#set variables and paths
sequence_file='/data2/nletien2/Pbrachy-assembly/hifiasm-assembly/Pbrachy.hic.p_ctg.gfa'
assesment_mode='geno'
lineage_dataset='actinopterygii_odb12'
database_path='/data2/busco_June2024/busco_downloads'

num_threads=16

assembly_name='Pbrachy'

#Do not edit below this line
busco -o ${assembly_name}.busco -i ${sequence_file} -m ${assesment_mode} -l ${lineage_dataset} --download_path ${database_path} -c ${num_threads} --offline |& tee ${assembly_name}.busco.log