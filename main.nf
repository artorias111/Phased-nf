#!/usr/bin/env nextflow

// Include process definitions
include { GetHifiReads } from './bin/GetHifiReads'
include { runHifiasm } from './bin/Hifiasm'
include { gfa2fa } from './bin/Hifiasm'
include { AlignHicReads } from './bin/Bwamem2'
include { ScaffoldWithYahs } from './bin/Yahs'
include { runQuast } from './bin/Quast'
include { runBusco } from './bin/Busco'
include { GenerateContactMap } from './bin/Juicer'

workflow {
    // Get HiFi reads
    GetHifiReads(params.hifi_reads)
    
    // Run hifiasm to generate assemblies
    runHifiasm(
        params.species_id,
        GetHifiReads.out.hifi_reads,
        params.hic1,
        params.hic2
    )
    
    // Convert GFA files to FASTA for all three assemblies
    gfa2fa(runHifiasm.out.primary_gfa)
    gfa2fa(runHifiasm.out.hap1_gfa)
    gfa2fa(runHifiasm.out.hap2_gfa)
    
    // Collect all FASTA files for parallel processing
    all_fastas = Channel.of(
        gfa2fa.out.fasta
    ).flatten()
    
    // Align Hi-C reads to all three assemblies in parallel
    AlignHicReads(
        params.hic1,
        params.hic2,
        all_fastas
    )
    
    // Scaffold all three assemblies with YaHS in parallel
    ScaffoldWithYahs(
        all_fastas,
        AlignHicReads.out.aligned_bam
    )
    
    // Generate contact maps for all scaffolded assemblies
    GenerateContactMap(
        ScaffoldWithYahs.out.scaffolded_assembly,
        ScaffoldWithYahs.out.scaffolded_assembly_fai,
        ScaffoldWithYahs.out.yahs_bin,
        ScaffoldWithYahs.out.yahs_agp
    )
    
    // Run QUAST on all scaffolded assemblies in parallel
    runQuast(
        ScaffoldWithYahs.out.scaffolded_assembly,
        "${params.species_id}_primary_scaffolded"
    )
    runQuast(
        ScaffoldWithYahs.out.scaffolded_assembly,
        "${params.species_id}_hap1_scaffolded"
    )
    runQuast(
        ScaffoldWithYahs.out.scaffolded_assembly,
        "${params.species_id}_hap2_scaffolded"
    )
    
    // Run BUSCO on all scaffolded assemblies in parallel
    runBusco(
        ScaffoldWithYahs.out.scaffolded_assembly,
        "${params.species_id}_primary_scaffolded"
    )
    runBusco(
        ScaffoldWithYahs.out.scaffolded_assembly,
        "${params.species_id}_hap1_scaffolded"
    )
    runBusco(
        ScaffoldWithYahs.out.scaffolded_assembly,
        "${params.species_id}_hap2_scaffolded"
    )
}

workflow.onComplete {
    log.info """
    =========================================
    Pipeline execution summary
    =========================================
    Completed at: ${workflow.complete}
    Duration    : ${workflow.duration}
    Success     : ${workflow.success}
    Exit status : ${workflow.exitStatus}
    =========================================
    """
}

workflow.onError {
    log.error """
    =========================================
    Pipeline execution failed
    =========================================
    Error       : ${workflow.errorMessage}
    =========================================
    """
}