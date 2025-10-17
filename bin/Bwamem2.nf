process AlignHicReads {
    conda params.bwa_mem_env

    input:
    tuple val(meta_id), path(contig_assembly)

    output:
    tuple val(meta_id), path(contig_assembly), path("${meta_id}_aligned.bam"), emit: aligned_tuple

    script:
    """
    bwa-mem2 index ${contig_assembly}
    bwa-mem2 mem -SP5M -t ${params.nthreads} ${contig_assembly} ${params.hic1} ${params.hic2} | \
    ${params.samblaster} | \
    samtools view -h -b -F 2316 --threads ${params.nthreads} -o ${meta_id}_aligned.bam
    """
}
