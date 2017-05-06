#!/bin/bash
# revert renaming from name_dictionary.csv file
# Ignore header of CSV file
# Deprecate name_dictionary.csv

if [ "$(id -u)" == "0" ]; then
    echo "Sorry, do not run this as superuser."
    exit 1
else

if [ ! -d "$1" ]; then
    echo "$1 does not exists"
    exit 1
else

if [ ! -f "$1/name_dictionary.csv" ];then
    echo "Dictionary not found"
    exit 1
else
    
sed 's/"//g' "$1/name_dictionary.csv" | while IFS=, read orig new
do
    if [ "$orig" == "Oldname" ] ; then
                  continue;
                 fi
  mv "$1/$new" "$1/$orig"
done 
echo "File names reverted to original"
mv "$1/name_dictionary.csv" "$1/name_dictionary_DEPRECATED.csv"
echo "Dictionary deprecated"

fi
fi
fi