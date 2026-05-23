# Repo Guide For Codex

## Project shape

- This is a Quarto book project that renders to PDF.
- Main config: `_quarto.yml`
- Main text: `index.qmd`, `chapters/*.qmd`, `references.qmd`
- Data inputs: `data/`
- Bibliography: `references.bib`, `references_volatility_var.bib`
- Generated outputs: `_book/`, `_freeze/`, `chapters/*_files/`, `chapters/*_cache/`

## Working rules

- Prefer minimal edits scoped to the requested chapter or file.
- Read `_quarto.yml` before changing book structure or render-related settings.
- Preserve Vietnamese academic tone unless the user asks for a rewrite.
- Treat R code chunks and surrounding explanations as one unit; avoid changing one without checking the other.
- When editing references, keep citation keys stable unless the user asks otherwise.
- Do not casually rewrite generated files in `_book/` or `_freeze/` unless the task is specifically about render outputs.
- Quarto chapter files should normally not perform heavy computation during render.
- Heavy computation includes reusable data cleaning, model estimation, rolling estimation, GARCH fitting, volatility forecasting, VaR/ES computation, EVT/POT, backtesting, repeated simulation, and other long loops.
- Heavy computation should be implemented in R functions and pipeline scripts outside `.qmd` files.
- Pipeline outputs should be written under `data/derived/` as `.rds` objects with companion `.meta.yml` metadata files.
- Metadata for derived outputs should record input files, input hash, parameter hash, `code_version`, `created_at`, and R version.
- QMD files should normally load cached outputs from `data/derived/` and focus on tables, figures, exposition, and interpretation.
- R chunks inside `.qmd` files are allowed only for display tasks or lightweight pedagogical examples that run quickly.
- Recompute should be explicit through scripts or by setting `BOOKVAR_RECOMPUTE=1`.
- If required cached outputs are missing, chapter code should fail with a clear instruction rather than silently running long estimation during render.
- Generated files under `_book/`, `_freeze/`, `chapters/*_files/`, and `chapters/*_cache/` must not be edited manually.

## Verification

- If R/package changes are involved, check whether `renv` is relevant.
- If Quarto render is requested, verify whether Quarto is installed before promising a build.
- After content edits, check chapter flow, figure/table references, and bibliography references.

## Typical requests

- Improve chapter writing while preserving meaning.
- Refactor R chunks for clarity or reuse.
- Add or revise sections in an existing chapter.
- Review current changes for build risks, reference issues, and analytical mistakes.
