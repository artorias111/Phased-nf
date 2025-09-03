process ScaffoldWithYahs {
    input:
    path fasta
    path aligned_bam

    output:
    path "yahs.out_scaffolds_final.fa", emit: scaffolded_assembly
    path "yahs.out_scaffolds_final.fa.fai", emit: scaffolded_assembly_fai
    path "yahs.out.bin", emit: yahs_bin
    path "yahs.out_scaffolds_final.agp", emit: yahs_agp

    script:
    """
    samtools faidx ${fasta}
    ${params.yahs}/yahs ${fasta} ${aligned_bam}
    """
}