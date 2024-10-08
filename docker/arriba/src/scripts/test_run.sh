#!/usr/bin/bash

CTAT_LIB="/tmp/libs"
FASTQS="/tmp/data"
ARR_OUTDIR="/tmp/out"
STAR_TMPDIR="/tmp/out/star"
ARRIBA_PKG="/opt/conda/var/lib/arriba"

echo "Environment variables set! Running STAR..."

# run STAR then pipe into arriba
STAR --runThreadN 8 \
--genomeDir ${CTAT_LIB}/ref_genome.fa.star.idx \
--genomeLoad NoSharedMemory \
--readFilesIn ${FASTQS}/2T_r1.fq.gz ${FASTQS}/2T_r2.fq.gz \
--readFilesCommand zcat \
--outStd BAM_Unsorted \
--outSAMtype BAM Unsorted \
--outSAMunmapped Within \
--outBAMcompression 0 \
--outFilterMultimapNmax 50 \
--peOverlapNbasesMin 10 \
--alignSplicedMateMapLminOverLmate 0.5 \
--alignSJstitchMismatchNmax 5 -1 5 5 \
--chimSegmentMin 10 \
--chimOutType WithinBAM HardClip \
--chimJunctionOverhangMin 10 \
--chimScoreDropMax 30 \
--chimScoreJunctionNonGTAG 0 \
--chimScoreSeparation 1 \
--chimSegmentReadGapMax 3 \
--chimMultimapNmax 50 \
--outFileNamePrefix ${ARR_OUTDIR} --outTmpDir ${STAR_TMPDIR} | arriba \
-x /dev/stdin \
-o ${ARR_OUTDIR}/arriba-fusions.tsv \
-O ${ARR_OUTDIR}/fusions.discarded.tsv \
-a ${CTAT_LIB}/ref_genome.fa \
-g ${CTAT_LIB}/ref_annot.gtf \
-b ${ARRIBA_PKG}/blacklist_hg38_GRCh38_v2.3.0.tsv.gz \
-k ${ARRIBA_PKG}/known_fusions_hg38_GRCh38_v2.3.0.tsv.gz \
-t ${ARRIBA_PKG}/known_fusions_hg38_GRCh38_v2.3.0.tsv.gz \
-p ${ARRIBA_PKG}/protein_domains_hg38_GRCh38_v2.3.0.gff3 2>&1 | tee ${ARR_OUTDIR}/arriba-test.log.txt
