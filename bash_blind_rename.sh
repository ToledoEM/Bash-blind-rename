#!/bin/bash
# Bash generate random alphanumeric string UPPERCASE and numeric
# Can't be run as superuser or root
# Ignore name_diccionary.csv file for renaming
# Keep file extension untouch. 
# Control if folder have been already randomized by existence of name_diccionary.csv
# Check that folder it is in fact a folder and do not goes in subfolders
# Reduce risk of filename collisions with shasum filename, cut in half

if [ "$(id -u)" == "0" ]; then
    echo "Sorry, do not run this as superuser."
    exit 1
else

if [ ! -d "$1" ]; then
    echo "$1 does not exists"
    exit 1
else

if [ -f "$1/name_diccionary.csv" ];then
    echo "Files on folder already randomized"
    exit 1
else
    echo "Oldname,Newname" >> $1/name_diccionary.csv

    for file in $(ls -p $1 | grep -v / )

        do
            if [ "$file" == "name_diccionary.csv" ] ; then
                  continue;
                 fi
            NEWNAME=$(echo $file | shasum | tr '[a-z]' '[A-Z]' |tr -dc 'A-Z0-9' | cut -c 1-20 )
            ext=${file##*.}
            mv  $1/$file $1/$NEWNAME.$ext
            echo "$file,$NEWNAME.$ext" >> $1/name_diccionary.csv
        
        done
fi
fi
fi
