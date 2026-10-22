# Chapter 1 Code And Output Map

## Run

From the repository root:

```bash
Rscript '01. Chuong_01/code/ch01_all_in_one_Rscript.R'
```

Or from the chapter code folder:

```bash
Rscript ch01_all_in_one_Rscript.R
```

## Main Inputs

- Chapter-local input: `01. Chuong_01/data/raw/vnindex.csv`
- Shared raw inputs assigned to Chapter 4: `04. Chuong_04/data/raw/`

## Main Outputs

All generated artifacts should live in:

```text
01. Chuong_01/output/
```

Key subfolders:

- `figures/`
- `tables/`
- `estimates/`
- `docx/`

## Active Module Set

| File | Role |
| --- | --- |
| `ch01_all_in_one_Rscript.R` | Single entrypoint for the Chapter 1 workflow |
| `R/00_ch01_setup.R` | Packages, chapter paths, output folders, helpers |
| `R/01_ch01_appendix_tables_figures.R` | Chapter 1 appendix tables and figures |
| `R/99_ch01_export.R` | Export of PNG, CSV, and DOCX outputs |
| `R/run_ch01_all.R` | Convenience source runner |

## Editorial Rule

- Manuscript source of truth: `01. Chuong_01/chapter.md`
- DOCX copy: `01. Chuong_01/chapter.docx`
- Generated artifacts: `01. Chuong_01/output/`
- Shared raw inputs assigned to Chapter 4: `04. Chuong_04/data/raw/`
