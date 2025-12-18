process multiQC {
    conda ${params.mqc_conda}

    publishDir "${params.outdir}/multiqc", mode: 'copy'

    input:
    path '*'

    output:
    path "multiqc_report"

    script:
    """
    multiqc . --outdir multiqc_report
    """
}