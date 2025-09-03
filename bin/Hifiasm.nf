process runHifiasm { 
    input:
    val species_id
    path hifi_reads
    path hic1
    path hic2

    output:
    path "${species_id}.p_ctg.gfa", emit: primary_gfa
    path "${species_id}.hap1.p_ctg.gfa", emit: hap1_gfa
    path "${species_id}.hap2.p_ctg.gfa", emit: hap2_gfa

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
    path gfa_file

    output:
    path "${gfa_file.getBaseName()}.fa"

    script:
    """
    awk '/^S/{print ">"\$2;print \$3}' ${gfa_file} > ${gfa_file.getBaseName()}.fa
    """
}