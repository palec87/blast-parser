#!/usr/bin/env bash

set -e

scripts_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P)
root_dir=$(echo "$scripts_dir" | rev | cut -d'/' -f4- | rev)
blast_parser="${scripts_dir}/blast_parser"
sequences_dir="${root_dir}/18S-Nanopore/Sequences/ALL_02_120824"
db_dir="${root_dir}/ncbi/db/new_taxdump"
lineage_f="${db_dir}/rankedlineage.dmp"
csv_lineage_f="${db_dir}/rankedlineage.csv"

cd "$sequences_dir"

"$blast_parser" import -i "$lineage_f"
"$blast_parser" export -i "$csv_lineage_f" -d "taxonomy_ncbi"






