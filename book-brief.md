# Book Brief

Last updated: 2026-05-24

This file is the operational brief for the Quarto book project. Use it before revising chapters, adding R code, changing empirical results, or restructuring the manuscript.

## 1. Book Type And Positioning

- The book is a Vietnamese applied-finance monograph with teaching-oriented exposition on volatility and Value-at-Risk forecasting for financial returns.
- Positioning: a specialized applied finance book that connects return data, volatility modeling, VaR/Expected Shortfall, backtesting, and empirical evidence from the Vietnamese stock market.
- The book should read as one coherent argument, not as separate lecture notes, a code manual, or a collection of journal-style articles.
- Current Quarto structure: `index.qmd`, four unnumbered part openers, eight active chapters, and `references.qmd`.
- Active chapter files `chapters/ch01.qmd` to `chapters/ch08.qmd` define the current book plan. Legacy files `chapters/legacy-ch01.qmd` to `chapters/legacy-ch05.qmd` are source material for later migration, not the official chapter sequence.

## 2. Target Reader

- Primary readers: advanced undergraduate, master, and early PhD students in finance, banking, financial markets, risk management, and empirical finance.
- Secondary readers: lecturers, research assistants, analysts, and practitioners who need a structured bridge from volatility models to VaR/ES applications.
- Assumed background: basic finance, probability/statistics, and introductory time-series or econometrics.
- Do not assume readers are already fluent in GARCH, EVT, VaR backtesting, or R-based reproducible research.

## 3. Book Promise

After reading this book, the reader should be able to explain, estimate, forecast, compare, and critically evaluate volatility, Value-at-Risk, and Expected Shortfall models for financial return data, using reproducible R workflows and empirical applications to Vietnamese stock market data.

Each chapter must help the reader do at least one of these tasks: understand a concept, estimate a model, interpret diagnostics, compare forecasts, evaluate VaR/ES, or translate results into risk-management implications.

## 3A. Target Length And Pacing

- Working target for the finished manuscript: about 200 PDF pages, with a reasonable tolerance band around roughly 180-220 pages depending on appendix/reference growth.
- Current rendered draft as of 2026-05-24 is about 84 pages, after literature-enriched expansion of Ch. 1-Ch. 3; the remaining active chapters still need substantial development in both exposition and empirical interpretation.
- Conceptual chapters should be dense enough to teach the method clearly, but the largest page gains should come from the empirical chapters, synthesis chapter, and richer methodological interpretation.
- Do not inflate length with repetitive definitions or long code dumps; page growth should come from better explanation, stronger transitions, richer interpretation, and carefully chosen tables/figures.

## 4. Quantitative Depth

- Use advanced undergraduate to master-level exposition as the baseline; add early-PhD nuance only when model risk, diagnostics, or empirical design require it.
- Introduce the financial question before equations, then define symbols and explain the intuition.
- Quantitative material must connect model, data, diagnostics, interpretation, and risk-management use.
- Include enough detail for reproducibility and critical evaluation, but avoid derivations that do not change how the reader estimates, compares, or interprets models.
- Every empirical figure/table needs an interpretation paragraph: what it shows, what it supports, what it does not prove, and why it matters for VaR/ES or volatility forecasting.

## 5. Software And Reproducibility Rules

