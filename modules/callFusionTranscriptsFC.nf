#!/usr/bin/env nextflow

// Run first module
process callFusionTranscriptsFC {
    publishDir "${params.output_dir}/${sampleName}", mode: 'copy'
    container "${params.container__fuscat}"
    containerOptions "-e \"MHF_HOST_UID=\$(id -u)\" -e \"MHF_HOST_GID=\$(id -g)\" --name fuscat-ftcall -v ${params.fuscat_db}:/work/libs -v ${params.input_dir}:/work/data -v ${params.output_dir}:/work/out -v \$(pwd):/work/nf_work -v ${params.bin_dir}:/work/scripts"
    
    input:
        tuple val(sampleName), path(readFiles)

    //output:
        //path "${sampleName}-arriba-fusions.tsv", emit: arriba_fusion_file

    script:
    """
    echo "Path to input read file 1: ${readFiles[0]}"
    echo "Path to input read file 2: ${readFiles[1]}"
    bash /work/scripts/fuscat-nf.sh ${readFiles[0]} ${readFiles[1]}
    """
}
