process screen_contaminants_adapters {
    publishDir "${params.outdir}/fcs", mode: 'symlink'
    
    stageInMode 'copy'
    conda params.nextflow_env
    input:
    tuple val(asm_name), path(genome_asm)

    output:
    tuple val(asm_name), path ("results/cleaned_adapter_removed/${asm_name}.cleaned.adapter_removed.fasta"),  emit :screened_assembly

    script:
    """
    nextflow run artorias111/fcs_nf --fasta \$PWD/${genome_asm} --taxid ${params.taxid} --specimen_id ${asm_name} --outdir .
    """
} 
