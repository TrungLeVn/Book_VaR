# Chapter R Scripts

This folder is the canonical location for chapter-specific R workflows.

Each chapter should follow the chapter 1 layout:

```text
chXX/
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

Chapter 1 has been copied from the existing `ch01_rscripts/` folder. Chapters 2-8 are scaffolded for later migration or new scripts.
