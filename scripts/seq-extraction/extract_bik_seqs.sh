#!/usr/bin/env bash

# This script extracts bik family seqs from all Danio species, used in the production of Fig 1B.

GDIR="/Users/jonwells/Genomes/Cypriniformes"
declare -A GENOMES=(
    ["Danio_albolineatus"]="GCA_903798035.1_fDanAlb1.1_genomic.fna"
    ["Danio_jaintianensis"]="GCA_903798115.1_fDanJai1.1_genomic.fna"
    ["Danio_choprai"]="GCA_903798125.1_fDanCho1.1_genomic.fna"
    ["Danio_aesculapii"]="GCA_903798145.1_fDanAes4.1_genomic.fna"
    ["Danio_kyathit"]="GCA_903798195.1_fDanKya3.1_genomic.fna"
    ["Danio_tinwini"]="GCA_903798205.1_fDanTin1.1_genomic.fna"
    ["Danio_rerio"]="GCF_000002035.6_GRCz11_genomic.nonalt.fna"
    )

# Clean pre-existing bik1 files
if [ -f ../../data/seqs/all_danio_bik_internals.fa ]; then
    rm ../../data/seqs/all_danio_bik_internals.fa
fi

for species in ${!GENOMES[@]}; do
    echo $species 
    blastn \
        -query "../../data/repeatmodeller-out/all_species_biks.fa" \
        -subject "${GDIR}/${GENOMES[$species]}" \
        -evalue 1e-10 \
        -outfmt 6 |
    blast2bed.sh | bedtools sort > "../../data/beds/${species}_bik_internals.bed" 

    bedtools merge \
        -s \
        -i "../../data/beds/${species}_bik_internals.bed" \
        -d 200 \
        -c 4,5,6 \
        -o distinct,sum,distinct > tmp.bed
    mv tmp.bed "../../data/beds/${species}_bik_internals.bed"
    
    # Extract sequences from blast output, using arbitrary size threshold of 1000bp to avoid
    # inclusion of heavily fragmented or ambiguous sequences.
    bedtools getfasta \
        -s \
        -fi ${GDIR}/${GENOMES[$species]} \
        -bed "../../data/beds/${species}_bik_internals.bed" |
    bioawk -c fastx '{ if (length($seq) >= 1000 ) print ">"$name"\n"$seq }' > tmp.fa
    seqtk rename tmp.fa "${species}_bik_internal_" >> ../../data/seqs/all_danio_bik_internals.fa
    rm tmp.fa
done

# Append repeatmodeller consensus sequences to file to aid in identification of subfamilies.
cat "../../data/repeatmodeller-out/all_species_biks.fa" >> ../../data/seqs/all_danio_bik_internals.fa
