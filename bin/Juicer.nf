process GenerateContactMap {
    input:
    tuple val(meta_id), path(scaffolded_assembly)
    path scaffolded_assembly_fai
    path yahs_bin
    path yahs_agp

    output:
    path "${meta_id}_contact_map.hic", emit: contact_map
    path "${meta_id}_juicer.log", emit: juicer_log

    script:
    """
    ${params.yahs}/juicer pre -a -o out_JBAT ${yahs_bin} ${yahs_agp} ${scaffolded_assembly_fai} > ${meta_id}_juicer.log 2>&1
    
    Juicer_cmd=\$(grep 'JUICER_PRE CMD' ${meta_id}_juicer.log | sed 's/JUICER_PRE CMD: //' | sed 's/\\[I::main_pre\\]//' | sed 's/Xmx36G/Xmx400G/')
    
    eval "\$Juicer_cmd"
    
    mv out_JBAT.hic ${meta_id}_contact_map.hic
    """
}
