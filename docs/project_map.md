# Project Map: Word Manuscript + Chapter R Scripts

Updated: 2026-06-12

This repository is now organized around a Word-first book manuscript workflow. The Quarto material is preserved separately for a later online ebook conversion.

## Main Working Areas

```text
Book_VaR/
├── archive_pre_word_workflow/ # old duplicate/source locations kept for recovery
├── assets/
│   └── images/           # cover and future image assets
├── manuscript/
│   ├── current/          # current Word chapter drafts and outline
│   ├── drafts/           # future dated or versioned Word drafts
│   └── exported_pdf/     # exported PDFs from earlier chapter builds
├── code/
│   └── rscripts/
│       ├── ch01/         # active chapter 1 R workflow
│       ├── ch02/         # scaffold for chapter-specific R workflow
│       ├── ch03/
│       ├── ch04/
│       ├── ch05/
│       ├── ch06/
│       ├── ch07/
│       └── ch08/
├── data/
│   ├── raw/              # original input data copied from the old data folder
│   ├── processed/        # derived CSV/RDS outputs
│   └── examples/         # future teaching/demo datasets
├── outputs/
│   ├── ch01/
│   │   ├── figures/
│   │   ├── tables/
│   │   ├── estimates/
│   │   └── docx/
│   └── ch02/ ... ch08/   # same output structure by chapter
├── sources/
│   ├── books/            # reference books and source PDFs
│   ├── bibliography/     # BibTeX files
│   └── notes/            # project notes, maps, logs, terminology
├── ebook_quarto_archive/
│   ├── book/             # copied Quarto project files
│   ├── freeze/           # copied Quarto freeze outputs
│   └── cache/            # copied Quarto cache/index files
└── docs/                 # intake, status, organization notes
```

The repository root has been cleaned so the visible working folders are now:

```text
archive_pre_word_workflow/
assets/
code/
data/
docs/
ebook_quarto_archive/
manuscript/
outputs/
sources/
renv/
```

## Chapter 1 R Workflow

The active chapter 1 code now has this canonical location:

```text
code/rscripts/ch01/
├── run_ch01_all.R
├── ch01_all_in_one_Rscript.R
├── README.md
├── data/
├── R/
│   ├── 00_setup.R
│   ├── 01_data.R
│   ├── 02_tables.R
│   ├── 03_figures.R
│   ├── 04_estimates.R
│   └── 05_export_report.R
└── output/
    ├── figures/
    ├── tables/
    ├── estimates/
    └── docx/
```

Run from:

```bash
cd Book_VaR/code/rscripts/ch01
Rscript run_ch01_all.R
```

## Preservation Rule

The old source locations have been moved into `archive_pre_word_workflow/`. Obvious temporary/cache files such as `.DS_Store`, `.Rhistory`, Word lock files, and Python bytecode caches were removed.
