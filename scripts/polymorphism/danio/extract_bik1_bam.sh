#!/usr/bin/env bash

GENOMEDIR="/workdir/Genomes/Danio_rerio"
DATADIR="../../data/polymorphism"

declare -A GENOMES=(
    ["GCA_903684865.1_fDreABH1.1_genomic.fna"]="AB"   # AB
    ["GCA_903684855.2_fDreTuH1.2_genomic.fna"]="TU"   # Tu
    ["GCA_018400075.1_ASM1840007v1_genomic.fna"]="T5D"   # T5D
    ["GCA_903798165.1_fDreCBz1.1_genomic.fna"]="CB"   # Cooch-Behar
    ["GCA_903798175.1_fDreNAz1.1_genomic.fna"]="NA"   # Nadia
)

for genome in ${!GENOMES[@]}; do
    strain=${GENOMES[$genome]}
    echo "extracting bik1 loci from Reference-${strain} alignment"
    samtools view \
        ../../../data/polymorphism/Ref_${strain}_alignment.bam \
        "NC_007114.7:46589903-46598574" \
        > ../../../data/polymorphism/${strain}_test.sam
done
