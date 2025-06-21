# Blind Rename Files in Folder

A Bash script to blind-rename files in a folder, saving the mapping of old and new names in a dictionary. Includes a script to revert file names to their original state.

Works on **macOS** and **Linux** (Debian, Ubuntu, Raspbian).

## Features

- Generates pseudo-random, uppercase alphanumeric filenames using `shasum`.
- Prevents destructive outcomes: cannot be run as superuser/root.
- Ignores `name_dictionary.csv` and `Analysis_file.csv` during renaming.
- Preserves file extensions.
- Detects if a folder has already been randomized (checks for `name_dictionary.csv`).
- Only processes files in the specified folder (does not recurse into subfolders).
- Reduces risk of filename collisions by using a hash of the filename.
- Detects if a folder has been previously obfuscated (checks for `name_dictionary_DEPRECATED.csv`).
- Creates `Analysis_file.csv` with only new names for manual analysis.
- Handles filenames and folder names with spaces or special characters.

## Requirements

- Bash (tested on macOS and Linux)
- `shasum` utility (pre-installed on most systems)

## Usage

1. Make the script executable:

   ```bash
   chmod +x bash_blind_rename.sh
   chmod +x revert_rename.sh
   ```

2. To obfuscate the names in a folder (e.g., `temp/`):

   ```bash
   ./bash_blind_rename.sh temp/
   ```

   - Only files in `temp/` will be renamed. Subfolders are not affected.
   - A mapping is saved in `temp/name_dictionary.csv`.
   - New names are listed in `temp/Analysis_file.csv` for manual analysis.

3. To revert file names:

   ```bash
   ./revert_rename.sh temp/
   ```

   - Uses `name_dictionary.csv` to restore original names.
   - The dictionary is renamed to `name_dictionary_DEPRECATED.csv` after use.

## Example

**Before:**

```
$ ls temp/
foo1.txt  foo2.txt  ...  subfolder/
$ ls temp/subfolder/
bar1.txt  bar2.txt  ...
```

**After running:**

```
$ ./bash_blind_rename.sh temp/
$ ls temp/
A1B2C3D4E5F6G7H8I9J0.txt  ...  name_dictionary.csv  Analysis_file.csv  subfolder/
$ ls temp/subfolder/
bar1.txt  bar2.txt  ...
```

Subfolders are not affected.

## Notes

- Do **not** run as root or with `sudo`.
- If `name_dictionary.csv` or `Analysis_file.csv` exists, the script will not run to prevent accidental overwrites.
- If `name_dictionary_DEPRECATED.csv` exists, delete it before running the script again.

## .gitignore

The `.gitignore` file ignores the `temp/` folder and common system files.

## License

See [LICENSE](LICENSE).

---

*Contributions welcome!*
