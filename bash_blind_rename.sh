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
IFS=$'\n'

N=$(find "$1" -maxdepth 1 -type f | wc -l) 
if [ "$N" -ge 200 ]
 then 	
 echo "There are too many files in $1 for manual quantification"
 echo
 read -p -r "Are you sure to continue? (Y/N)" answer 
 case ${answer:0:1} in
    y|Y )
		echo
		echo
		echo
		
		if [ "$(id -u)" == "0" ]; then
		    echo "Sorry, do not run this as superuser."
		    exit 1
		else

		if [ ! -d "$1" ]; then
		    echo "$1 does not exists"
		    exit 1
		else

		if [ -f "$1/name_dictionary.csv" ] || [ -f "$1/Analysis_file.csv" ] ;then
		    echo "Files on folder already renamed"
		    exit 1
		else

		if [ -f "$1/name_dictionary_DEPRECATED.csv" ];then
		    echo "Files on folder already randomized once and reverted"
		    echo "Please delete name_dictionary_DEPRECATED.csv on $1"
		    exit 1

		else
		    echo "Oldname,Newname" > "$1/name_dictionary.csv"
		    echo "Newname" > "$1/Analysis_file.csv"

		    #for file in $(find  "$1" -maxdepth 1 -type f -printf "%f\n" ) #doesn't work on OSX
		    for file in $(ls -p "$1" | grep -v /)

		        do
		            if [ "$file" == "name_dictionary.csv" ] || [ "$file" == "Analysis_file.csv" ] ; then
		                  continue;
		                 fi
		            NEWNAME=$(echo $file | shasum | tr 'a-z' 'A-Z' |tr -dc 'A-Z0-9' | cut -c 1-20 )
		            ext=${file##*.}
		            echo "$file,$NEWNAME.$ext" >> "$1/name_dictionary.csv"
		            mv  "$1/$file" "$1/$NEWNAME.$ext"
		            echo "$NEWNAME.$ext" >> "$1/Analysis_file.csv"
		        done
		fi
		fi
		fi
		fi
		echo "DONE"
	;;	
	*) 
		echo "Exit without any modification"
		exit 1

esac
else
			echo
		echo
		echo
		
		if [ "$(id -u)" == "0" ]; then
		    echo "Sorry, do not run this as superuser."
		    exit 1
		else

		if [ ! -d "$1" ]; then
		    echo "$1 does not exists"
		    exit 1
		else

		if [ -f "$1/name_dictionary.csv" ] || [ -f "$1/Analysis_file.csv" ] ;then
		    echo "Files on folder already renamed"
		    exit 1
		else

		if [ -f "$1/name_dictionary_DEPRECATED.csv" ];then
		    echo "Files on folder already randomized once and reverted"
		    echo "Please delete name_dictionary_DEPRECATED.csv on $1"
		    exit 1

		else
		    echo "Oldname,Newname" > $1/name_dictionary.csv
		    echo "Newname" > $1/Analysis_file.csv

		    #for file in $(find  "$1" -maxdepth 1 -type f -printf "%f\n" ) #doesn't work on OSX
		    for file in $(ls -p "$1" | grep -v /)

		        do
		            if [ "$file" == "name_dictionary.csv" ] || [ "$file" == "Analysis_file.csv" ] ; then
		                  continue;
		                 fi
		            NEWNAME=$(echo $file | shasum | tr 'a-z' 'A-Z' |tr -dc 'A-Z0-9' | cut -c 1-20 )
		            ext=${file##*.}
		            echo "$file,$NEWNAME.$ext" >> "$1/name_dictionary.csv"
		            mv  "$1/$file" "$1/$NEWNAME.$ext"
		            echo "$NEWNAME.$ext" >> "$1/Analysis_file.csv"
		        done
		fi
		fi
		fi
		fi
		echo "DONE"
fi

