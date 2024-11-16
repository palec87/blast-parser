#!/usr/bin/env bash

set -e

scripts_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P)
root_dir=$(echo "$scripts_dir" | rev | cut -d'/' -f4- | rev)
blast_parser="${scripts_dir}/blast_parser"
sequences_dir="${root_dir}/18S-Nanopore/Sequences/ALL_02_120824"
asvs_f="ALL_02_120824_parsed.tsv"
blasthits_f="blast2.tsv"
parsed_taxonomy_f="kraken2-parsed-classification.tsv"

cd "$sequences_dir"

"$blast_parser" merge \
  -a "$asvs_f" \
  -b "$blasthits_f" \
  -p "$parsed_taxonomy_f" \
  -h 5 \
  -s "bitscore"




