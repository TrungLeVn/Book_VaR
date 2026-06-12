# Repository Organization Plan

Updated: 2026-06-12

## Recommended Track

Use the Book Track, with a Word-first production workflow and chapter-specific R scripts.

The Research Article Track is not recommended for the whole repository because the assets, outline, chapters, and references indicate a specialist book/monograph rather than a single paper.

## Book Track Structure

The active structure is:

```text
manuscript/current/          # current Word drafts
code/rscripts/chXX/          # chapter-specific R workflows
data/raw/                    # original data inputs
data/processed/              # derived data used by chapters
outputs/chXX/figures/        # generated or copied figures by chapter
outputs/chXX/tables/         # generated tables by chapter
outputs/chXX/estimates/      # estimates/model outputs by chapter
outputs/chXX/docx/           # chapter report/docx outputs from scripts
sources/books/               # source/reference books
sources/bibliography/        # BibTeX files
sources/notes/               # planning and terminology notes
ebook_quarto_archive/        # Quarto material reserved for later ebook work
archive_pre_word_workflow/   # old duplicate layout kept outside the active workflow
docs/                        # project intake and organization documentation
```

## Chapter R Script Standard

Each chapter should follow the chapter 1 pattern:

```text
code/rscripts/chXX/
├── run_chXX_all.R
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

## Quarto/Ebook Handling

Quarto files are copied into `ebook_quarto_archive/`:

- `ebook_quarto_archive/book/` for `_quarto.yml`, `index.qmd`, `references.qmd`, and chapter `.qmd` files;
- `ebook_quarto_archive/freeze/` for freeze outputs;
- `ebook_quarto_archive/cache/` for Quarto cache/index files.

This keeps the ebook pathway available without making Quarto the current writing system.

## Safety Note

Important assets from old locations are preserved under `archive_pre_word_workflow/` or copied into the active workflow. Obvious temporary/cache files were removed.
