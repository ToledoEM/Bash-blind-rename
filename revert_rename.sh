#!/bin/bash
set -euo pipefail
# revert renaming from name_dictionary.csv file
# Ignore header of CSV file
# Deprecate name_dictionary.csv

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

dir="$1"

if [[ "$(id -u)" == "0" ]]; then
    echo "Sorry, do not run this as superuser."
    exit 1
fi

if [[ ! -d "$dir" ]]; then
    echo "$dir does not exist"
    exit 1
fi

if [[ ! -f "$dir/name_dictionary.csv" ]]; then
    echo "Dictionary not found"
    exit 1
fi

while IFS= read -r line; do
    [[ "$line" == "Oldname,Newname" ]] && continue
    [[ -z "$line" ]] && continue
    # Split only on the first comma to handle filenames containing commas
    orig="${line%%,*}"
    new="${line#*,}"
    if [[ ! -f "$dir/$new" ]]; then
        echo "Error: expected file not found: $new"
        exit 1
    fi
    mv "$dir/$new" "$dir/$orig"
done < <(sed 's/"//g' "$dir/name_dictionary.csv")

echo "File names reverted to original"
mv "$dir/name_dictionary.csv" "$dir/name_dictionary_DEPRECATED.csv"
echo "Dictionary deprecated"
echo "DONE"
