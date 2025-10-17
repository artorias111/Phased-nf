process ScaffoldWithYahs {
    publishDir "results/Yahs/${params.specimen_id}.${meta_id}.yahs", mode: 'symlink'
    input:
    tuple val(meta_id), path(fasta), path(aligned_bam)

    output:
    tuple val(meta_id), path("${meta_id}_scaffolded.fa"), emit: scaffolded_assembly_tuple
    tuple val(meta_id), 
            path("${fasta}.fai"), 
            path ("yahs.out.bin"),
            path ("yahs.out_scaffolds_final.agp"), emit: juicer_collection


    script:
    """
    samtools faidx ${fasta}
    ${params.yahs}/yahs ${fasta} ${aligned_bam}
    cp yahs.out_scaffolds_final.fa ${meta_id}_scaffolded.fa
    samtools faidx ${meta_id}_scaffolded.fa
    """
}