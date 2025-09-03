process ScaffoldWithYahs {
    input:
    tuple val(meta_id), path(fasta), path(aligned_bam)

    output:
    tuple val(meta_id), path("${meta_id}_scaffolded.fa"), emit: scaffolded_assembly_tuple
    path "yahs.out.bin", emit: yahs_bin
    path "yahs.out_scaffolds_final.agp", emit: yahs_agp
    path "yahs.out_scaffolds_final.fa.fai", emit: scaffolded_assembly_fai

    script:
    """
    samtools faidx ${fasta}
    ${params.yahs}/yahs ${fasta} ${aligned_bam}
    cp yahs.out_scaffolds_final.fa ${meta_id}_scaffolded.fa
    """
}