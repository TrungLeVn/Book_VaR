# Upload Checklist For ChatGPT Atlas Project

Use this checklist when creating the ChatGPT Atlas Project for the VaR book.

## Project Name

`Book Project - Volatility and Value-at-Risk for Vietnamese Financial Returns`

## Upload First

These files give the Project its identity and working rules.

| Priority | File | Why |
| --- | --- | --- |
| 1 | `chatgpt_project_setup/Book_Project_Master_Brief_filled.md` | Main project-specific brief. |
| 2 | `chatgpt_project_setup/Project_Instructions_for_ChatGPT_Atlas.txt` | Project instructions to paste into the Project settings. |
| 3 | `sources/notes/book-brief.md` | Existing operational book brief. |
| 4 | `sources/notes/chapter-map.md` | Chapter roles, dependencies, transitions, and risks. |
| 5 | `sources/notes/terminology.md` | Vietnamese-English terminology and notation. |
| 6 | `sources/notes/fact-ledger.md` | Verification ledger for data, regulation, market facts, and empirical claims. |
| 7 | `sources/notes/reference-book-notes.md` | Benchmark lessons from reference books. |
| 8 | `docs/current_status.md` | Current production status and missing assets. |
| 9 | `docs/project_map.md` | Folder map for the Word-first workflow. |

## Upload Manuscript Drafts

Upload these after the setup files:

| File | Role |
| --- | --- |
| `manuscript/current/Outline.docx` | Current outline / table of contents candidate. |
| `manuscript/current/chuong_1_sach_chuyen_khao.docx` | Current Ch. 1 Word draft. |
| `manuscript/current/chuong_2_sach_chuyen_khao.docx` | Current Ch. 2 Word draft. |
| `manuscript/current/chuong_3_sach_chuyen_khao.docx` | Current Ch. 3 Word draft. |
| `manuscript/current/chuong_4_sach_chuyen_khao.docx` | Current Ch. 4 Word draft. |
| `manuscript/current/chuong_5_sach_chuyen_khao.docx` | Current Ch. 5 Word draft. |

## Upload Data And Outputs Selectively

Do not upload every generated figure/cache file at once. Start with:

| File or folder | Role |
| --- | --- |
| `data/raw/VNI.csv` | Main raw VN-Index data candidate. |
| `data/raw/vni_data.xlsx` | Alternative/source spreadsheet candidate. |
| `data/processed/ch05_ch07_pipeline.rds` | Derived pipeline object if ChatGPT can read it; otherwise use CSV summaries. |
| `data/processed/*.csv` | Processed summary data for Ch. 5-Ch. 7. |
| `outputs/ch01/tables/*.csv` | Verified Ch. 1 tables. |
| `outputs/ch01/estimates/*.csv` | Verified Ch. 1 estimates. |
| Selected `outputs/ch01/figures/*.png` | Only figures needed for review or insertion. |

For later chapter work, upload the specific chapter's figures/tables only when that chapter is being revised.

## Upload Bibliography

| File | Role |
| --- | --- |
| `sources/bibliography/references.bib` | Main citation database. |
| `sources/bibliography/references_volatility_var.bib` | VaR/volatility-focused references. |
| `sources/bibliography/apa.csl` | Citation style if needed. |

## Use Reference Books Carefully

The PDFs in `sources/books/` are useful benchmark and method references, but do not upload all at once unless the Project has enough file capacity and the task needs them.

Recommended initial benchmark set:

1. `Analysis of Financial Time Series, 3rd Edition .pdf`
2. `An Introduction to Analysis of Financial Data with R by Ruey S. Tsay (z-lib.org).pdf`
3. `Introductory Econometrics for Finance -- Chris Brooks.pdf`
4. `Quantitative Risk Management_ Concepts, Techniques and Tools.pdf`
5. `Value at Risk, 3rd Ed.pdf`

Use them for structure, definitions, method discipline, and citation checking. Do not copy prose, examples, figures, exercises, or distinctive chapter organization.

## Do Not Upload Initially

Avoid uploading these unless needed for a specific recovery/conversion task:

- Entire `archive_pre_word_workflow/`
- Entire `ebook_quarto_archive/cache/`
- Entire `ebook_quarto_archive/freeze/`
- `.git/`, `.DS_Store`, temporary files, lock files
- Duplicate PDF/PNG figure folders
- Old generated cache artifacts

## Suggested First Chat

Paste this after the project is created and setup files are uploaded:

```text
Using the uploaded Book Project Master Brief, chapter map, terminology register, fact ledger, current status, and manuscript drafts, create a concise project orientation for this VaR monograph. Identify: central thesis, current manuscript status, chapter-by-chapter production risks, missing verification tasks, and the next 10 actions for producing a coherent Word-first manuscript.
```

