process runBusco {
    conda params.busco_conda
        
    publishDir { "${params.outdir}/${asm_name}_busco_results" }, mode: 'symlink'

    input:
    tuple val(asm_name), path(genome_asm)

    output:
    path "${asm_name}_BUSCO", emit :busco_results

    script:
    """
    busco -o ${asm_name}_BUSCO \
    -i ${genome_asm} \
    -m geno \
    -l ${params.busco_lineage} \
    --download_path ${params.busco_db_path} \
    -c ${params.nthreads} \
    --offline
    """
}
