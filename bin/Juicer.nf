process GenerateContactMap {
    input:
    path scaffolded_assembly
    path scaffolded_assembly_fai
    path yahs_bin
    path yahs_agp

    output:
    path "out_JBAT.hic", emit: contact_map
    path "out_JBAT.log", emit: juicer_log

    script:
    """
    # Run juicer pre to prepare the contact map
    ${params.yahs}/juicer pre -a -o out_JBAT ${yahs_bin} ${yahs_agp} ${scaffolded_assembly_fai} > out_JBAT.log 2>&1
    
    # Extract and modify the juicer command
    Juicer_cmd=\$(grep 'JUICER_PRE CMD' out_JBAT.log | sed 's/JUICER_PRE CMD: //' | sed 's/\\[I::main_pre\\]//' | sed 's/Xmx36G/Xmx400G/')
    
    # Run the juicer command to generate the contact map
    eval "\$Juicer_cmd"
    """
}
