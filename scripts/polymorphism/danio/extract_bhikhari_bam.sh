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

# Extracting BHIKHARI-1
bedtools slop \
    -b 50000 \
    -i ../../../data/beds/reference_bik1_full_length_intact.bed \
    -g ../../../data/genomes/GCF_000002035.6_GRCz11.genome > tmp.bed

for genome in ${!GENOMES[@]}; do
    strain=${GENOMES[$genome]}
    echo "extracting bik1 loci from Reference-${strain} alignment"
    
    samtools view \
        -b \
        -h \
        -q 60 \
        ../../../data/polymorphism/Ref_${strain}_alignment.bam \
        $(sed 's/\t/:/' tmp.bed | sed 's/\t/-/' | tr '\n' ' ' | sed 's/$/\n/') |
    samtools sort > ../../../data/polymorphism/${strain}_bik1_full_length_intact.bam
done

# Extracting BHIKHARI-2
bedtools slop \
    -b 50000 \
    -i ../../../data/beds/reference_bik2_full_length_intact.bed \
    -g ../../../data/genomes/GCF_000002035.6_GRCz11.genome > tmp.bed

for genome in ${!GENOMES[@]}; do
    strain=${GENOMES[$genome]}
    echo "extracting bik2 loci from Reference-${strain} alignment"
    
    samtools view \
        -b \
        -h \
        -q 60 \
        ../../../data/polymorphism/Ref_${strain}_alignment.bam \
        $(sed 's/\t/:/' tmp.bed | sed 's/\t/-/' | tr '\n' ' ' | sed 's/$/\n/') |
    samtools sort > ../../../data/polymorphism/${strain}_bik2_full_length_intact.bam
done

rm tmp.bed
