#!/usr/bin/env bash

GENOMEDIR="/workdir/Genomes/Danio_rerio"
DATADIR="../../data/polymorphism"

declare -A GENOMES=(
    ["GCA_903684865.1_fDreABH1.1_genomic.fna"]="AB"   # AB
    ["GCA_903684855.2_fDreTuH1.2_genomic.fna"]="TU"   # Tu
    ["GCA_018400075.1_ASM1840007v1_genomic.fna"]="T5D"   # T5D
    ["GCA_903798165.1_fDreCBz1.1_genomic.fna"]="CB"   # Cooch-Behar
    ["GCA_903798175.1_fDreNAz1.1_genomic.fna"]="NA"   # Nadia
    ["GCF_000002035.6_GRCz11_genomic.fna"]="REF"   # Reference
)

for genome in ${!GENOMES[@]}; do
    strain=$GENOMES[$genome]
    echo "aligning ${strain} to reference"
    minimap2 \
        -ax asm5 \
        -t 20 \
        --eqx "${GENOMEDIR}/GCF_000002035.6_GRCz11_genomic.fna" \
        "${GENOMEDIR}/${genome}" |
    samtools sort -O BAM - > "${DATADIR}/Ref_${strain}_alignment.bam"
    samtools index "${DATADIR}/Ref_${strain}_alignment.bam"
done
