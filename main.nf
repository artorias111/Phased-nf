#!/usr/bin/env nextflow

// step 1: hifiasm
include { runHifiasm } from './bin/Hifiasm.nf'
include { gfa2fa } from './bin/Hifiasm.nf'
include { runQuast as quastHifiasm } from './bin/Quast.nf'
include { runBusco as buscoHifiasm } from './bin/Busco.nf'

// step 2: contamination screening
include { screen_contaminants_adapters } from './bin/fcs.nf'
include { runQuast as quastFcs } from './bin/Quast.nf'
include { runBusco as buscoFcs } from './bin/Busco.nf'

// step 3: hi-c scaffolding
include { AlignHicReads } from './bin/Bwamem2.nf'
include { ScaffoldWithYahs } from './bin/Yahs.nf'
include { GenerateContactMap } from './bin/Juicer.nf'
include { runQuast as quastYahs } from './bin/Quast.nf'
include { runBusco as buscoYahs } from './bin/Busco.nf'

// step 4: multiQC
include { multiQC } from './bin/mqc.nf'

workflow {
    Channel
        .fromPath("${params.hifi_reads}/*.fastq.gz")
        .filter { !it.name.contains('fail') }
        .filter { !it.name.contains('gz.') }
        .collect()
        .set { hifi_reads_ch }
    
    runHifiasm(
        params.specimen_id,
        hifi_reads_ch,
        params.hic1,
        params.hic2
    )

    primary_gfa_ch = runHifiasm.out.p_gfa.map { gfa -> ['p', gfa] }
    hap1_gfa_ch    = runHifiasm.out.hap1_gfa.map { gfa -> ['hap1', gfa] }
    hap2_gfa_ch    = runHifiasm.out.hap2_gfa.map { gfa -> ['hap2', gfa] }

    all_gfa_ch = primary_gfa_ch.concat(hap1_gfa_ch, hap2_gfa_ch)
    
    gfa2fa(all_gfa_ch)


    // QC after hifiasm
    quastHifiasm(gfa2fa.out.fasta_tuple.map { meta, assembly ->
        [ "${params.specimen_id}_${meta}_hifiasm", assembly ]
    })
    buscoHifiasm(gfa2fa.out.fasta_tuple.map { meta, assembly ->
        [ "${params.specimen_id}_${meta}_hifiasm", assembly ]
    })


    // step 2
    // gfa2fa.out.view()

    screen_contaminants_adapters(gfa2fa.out.fasta_tuple)

     // QC after FCS
    quastFcs(screen_contaminants_adapters.out.screened_assembly.map { meta, assembly ->
        [ "${params.specimen_id}_${meta}_fcs_cleaned", assembly ]
    })
    buscoFcs(screen_contaminants_adapters.out.screened_assembly.map { meta, assembly ->
        [ "${params.specimen_id}_${meta}_fcs_cleaned", assembly ]
    })

    // step 2.5 purge_dups if needed


    // Step 3: scaffold

    AlignHicReads(
        screen_contaminants_adapters.out.screened_assembly
    )

    ScaffoldWithYahs(
        AlignHicReads.out.aligned_tuple
    )
    
/*
    GenerateContactMap(
        ScaffoldWithYahs.out.juicer_collection
    )
*/
    scaffolded_ch = ScaffoldWithYahs.out.scaffolded_assembly_tuple

    quastYahs(
        scaffolded_ch.map { meta, assembly ->
            [ "${params.specimen_id}_${meta}_scaffolded", assembly ]
        }
    )
    
    buscoYahs(
        scaffolded_ch.map { meta, assembly ->
            [ "${params.specimen_id}_${meta}_scaffolded", assembly ]
        }
    )
}

