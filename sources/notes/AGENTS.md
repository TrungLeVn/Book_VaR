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

## Verification

- If R/package changes are involved, check whether `renv` is relevant.
- If Quarto render is requested, verify whether Quarto is installed before promising a build.
- After content edits, check chapter flow, figure/table references, and bibliography references.

## Typical requests

- Improve chapter writing while preserving meaning.
- Refactor R chunks for clarity or reuse.
- Add or revise sections in an existing chapter.
- Review current changes for build risks, reference issues, and analytical mistakes.
