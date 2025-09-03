#!/usr/bin/env nextflow

// Include process definitions
include { runHifiasm } from './bin/Hifiasm'
include { gfa2fa } from './bin/Hifiasm'
include { AlignHicReads } from './bin/Bwamem2'
include { ScaffoldWithYahs } from './bin/Yahs'
include { runQuast } from './bin/Quast'
include { runBusco } from './bin/Busco'
include { GenerateContactMap } from './bin/Juicer'

workflow {
    // Create HiFi reads channel using channel factory
    Channel
        .fromPath("${params.hifi_reads}/*.fastq.gz")
        .filter { !it.name.contains('fail') }  // Exclude files with 'fail'
        .filter { !it.name.contains('gz.') }   // Exclude stat files like .gz.md5
        .collect()
        .set { hifi_reads_ch }
    
    // Run hifiasm to generate assemblies
    runHifiasm(
        params.species_id,
        hifi_reads_ch,
        params.hic1,
        params.hic2
    )

    // Create three separate channels and add metadata to each
    // We create a tuple of the form: [meta_id, file]
    primary_gfa_ch = runHifiasm.out.primary_gfa.map { gfa -> ['primary', gfa] }
    hap1_gfa_ch    = runHifiasm.out.hap1_gfa.map { gfa -> ['hap1', gfa] }
    hap2_gfa_ch    = runHifiasm.out.hap2_gfa.map { gfa -> ['hap2', gfa] }

    // Merge the three channels into a single channel for downstream processing
    all_gfa_ch = primary_gfa_ch.concat(hap1_gfa_ch, hap2_gfa_ch)
    
    // Convert GFA files to FASTA
    gfa2fa(all_gfa_ch)
    
    // Align Hi-C reads
    AlignHicReads(
        params.hic1,
        params.hic2,
        gfa2fa.out.fasta_tuple
    )
    
    // Scaffold all three assemblies
    ScaffoldWithYahs(
        AlignHicReads.out.aligned_tuple
    )

    // Generate contact maps
    GenerateContactMap(
        ScaffoldWithYahs.out.scaffolded_assembly_tuple,
        ScaffoldWithYahs.out.scaffolded_assembly_fai,
        ScaffoldWithYahs.out.yahs_bin,
        ScaffoldWithYahs.out.yahs_agp
    )
    
    // Run QUAST and BUSCO on the final scaffolded assemblies
    scaffolded_ch = ScaffoldWithYahs.out.scaffolded_assembly_tuple

    runQuast(
        scaffolded_ch.map { meta, assembly ->
            [ "${params.species_id}_${meta}_scaffolded", assembly ]
        }
    )
    
    runBusco(
        scaffolded_ch.map { meta, assembly ->
            [ "${params.species_id}_${meta}_scaffolded", assembly ]
        }
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