- Main tools: Quarto, R, `renv`, and PDF output through XeLaTeX as configured in `_quarto.yml`.
- Before changing render settings, read `_quarto.yml`.
- Before running or changing R code, check whether `renv::restore()` is needed.
- Treat R chunks and surrounding prose as one unit. If code changes a result, revise the interpretation, caption, and figure/table register.
- Quarto chapter files should normally not perform heavy computation during render.
- Heavy computation includes reusable data cleaning across chapters, model estimation, rolling estimation, GARCH fitting, forecasting, VaR/ES computation, EVT/POT, and backtesting.
- Heavy computation must be implemented in R functions and pipeline scripts outside `.qmd` files.
- Derived outputs should be saved under `data/derived/` as `.rds` objects with companion `.meta.yml` metadata files.
- Each metadata file should record input files, input hash, parameter hash, `code_version`, `created_at`, and R version.
- QMD files should load cached outputs and focus on tables, figures, exposition, and interpretation.
- Recompute should be explicit through scripts or by setting `BOOKVAR_RECOMPUTE=1`.
- If required cached outputs are missing, the relevant chapter should fail with a clear instruction rather than silently running long estimation during render.
- Production book chunks should normally hide code unless the section explicitly teaches the R workflow.
- R chunks kept inside `.qmd` files should be limited to display logic or lightweight pedagogical examples that run quickly.
- Use stable Quarto labels: figures `fig-...`, tables `tbl-...`, code listings `lst-...`; refer to them with Quarto cross-references rather than hard-coded numbers.
- Do not manually edit generated outputs in `_book/`, `_freeze/`, `chapters/*_files/`, or `chapters/*_cache/` unless the task is specifically about build artifacts.

## 6. Vietnamese Academic Style Rules

- Use clear Vietnamese academic prose: precise, explanatory, and readable, not administrative or slogan-like.
- Introduce English technical terms once using the pattern: Vietnamese term (English term, abbreviation). Later uses should follow `terminology.md`.
- Keep paragraphs purposeful: main idea, explanation, financial/econometric implication, then transition.
- Avoid long author-by-author literature surveys. Convert literature into concepts, model choices, debates, or empirical design lessons.
- Avoid repeating basic definitions across chapters. Define once, then remind briefly only when needed.
- Preserve the book's analytical voice: from research question -> model -> empirical design -> evidence -> implication.
- Do not add end-of-chapter review questions or discussion prompts by default; this project now follows monograph-style chapter closes based on synthesis and transition.

## 7. Source And Data Rules

- Main empirical focus: Vietnamese stock market data, especially VN-Index.
- Current local data inputs include `data/VNI.csv` and `data/vni_data.xlsx`; every empirical use must record source, extraction/download date, sample period, frequency, price field, transformations, and missing-value treatment.
- Market, regulation, Basel, historical-crisis, and institutional claims must be dated, jurisdiction-specific, and recorded in `fact-ledger.md` when material.
- Prefer official and authoritative sources: HOSE/HNX/Vietnam Stock Exchange, State Securities Commission, State Bank of Vietnam, Ministry of Finance, General Statistics Office, Vietnam Securities Depository and Clearing Corporation, Basel Committee/BIS, IMF, World Bank, OECD, and peer-reviewed or established textbook sources for stable methods.
- Do not invent citations, data periods, coefficients, VaR/ES values, backtesting results, regulatory thresholds, or market-event explanations.
- If a claim is useful but not yet verified, mark it as a hypothesis, example, or item for fact checking rather than final prose.

## 8. Chapter-Level Workflow Rules

- Before revising a chapter, read `_quarto.yml`, `index.qmd`, the active chapter file, and any referenced legacy source file.
- Start from chapter role: what this chapter contributes to the book's central promise and what the reader should be able to do after reading it.
- Keep chapter boundaries clear: Ch. 1 defines the risk language; Ch. 2 bridges volatility to tail risk; Ch. 3 maps VaR/ES model architectures; Ch. 4 designs evaluation; Ch. 5 establishes VN-Index data; Ch. 6 evaluates volatility forecasts; Ch. 7 compares VaR/ES models; Ch. 8 synthesizes implications.
- When migrating legacy material, adapt it to the active chapter's role instead of copying whole sections mechanically.
- When a chapter needs empirical or computational outputs, build them through external R functions and scripts first, then have the chapter read the saved results from `data/derived/`.
- After substantive chapter edits, check chapter flow, terminology, figure/table labels, bibliography references, R chunk dependencies, captions, and empirical interpretations.
- Do not revise manuscript chapters during book-brief or project-state tasks unless explicitly requested.
