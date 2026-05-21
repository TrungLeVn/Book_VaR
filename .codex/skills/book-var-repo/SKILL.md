---
name: book-var-repo
description: Use this skill when working in the Book_VaR repository for Quarto/R analysis tasks including rendering chapters, validating data files, and updating figures in _freeze.
---

# Book_VaR Repository Skill

## When to use
Use this skill whenever the task involves editing, validating, or rendering content in this repository.

## Repo workflow
1. Start by identifying the target files and whether they are source files (`chapters/`, `.qmd`, `.R`) or generated outputs (`_freeze/`).
2. Prefer changing source files first; only update generated files when explicitly requested or when regeneration is necessary.
3. Before finalizing, run targeted checks relevant to the changed files.

## Common checks
- For R script syntax and quick run sanity:
  - `Rscript -e "source('SourceOil.R')"`
- For Quarto project validation/render:
  - `quarto check`
  - `quarto render`

## Data and output conventions
- Keep canonical datasets in `data/`.
- Treat `_freeze/` as render artifacts; avoid manual edits unless fixing generated metadata formatting.
- Do not rename Vietnamese-language files unless requested.

## Task routing
- **Data updates**: inspect `data/*.csv` and associated scripts first.
- **Narrative/report updates**: edit chapter source files, then render to refresh figures.
- **Figure issues**: verify both source code chunks and matching files under `_freeze/`.

## Safety notes
- Avoid broad destructive commands.
- Keep changes minimal and scoped to the task.
