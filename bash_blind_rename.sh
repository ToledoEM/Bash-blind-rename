#!/bin/bash
# Bash generate alphanumeric string UPPERCASE and numeric to obfuscate file names
# Can't be run as superuser or root
# Ignore name_dictionary.csv file for renaming
# Insensitive to filenames and folders with empty spaces
# Keep file extension untouch.
# Control if folder have been already randomized by existence of name_dictionary.csv
# Check that folder it is in fact a folder and do not goes in subfolders
# Reduce risk of filename collisions with shasum filename, cut in half
# Create file Analysis_file.csv with only new names to be used for manual analysis

rename_files() {
    local dir="$1"
    printf 'Oldname,Newname\n' > "$dir/name_dictionary.csv"
    printf 'Newname\n' > "$dir/Analysis_file.csv"
    while IFS= read -r -d '' file; do
        local basefile lowerbasefile
        basefile="$(basename -- "$file")"
        lowerbasefile="$(printf '%s' "$basefile" | tr '[:upper:]' '[:lower:]')"
        # Skip if file is name_dictionary.csv, Analysis_file.csv, .DS_Store, or Thumbs.db (extra safety)
        if [[ "$basefile" == "name_dictionary.csv" || "$basefile" == "Analysis_file.csv" || "$basefile" == ".DS_Store" || "$lowerbasefile" == "thumbs.db" ]]; then
            continue
        fi
        local ext newname
        ext="${basefile##*.}"
        if [[ "$basefile" == "$ext" ]]; then
            ext="" # No extension
            newname=$(printf '%s' "$basefile" | shasum | tr '[:lower:]' '[:upper:]' | tr -dc 'A-Z0-9' | cut -c 1-20)
            printf '%s\n' "$basefile,$newname" >> "$dir/name_dictionary.csv"
            mv "$file" "$dir/$newname"
            printf '%s\n' "$newname" >> "$dir/Analysis_file.csv"
        else
            newname=$(printf '%s' "$basefile" | shasum | tr '[:lower:]' '[:upper:]' | tr -dc 'A-Z0-9' | cut -c 1-20)
            printf '%s\n' "$basefile,$newname.$ext" >> "$dir/name_dictionary.csv"
            mv "$file" "$dir/$newname.$ext"
            printf '%s\n' "$newname.$ext" >> "$dir/Analysis_file.csv"
        fi
    done < <(find "$dir" -maxdepth 1 -type f \
        ! -name "name_dictionary.csv" \
        ! -name "Analysis_file.csv" \
        ! -name ".DS_Store" \
        ! -iname "thumbs.db" \
        -print0)
}

main() {
    local dir="$1"

    if [[ "$(id -u)" == "0" ]]; then
        echo "Sorry, do not run this as superuser."
        exit 1
    fi
    if [[ ! -d "$dir" ]]; then
        echo "$dir does not exist"
        exit 1
    fi
    if [[ -f "$dir/name_dictionary.csv" || -f "$dir/Analysis_file.csv" ]]; then
        echo "Files on folder already renamed"
        exit 1
    fi
    if [[ -f "$dir/name_dictionary_DEPRECATED.csv" ]]; then
        echo "Files on folder already randomized once and reverted"
        echo "Please delete name_dictionary_DEPRECATED.csv on $dir"
        exit 1
    fi

    local N
    N=$(find "$dir" -maxdepth 1 -type f | wc -l)
    if (( N >= 200 )); then
        echo "There are too many files in $dir for manual quantification"
        echo
        read -p "Are you sure to continue? (Y/N) " answer
        case ${answer:0:1} in
            y|Y ) ;;
            * )
                echo "Exit without any modification"
                exit 1
                ;;
        esac
    fi

    rename_files "$dir"
    echo "DONE"
}

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <directory>"
    exit 1
fi
main "$1"
