#!/usr/bin/env python3

from Bio import SeqIO
import sys
import re

genomedict = {
    'jungle_fowl': 'GCF_000002315.6/GCF_000002315.6_GRCg6a_genomic.fna',
    'broiler': 'GCF_016699485.2/GCF_016699485.2_bGalGal1.mat.broiler.GRCg7b_genomic.fna',
    'rhode_island_red': 'GCA_024652985.1/GCA_024652985.1_ASM2465298v1_genomic.fna',
    'white_leghorn': 'GCA_024652995.1/GCA_024652995.1_ASM2465299v1_genomic.fna',
    'silkie': 'GCA_024653025.1/GCA_024653025.1_ASM2465302v1_genomic.fna',
    'cornish': 'GCA_024653035.1/GCA_024653035.1_ASM2465303v1_genomic.fna',
    'yeonsan_ogye': 'GCA_002798355.1/GCA_002798355.1_Ogye1.0_genomic.fna',
    'huxu': 'GCA_024206055.1/GCA_024206055.1_ASM2420605v1_genomic.fna',
    'houdan': 'GCA_024653045.1/GCA_024653045.1_ASM2465304v1_genomic.fna'
    }

chroms = {}
for breed, genome in genomedict.items():
    for record in SeqIO.parse(f'/Users/jonwells/Genomes/Aves/{genome}', 'fasta'):
        # print(record.description)
        chrom = re.search(r'chr.*\s(([A-z,0-9]+ unlocalized)|([A-z,0-9]+))', record.description)
        if chrom:
            chrom = chrom.group(1)
        else:
            raise ValueError(record.description)
        chroms[f'{breed}_ENS1_{record.id}'] = f'{breed}_ENS1_{chrom}'

newrecords = []
for record in SeqIO.parse(sys.argv[1], 'fasta'):
    chrom = re.match(r'([\w\.]+):(.+)', record.description)
    if chrom:
        record.name = chroms[chrom.group(1)] + ':' + chroms.group(2)
        record.id = chroms[chrom.group(1)] + ':' + chroms.group(2)
        record.description = ''
        newrecords.append(record)
SeqIO.write(newrecords, sys.stdout, 'fasta')

