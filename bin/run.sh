#!/usr/bin/env bash

set -e

scripts_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P)
root_dir=$(echo "$scripts_dir" | rev | cut -d'/' -f4- | rev)
project_dir=$(echo "$scripts_dir" | rev | cut -d'/' -f2- | rev)
blast_parser="${project_dir}/build/Products/Debug/blast_parser"
sequences_dir="${root_dir}/18S-Nanopore/Sequences/ALL_02_120824"
report_f="ALL_02_120824-kraken2-report.tsv"
sequences_f="ALL_02_120824.fasta"
output_f="ALL_02_120824_parsed.tsv"
classification_f="ALL_02_120824_classification.tsv"

cd "$sequences_dir"

"$blast_parser" parse \
  -r "$report_f" \
  -c "$classification_f" \
  -s "$sequences_f" \
  -o "$output_f" \
  -m 20



