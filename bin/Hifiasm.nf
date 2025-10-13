process runHifiasm { 
    input:
    val species_id
    path hifi_reads
    path hic1
    path hic2

    output:
    path "${species_id}.hic.p_ctg.gfa", emit: p_gfa
    path "${species_id}.hic.hap1.p_ctg.gfa", emit: hap1_gfa
    path "${species_id}.hic.hap2.p_ctg.gfa", emit: hap2_gfa

    script:
    """
    hifiasm -t ${params.nthreads} \
    --h1 ${hic1} \
    --h2 ${hic2} \
    -o ${species_id} \
    ${hifi_reads} |& tee hifiasm.kmer.log
    """
}

process gfa2fa { 
    input:
    tuple val(meta_id), path(gfa_file)

    output:
    tuple val(meta_id), path("${meta_id}.fa"), emit: fasta_tuple

    script:
    """
    awk '/^S/{print ">"\$2;print \$3}' ${gfa_file} > ${meta_id}.fa
    """
}
