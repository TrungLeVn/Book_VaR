# Known Issues

Updated: 2026-06-12

- The temporary Microsoft Word lock file `artifacts/~$uong_1_sach_chuyen_khao.docx` was removed during cleanup.
- Multiple manuscript systems coexist: Word drafts, Quarto chapters, exported PDFs, and generated figures. The new structure separates them but does not delete old locations.
- Some Quarto output figures are duplicated between `_freeze/`, `chapters/*_files/`, and `outputs/`.
- Chapter 1 has a complete Rscript structure; other chapters need scripts created or migrated.
- Chapter 1 was verified from the new location. The first run installed the missing `patchwork` R package after a CRAN mirror was set in the copied setup script.
- `data/processed/` contains copied files from the old `data/derived/` folder. Script dependencies should be checked before removing or relocating old paths.
- Existing uncommitted changes were present before organization, including `artifacts/chuong_1_sach_chuyen_khao.docx` and `ch01_rscripts/`.
- Old duplicate source locations have been moved to `archive_pre_word_workflow/`, so Git will show many deletes from old paths and adds under the new/archive paths until the reorganization is committed.
