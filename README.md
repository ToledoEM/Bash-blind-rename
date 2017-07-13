# Blind Rename files in folder

Bash script to blind rename the files on a folder and saving the new names and old names in a dictionary. Also script to revert file names to original.

Works on OSX and Linux (Debian, Ubuntu, Raspian)

The idea was to obfuscate the file names to properly perform a blind analysis on the files, such as images for quantification.

Now also with GUI, made with [Platypus](https://github.com/sveinbjornt/Platypus)

### Characteristics
    
1. Bash generate random new alphanumeric string UPPERCASE and numeric as name.
2. Can't be run as superuser or root
3. Ignore name_dictionary.csv file for renaming
4. Preserve file extension. 
5. Control if folder have been already randomized by existence of 'name_dictionary.csv'
6. Check that folder it is in fact a folder and do not goes in subfolders
7. Reduce risk of filename collisions with shasum filename, cut in half
8. Control if folder have been obfuscate looking for ```name_dictionary_DEPRECATED.csv```
9. Create file with only new names to register the manual analysis of the images


### Use

*  ```chmod +x bash_blind_rename.sh``` So it can be executed - Only once
    
* To obfuscate the names on folder ```temp```

Initial status    

```
   Mac:et$ ls -lF temp/
	total 0
	-rw-r--r--   1 et  staff    0 May  4 21:56 foo_1.txt    
	-rw-r--r--   1 et  staff    0 May  4 21:56 foo_10.txt    
	-rw-r--r--   1 et  staff    0 May  4 21:56 foo_2.txt    
	-rw-r--r--   1 et  staff    0 May  4 21:56 foo_3.txt    
	-rw-r--r--   1 et  staff    0 May  4 21:56 foo_4.txt   
	-rw-r--r--   1 et  staff    0 May  4 21:56 foo_5.txt   
	-rw-r--r--   1 et  staff    0 May  4 21:56 foo_6.txt    
	-rw-r--r--   1 et  staff    0 May  4 21:56 foo_7.txt    
	-rw-r--r--   1 et  staff    0 May  4 21:56 foo_8.txt   
	-rw-r--r--   1 et  staff    0 May  4 21:56 foo_9.txt    
	drwxr-xr-x  12 et  staff  408 May  4 21:56 subfolder/     
	
	Mac:Bash_blind_renamer et$ ls -lF temp/subfolder/
	total 0
	-rw-r--r--  1 et  staff  0 May  4 21:56 bar_1.txt
	-rw-r--r--  1 et  staff  0 May  4 21:56 bar_10.txt
	-rw-r--r--  1 et  staff  0 May  4 21:56 bar_2.txt
	-rw-r--r--  1 et  staff  0 May  4 21:56 bar_3.txt
	-rw-r--r--  1 et  staff  0 May  4 21:56 bar_4.txt
	-rw-r--r--  1 et  staff  0 May  4 21:56 bar_5.txt
	-rw-r--r--  1 et  staff  0 May  4 21:56 bar_6.txt
	-rw-r--r--  1 et  staff  0 May  4 21:56 bar_7.txt
	-rw-r--r--  1 et  staff  0 May  4 21:56 bar_8.txt
	-rw-r--r--  1 et  staff  0 May  4 21:56 bar_9.txt
```


Script executed ```./bash_blind_rename.sh temp/ ```

Final status

```
Mac:Bash_blind_renamer et$ ls -lF temp/
total 8
-rw-r--r--   1 et  staff    0 May  4 21:56 007937B3F4F4D9F58B7D.txt
-rw-r--r--   1 et  staff    0 May  4 21:56 0A8894E19F79239FE547.txt
-rw-r--r--   1 et  staff    0 May  4 21:56 13840CB7444D948C078B.txt
-rw-r--r--   1 et  staff    0 May  4 21:56 36372FE3EFD9EAA7A04D.txt
-rw-r--r--   1 et  staff    0 May  4 21:56 36F6B95EC8138AE7A2E0.txt
-rw-r--r--   1 et  staff    0 May  4 21:56 3C27A89C60DE090DE1F6.txt
-rw-r--r--   1 et  staff    0 May  4 21:56 760A83AE04023DD099FC.txt
-rw-r--r--   1 et  staff    0 May  4 21:56 7F4C851ECC1AC1FDE5DF.txt
-rw-r--r--   1 et  staff    0 May  4 21:56 C2075C3D1E404186C675.txt
-rw-r--r--   1 et  staff    0 May  4 21:56 F27A8053EDC3CCE651A2.txt
-rw-r--r--   1 et  staff  367 May  4 22:01 name_dictionary.csv
drwxr-xr-x  12 et  staff  408 May  4 21:56 subfolder/

Mac:Bash_blind_renamer et$ ls -lF temp/subfolder/
total 0
-rw-r--r--  1 et  staff  0 May  4 21:56 bar_1.txt
-rw-r--r--  1 et  staff  0 May  4 21:56 bar_10.txt
-rw-r--r--  1 et  staff  0 May  4 21:56 bar_2.txt
-rw-r--r--  1 et  staff  0 May  4 21:56 bar_3.txt
-rw-r--r--  1 et  staff  0 May  4 21:56 bar_4.txt
-rw-r--r--  1 et  staff  0 May  4 21:56 bar_5.txt
-rw-r--r--  1 et  staff  0 May  4 21:56 bar_6.txt
-rw-r--r--  1 et  staff  0 May  4 21:56 bar_7.txt
-rw-r--r--  1 et  staff  0 May  4 21:56 bar_8.txt
-rw-r--r--  1 et  staff  0 May  4 21:56 bar_9.txt
```

Subfolder was not afected.

### To revert file names

```./revert_rename.sh folder``` Dictionary now called ```name_dictionary_DEPRECATED.csv```


# TO DO
1. Manage script with special characters in file name.   
~~2. Create file with new names to be used as input for manual counting.~~
