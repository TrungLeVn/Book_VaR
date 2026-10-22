#!/usr/bin/env bash
# B04 — smoke-run every existing Ch1–Ch3 R script in a throwaway copy of the
# project, so chapter output/ and data/raw/ in the Drive folder are never written.
# Usage (from 02. Drafts/): bash results/B04_20261022-1448_verify/run_scripts_sandbox.sh <sandbox_dir>
# Diagnostic mode: B04_PATCH=1 applies officer::body_add_flextable -> flextable::body_add_flextable
# to the SANDBOX copies only (chapter code untouched) and logs to logs_patched/.
set -u
# R needs a UTF-8 locale to parse the Vietnamese strings in the scripts.
export LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8
PROJ="$(pwd)"
RUN="$PROJ/results/B04_20261022-1448_verify"
SB="${1:?sandbox dir required}"
ROOT="$SB/02. Drafts"
LEGACY_REL="99. Archive/2026-08-15_pre-restructure/legacy_numbering_pending_review/vnindex_daily.csv"

rm -rf "$SB"; mkdir -p "$ROOT/renv" "$SB/$(dirname "$LEGACY_REL")"
cp "$PROJ/Volatility-VaR.Rproj" "$PROJ/.Rprofile" "$PROJ/renv.lock" "$ROOT/"
cp "$PROJ/renv/activate.R" "$PROJ/renv/settings.json" "$ROOT/renv/"
ln -s "$PROJ/renv/library" "$ROOT/renv/library"          # same installed library as the project
cp "$PROJ/../$LEGACY_REL" "$SB/$LEGACY_REL"                # Ch3 archive-fallback input
for ch in "01. Chuong_01" "02. Chuong_02" "03. Chuong_03"; do
  mkdir -p "$ROOT/$ch"; cp -R "$PROJ/$ch/code" "$PROJ/$ch/data" "$ROOT/$ch/"
done
TAG=""
if [ "${B04_PATCH:-0}" = "1" ]; then
  TAG="_patched"
  sed -i '' 's/officer::body_add_flextable/flextable::body_add_flextable/' \
    "$ROOT/01. Chuong_01/code/R/00_ch01_setup.R" "$ROOT/02. Chuong_02/code/R/ch02_all_tables_figures_appendix.R"
fi
LOGS="$RUN/logs$TAG"
mkdir -p "$LOGS"
run() {  # name, working dir, script
  local name="$1" wd="$2" script="$3" t0 t1 rc
  t0=$(date +%s)
  ( cd "$wd" && Rscript "$script" ) > "$LOGS/$name.log" 2>&1; rc=$?
  t1=$(date +%s)
  printf '%s\t%s\t%s\n' "$name" "$rc" "$((t1 - t0))" >> "$LOGS/exit_codes.tsv"
}
printf 'script\texit_code\tseconds\n' > "$LOGS/exit_codes.tsv"
# Run each script from its own folder: Rscript encodes spaces in --file= as "~+~",
# which breaks the scripts' self-location when the path contains "0X. Chuong_0X".
run ch01_run_ch01_all       "$ROOT/01. Chuong_01/code/R" "run_ch01_all.R"
run ch01_all_in_one         "$ROOT/01. Chuong_01/code"   "ch01_all_in_one_Rscript.R"
run ch02_all_tables_figures "$ROOT/02. Chuong_02/code/R" "ch02_all_tables_figures_appendix.R"
run ch03_volatility         "$ROOT/03. Chuong_03/code/R" "run_chapter03_volatility.R"
cat "$LOGS/exit_codes.tsv"

# Inventory of files the scripts produced in the sandbox (path, bytes, SHA-256)
( cd "$ROOT" && find "01. Chuong_01/output" "02. Chuong_02/output" "03. Chuong_03/output" "03. Chuong_03/data" -type f 2>/dev/null \
  | sort | while read -r f; do printf '%s\t%s\t%s\n' "$f" "$(stat -f %z "$f")" "$(shasum -a 256 "$f" | cut -d' ' -f1)"; done ) \
  > "$RUN/sandbox_outputs$TAG.tsv"
echo "outputs: $(wc -l < "$RUN/sandbox_outputs$TAG.tsv") files"
