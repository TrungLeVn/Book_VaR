# Current Status

Updated: 2026-06-12

## Project Type Guess

Book / specialist monograph. The immediate workflow is Word-first manuscript production with R scripts generating chapter figures, tables, estimates, and report outputs.

Quarto remains relevant only as a later ebook/online-book archive and conversion source.

## Available Assets

- Current Word manuscript candidates: `manuscript/current/Outline.docx` and `chuong_1_sach_chuyen_khao.docx` through `chuong_5_sach_chuyen_khao.docx`.
- Chapter 1 R workflow: `code/rscripts/ch01/` with setup, data, tables, figures, estimates, and export scripts.
- Raw data: `data/raw/VNI.csv`, `data/raw/vni_data.xlsx`.
- Processed data: `data/processed/` contains chapter 5-7 derived CSV/RDS assets.
- Outputs by chapter: `outputs/ch01/` through `outputs/ch05/` contain copied figure assets and Word chapter outputs where available.
- Sources: `sources/books/` contains nine reference books; `sources/bibliography/` contains BibTeX files.
- Quarto archive: `ebook_quarto_archive/` contains copied `_quarto.yml`, `index.qmd`, chapters, freeze outputs, and cache files.
- Verification run: `code/rscripts/ch01/run_ch01_all.R` ran successfully from the new location and generated chapter 1 figures, tables, estimates, and a Word report.
- Cleanup archive: old duplicate root folders and pre-Word workflow locations are gathered under `archive_pre_word_workflow/`.

## Missing Assets

- Chapter-specific R workflows for chapters 2-8 are scaffolded but not populated, except for copied historical output figures.
- Tables and estimates folders are mostly empty and should be filled by chapter R scripts.
- Chapter 1 generated tables and estimates have been synced into `outputs/ch01/`; other chapters still need generated tables and estimates.
- A single accepted final Word version has not been declared by the author beyond the current copied drafts.
- Citation style and bibliography integration for Word drafting still need a Word-oriented workflow decision.
- `archive_pre_word_workflow/` should be kept until the author confirms nothing else is needed from the old layout.

## Likely Current Stage

The book is in active restructuring and production planning. Chapter 1 is the most advanced for the new Word + Rscript workflow. Chapters 2-5 have Word drafts and historical figures. Chapters 6-8 appear to have Quarto chapter sources but no Word drafts in the current manuscript folder.

## Readiness For Blueprint Creation

Ready for a book manuscript workflow blueprint after the author confirms:

- target chapter list and chapter titles;
- whether chapters 6-8 should be converted from Quarto to Word drafts now;
- whether old Quarto figures should be treated as reusable outputs or regenerated from fresh chapter R scripts.

## Recommended Next Skill

Use `book-manuscript-workflow-blueprint` next to create a chapter-by-chapter production plan for Word drafting plus Rscript outputs.
