#!/usr/bin/env bash
# Tests bash_blind_rename.sh and revert_rename.sh using test_example/

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
TARGET="$SCRIPT_DIR/test_example"
LOG="$SCRIPT_DIR/test_rename.log"

PASS=0
FAIL=0

log()  { echo "$1" | tee -a "$LOG"; }
ok()   { log "  [PASS] $1"; PASS=$((PASS+1)); }
fail() { log "  [FAIL] $1"; FAIL=$((FAIL+1)); }

# Start fresh log
: > "$LOG"

log "=== Setup: creating test_example/ ==="
bash "$SCRIPT_DIR/make_test_folder.sh" 2>&1 | tee -a "$LOG"

log ""
log "=== Phase 1: blind rename ==="
bash "$REPO_DIR/bash_blind_rename.sh" "$TARGET" 2>&1 | tee -a "$LOG"

[ -f "$TARGET/name_dictionary.csv" ] && ok "name_dictionary.csv created" || fail "name_dictionary.csv missing"
[ -f "$TARGET/Analysis_file.csv" ]   && ok "Analysis_file.csv created"   || fail "Analysis_file.csv missing"

remaining=$(find "$TARGET" -maxdepth 1 -name "foo_*.txt" | wc -l | tr -d ' ')
[ "$remaining" -eq 0 ] && ok "Original foo_ files renamed" || fail "$remaining original foo_ files still present"

renamed=$(find "$TARGET" -maxdepth 1 -type f -name "*.txt" | wc -l | tr -d ' ')
[ "$renamed" -eq 10 ] && ok "10 renamed .txt files present" || fail "Expected 10 renamed .txt files, got $renamed"

bar_count=$(find "$TARGET/subfolder" -maxdepth 1 -name "bar_*.txt" | wc -l | tr -d ' ')
[ "$bar_count" -eq 10 ] && ok "Subfolder bar_ files untouched" || fail "Subfolder bar_ files altered ($bar_count found)"

dict_lines=$(wc -l < "$TARGET/name_dictionary.csv" | tr -d ' ')
[ "$dict_lines" -eq 11 ] && ok "name_dictionary.csv has 11 lines (header + 10)" || fail "name_dictionary.csv has $dict_lines lines"

analysis_lines=$(wc -l < "$TARGET/Analysis_file.csv" | tr -d ' ')
[ "$analysis_lines" -eq 11 ] && ok "Analysis_file.csv has 11 lines (header + 10)" || fail "Analysis_file.csv has $analysis_lines lines"

output=$(bash "$REPO_DIR/bash_blind_rename.sh" "$TARGET" 2>&1 || true)
log "$output"
echo "$output" | grep -q "already renamed" && ok "Re-run blocked correctly" || fail "Re-run not blocked"

log ""
log "=== Phase 2: revert rename ==="
bash "$REPO_DIR/revert_rename.sh" "$TARGET" 2>&1 | tee -a "$LOG"

restored=$(find "$TARGET" -maxdepth 1 -name "foo_*.txt" | wc -l | tr -d ' ')
[ "$restored" -eq 10 ] && ok "Original foo_ files restored" || fail "Expected 10 foo_ files, got $restored"

[ ! -f "$TARGET/name_dictionary.csv" ]            && ok "name_dictionary.csv removed"              || fail "name_dictionary.csv still present"
[ -f "$TARGET/name_dictionary_DEPRECATED.csv" ]   && ok "name_dictionary_DEPRECATED.csv created"   || fail "name_dictionary_DEPRECATED.csv missing"
[ -f "$TARGET/Analysis_file.csv" ]                && ok "Analysis_file.csv still present"          || fail "Analysis_file.csv missing after revert"

# Remove Analysis_file.csv so the DEPRECATED check is reached
rm -f "$TARGET/Analysis_file.csv"
output2=$(bash "$REPO_DIR/bash_blind_rename.sh" "$TARGET" 2>&1 || true)
log "$output2"
echo "$output2" | grep -q "randomized once" && ok "Re-run after revert blocked correctly" || fail "Re-run after revert not blocked (got: $output2)"

log ""
log "=== Results: $PASS passed, $FAIL failed ==="
[ "$FAIL" -eq 0 ] && exit 0 || exit 1
