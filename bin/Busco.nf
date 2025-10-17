process runBusco {
    conda params.busco_conda
    publishDir "${params.outdir}/busco", mode: 'symlink'

    input:
    tuple val(asm_name), path(genome_asm)

    output:
    path "${params.specimen_id}.${asm_name}.busco", emit :busco_results

    script:
    """
    busco -o ${params.specimen_id}.${asm_name}.busco \
    -i ${genome_asm} \
    -m geno \
    -l ${params.busco_lineage} \
    --download_path ${params.busco_db_path} \
    -c ${params.nthreads} \
    --offline
    """
}
