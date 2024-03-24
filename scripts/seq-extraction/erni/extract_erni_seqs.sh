#!/usr/bin/env bash

GENOMEDIR="/Users/jonwells/Genomes/Aves/"
declare -A GENOMES=(
    ["jungle_fowl"]="GCF_000002315.6/GCF_000002315.6_GRCg6a_genomic.fna"
    ["broiler"]="GCF_016699485.2/GCF_016699485.2_bGalGal1.mat.broiler.GRCg7b_genomic.fna"
    ["pat_whiteleghorn"]="GCF_016700215.2/GCF_016700215.2_bGalGal1.pat.whiteleghornlayer.GRCg7w_genomic.fna"
    ["rhode_island_red"]="GCA_024652985.1/GCA_024652985.1_ASM2465298v1_genomic.fna"
    ["white_leghorn"]="GCA_024652995.1/GCA_024652995.1_ASM2465299v1_genomic.fna"
    ["silkie"]="GCA_024653025.1/GCA_024653025.1_ASM2465302v1_genomic.fna"
    ["cornish"]="GCA_024653035.1/GCA_024653035.1_ASM2465303v1_genomic.fna"
    ["yeonsan_ogye"]="GCA_002798355.1/GCA_002798355.1_Ogye1.0_genomic.fna"
    ["huxu"]="GCA_024206055.1/GCA_024206055.1_ASM2420605v1_genomic.fna"
    ["houdan"]="GCA_024653045.1/GCA_024653045.1_ASM2465304v1_genomic.fna"
    )

# rm /Users/jonwells/Desktop/all_ens1.fa
for breed in ${!GENOMES[@]}; do
#     echo blasting $breed
#     blastn \
#         -query ../../data/seqs/erni/ENS1_full_length.fa \
#         -subject "${GENOMEDIR}/${GENOMES[$breed]}" \
#         -evalue 1e-60 \
#         -outfmt 6 |
#     awk '{ if ($4 > 2333 && $4 < 5133 ) print $0 }' |
#     blast2bed.sh > "../../data/beds/erni/${breed}_ENS1_full_length_insertions.bed" &
        
#     blastn \
#         -query ../../data/seqs/erni/ENS3_full_length.fa \
#         -subject "${GENOMEDIR}/${GENOMES[$breed]}" \
#         -evalue 1e-60 \
#         -outfmt 6 |
#     awk '{ if ($4 > 5723 && $4 < 10023 ) print $0 }' |
#     blast2bed.sh > "../../data/beds/erni/${breed}_ENS3_full_length_insertions.bed"

#     wait

    # echo extracting $breed fasta
    # for i in 1 3; do
    #     bedtools getfasta \
    #         -fi "${GENOMEDIR}/${GENOMES[$breed]}" \
    #         -bed "../../data/beds/erni/${breed}_ENS${i}_full_length_insertions.bed" \
    #         -s |
    #     seqkit replace -p "^" -r "${breed}_ENS${i}_" |
    #     seqkit rename > "../../data/seqs/erni/${breed}_ENS${i}_full_length_insertions.fa"

    # done
    # cat "../../data/seqs/erni/${breed}_ENS1_full_length_insertions.fa" >> /Users/jonwells/Desktop/all_ens1.fa
    
    blastn \
        -query ../../data/seqs/erni/erni_empty_site.fa \
        -subject "${GENOMEDIR}/${GENOMES[$breed]}" \
        -evalue 1e-30 \
        -outfmt 6 |
    awk '{ if ($4 >95 ) print $0 }' > "../../data/blast-out/${breed}_erni_empty_site.out"
    blastn \
        -query ../../data/seqs/erni/erni_solo_ltr.fa \
        -subject "${GENOMEDIR}/${GENOMES[$breed]}" \
        -evalue 1e-30 \
        -outfmt 6 |
    awk '{ if ($4 > 950 ) print $0 }' > "../../data/blast-out/${breed}_erni_solo_ltr.out"
done

# blastn \
#     -query ../../data/seqs/erni/ENS1_full_length.fa \
#     -subject "${GENOMEDIR}/${GENOMES[jungle_fowl]}" \
#     -evalue 1e-60 \
#     -outfmt 6 |
# awk '{ if ($4 > 1000 && $4 < 5133 ) print $0 }' |
# blast2bed.sh > "../../data/beds/erni/reference_ENS1_1kplus_insertions.bed" 
# bedtools getfasta \
#     -fi "${GENOMEDIR}/${GENOMES[jungle_fowl]}" \
#     -bed "../../data/beds/erni/reference_ENS1_1kplus_insertions.bed" \
#     -s > "../../data/seqs/erni/reference_ENS1_1kplus_insertions.fa"
