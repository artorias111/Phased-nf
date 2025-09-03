process GetHifiReads {
    input:
    path hifi_reads_dir

    output:
    path "*.fastq.gz", emit: hifi_reads

    script:
    """
    python3 ${projectDir}/getHifiReads.py --dir ${hifi_reads_dir}
    """
}
