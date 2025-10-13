process runQuast {
    conda params.quast_conda

    publishDir "${params.outdir}/quast", mode: 'symlink'
    // publishDir "${params.outdir}", saveAs: { filename -> "${filename}" }, mode: 'symlink'

    input:
    tuple val(asm_name), path(genome_asm)

    output:
    path "${asm_name}.quast", emit: quast_results

    script:
    """
    quast -o ${asm_name}.quast -t ${params.nthreads} \
    --est-ref-size ${params.est_ref_size} \
    ${genome_asm}
    """
}
