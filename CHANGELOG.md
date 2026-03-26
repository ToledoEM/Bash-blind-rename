# CHANGELOG

## v0.4 — 2026-03-26

### Fixed

- `bash_blind_rename.sh`: guard checks (root, directory, dictionary) now run before the 200-file prompt
- `bash_blind_rename.sh`: replaced `find | while` pipeline with process substitution to fix `set -e` / `pipefail` interaction in subshell
- `bash_blind_rename.sh`: removed dead `IFS=$'\n'` assignment that had no effect on the rename loop
- `bash_blind_rename.sh`: switched CSV writes to `printf` to avoid comma-in-filename corruption
- `revert_rename.sh`: added `set -euo pipefail` and argument-count check
- `revert_rename.sh`: CSV parsing now splits only on the first comma, handling filenames that contain commas
- `BlindRenameApp.swift` / `ContentView.swift`: removed unused `base` variable
- `BlindRenameApp.swift` / `ContentView.swift`: subdirectories are now skipped during rename (matches Bash behaviour)
- `BlindRenameApp.swift` / `ContentView.swift`: CSV write errors are now reported instead of silently swallowed
- `BlindRenameApp.swift` / `ContentView.swift`: partial rename on error now rolls back already-renamed files and cleans up partial CSVs
- `BlindRenameApp.swift` / `ContentView.swift`: `revertRename` move and dictionary-deprecation failures are now reported with descriptive errors

---

## 2025-08-16

- Added Zenodo DOI badge to README

## 2025-07-06

- Added native SwiftUI macOS app (`BlindRenameApp.swift`) as an alternative to the Bash scripts
- Distributed pre-built app (`app/BashBlindRename.app`) and Xcode project archive

## 2025-06-21

- Modernised Bash scripts for 2025 compatibility (`set -euo pipefail`, `find -print0`, null-delimited reads)
- Replaced Platypus macOS wrapper with native Swift app

## 2017-07-14

- Fixed macOS (`shasum`) compatibility — script previously did not work on macOS
- Updated README with macOS-specific instructions

## 2017-07-13

- Added `Analysis_file.csv` output containing only new (obfuscated) filenames for use during blind analysis
- Improved handling of filenames and paths containing spaces
- Various README and script refinements

## 2017-07-02

- Added macOS app wrapper via Platypus (DMG distribution)

## 2017-05-06

- Added `revert_rename.sh` to restore original filenames from `name_dictionary.csv`
- Dictionary renamed to `name_dictionary_DEPRECATED.csv` after a successful revert

## 2017-05-04

- Initial release: `bash_blind_rename.sh` renames files in a folder to 20-character uppercase SHA256 hash prefixes, writing the mapping to `name_dictionary.csv`
