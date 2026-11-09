# Blind Rename Files

Obfuscate filenames for unbiased analysis: macOS App & Bash Scripts

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.19227997.svg)](https://doi.org/10.5281/zenodo.19227997)
[![gh-pages](https://github.com/ToledoEM/Bash-blind-rename/actions/workflows/gh-pages.yml/badge.svg)](https://github.com/ToledoEM/Bash-blind-rename/actions/workflows/gh-pages.yml)
[![lint](https://github.com/ToledoEM/Bash-blind-rename/actions/workflows/lint.yml/badge.svg)](https://github.com/ToledoEM/Bash-blind-rename/actions/workflows/lint.yml)
[![GitHub](https://img.shields.io/badge/GitHub-ToledoEM%2FBash--blind--rename-181717?logo=github)](https://github.com/ToledoEM/Bash-blind-rename)

A macOS app and Bash scripts to blind-rename files in a folder for unbiased analysis. Original filenames are saved in a dictionary so they can be restored at any time.

---

## What it does

Each file in a folder is renamed to a 20-character uppercase hash derived from its original filename. A `name_dictionary.csv` mapping is saved alongside the files. Running the revert restores all original names and archives the dictionary.

Files created in the folder:

| File | Purpose |
| --- | --- |
| `name_dictionary.csv` | Maps original names to obfuscated names |
| `Analysis_file.csv` | List of obfuscated names only, for use during blind analysis |
| `name_dictionary_DEPRECATED.csv` | Renamed from dictionary after a successful revert |

Subfolders are never touched.

---

## How it works

```mermaid
flowchart TD
    A[Select folder] --> B{Run as root?}
    B -- yes --> X[Abort]
    B -- no --> C{name_dictionary.csv or<br/>Analysis_file.csv exists?}
    C -- yes --> X1[Abort: already renamed]
    C -- no --> D{name_dictionary_DEPRECATED.csv<br/>exists?}
    D -- yes --> X2[Abort: already randomized once<br/>delete DEPRECATED file]
    D -- no --> E{200 or more files?}
    E -- "yes, user answers N" --> X3[Exit, no changes]
    E -- "no, or user answers Y" --> F[Next file in folder<br/>top level only, subfolders skipped]
    F --> G{name_dictionary.csv, Analysis_file.csv,<br/>.DS_Store or Thumbs.db?}
    G -- yes --> F
    G -- no --> H[SHA hash of filename<br/>uppercase, first 20 alphanumeric chars]
    H --> I[Keep original extension]
    I --> J[Rename file]
    J --> K[Append Old,New to name_dictionary.csv<br/>append New to Analysis_file.csv]
    K -- more files --> F
    K -- all files done --> L[Blind analysis using Analysis_file.csv]
    L --> M[Revert: read name_dictionary.csv]
    M --> N[Restore original names]
    N --> O[Rename dictionary to<br/>name_dictionary_DEPRECATED.csv]
```

---

## macOS App

![BashBlindRename App](app.png)

Download `BashBlindRename.app` from the [releases page](https://github.com/ToledoEM/Bash-blind-rename/releases).

!!! note
    Requires macOS 12 or later. No installation: double-click and run.

1. Open the app.
2. Drag and drop your folder onto the drop zone.
3. Click **Blind Rename** to obfuscate filenames.
4. Click **Revert Rename** to restore original names.

---

## Bash Scripts

### Requirements

- Bash (macOS or Linux)
- `shasum`, pre-installed on macOS and most Linux systems

### Setup

```bash
chmod +x bash_blind_rename.sh revert_rename.sh
```

### Blind rename a folder

```bash
./bash_blind_rename.sh path/to/folder
```

### Revert to original names

```bash
./revert_rename.sh path/to/folder
```

---

## Example

**Starting folder:**

```bash
temp/
  foo_1.txt
  foo_2.txt
  foo_3.txt
  subfolder/
    bar_1.txt
```

**After `./bash_blind_rename.sh temp/`:**

```bash
temp/
  007937B3F4F4D9F58B7D.txt
  3C27A89C60DE090DE1F6.txt
  760A83AE04023DD099FC.txt
  name_dictionary.csv
  Analysis_file.csv
  subfolder/
    bar_1.txt
```

`subfolder/` and its contents are untouched.

**`name_dictionary.csv`:**

```bash
Oldname,Newname
foo_1.txt,007937B3F4F4D9F58B7D.txt
foo_2.txt,3C27A89C60DE090DE1F6.txt
foo_3.txt,760A83AE04023DD099FC.txt
```

**After `./revert_rename.sh temp/`:**

```bash
temp/
  foo_1.txt
  foo_2.txt
  foo_3.txt
  name_dictionary_DEPRECATED.csv
  subfolder/
    bar_1.txt
```

---

## Safety rules

!!! warning
    - Will not run if `name_dictionary.csv` or `Analysis_file.csv` already exist in the folder.
    - Will not run if `name_dictionary_DEPRECATED.csv` exists. Delete it first to re-run.
    - Does not run as root/superuser.
    - Does not recurse into subfolders.

---

## License

See [LICENSE](https://github.com/ToledoEM/Bash-blind-rename/blob/master/LICENSE).
