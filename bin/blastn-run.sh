#!/usr/bin/env bash

set -e

scripts_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P)
root_dir=$(echo "$scripts_dir" | rev | cut -d'/' -f4- | rev)

#user settings
query="kraken2-parsed-sequences.fasta"
db="${root_dir}/ncbi/db/nt_euk/nt_euk"
output_file="blast.tsv"

# set working directory where the query is
query_dir="${root_dir}/18S-Nanopore/Sequences/ALL_02_120824"
echo "Targeting $query_dir"
cd "$query_dir"

blastn -query "$query" \
    -task "blastn" \
    -db "$db" \
    -num_threads 4 \
    -out "$output_file" \
    -max_target_seqs 10 \
    -evalue 1e-10 \
    -outfmt '6 qseqid staxids sscinames pident score evalue length qlen qcovs salltitles'

echo "BLAST analysis ended."