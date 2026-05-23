# Migration Plan

Last updated: 2026-05-23

Purpose: keep the current legacy-to-active migration roadmap in one place so future chapter edits follow the same structure, terminology, and risk controls.

## Scope And Working Rule

- Active structure: `chapters/ch01.qmd` to `chapters/ch08.qmd` is the official book structure.
- Legacy source pool: `chapters/legacy-ch01.qmd` to `chapters/legacy-ch05.qmd` are source material only.
- Migration principle: adapt useful legacy material into the active chapter role; do not mechanically copy whole legacy sections.
- Control files to consult during migration: `book-brief.md`, `chapter-map.md`, `reference-book-notes.md`, `terminology.md`, `figure-table-register.md`, `fact-ledger.md`, and `revision-log.md`.

## Recommended Migration Order

1. Ch. 1 and Ch. 2
Reason: lowest structural risk; establishes language and volatility bridge cleanly.
2. Ch. 3 and Ch. 4
Reason: method architecture and evaluation design should be stable before empirical chapters expand.
3. Ch. 5
Reason: creates the shared VN-Index empirical base for Ch. 6 and Ch. 7.
4. Ch. 6
Reason: identifies defensible volatility candidates before VaR/ES comparison.
5. Ch. 7
Reason: main empirical comparison depends on Ch. 3-Ch. 6 being settled.
6. Ch. 8
Reason: synthesis should be written only after the empirical and method chapters are stable.

## Chapter-By-Chapter Plan

### Ch. 1

- Active file: `chapters/ch01.qmd`
- Role: foundation chapter on risk language, returns, distributions, volatility, VaR, ES, and left-tail risk.
- Current state: initial migrated draft exists.
- Legacy sources:
  - `chapters/legacy-ch01.qmd`
- Build target:
  - keep Ch. 1 conceptual;
  - explain price vs return;
  - introduce return and loss language;
  - explain left-tail risk and volatility as risk scale;
  - introduce VaR and ES intuitively;
  - end with a bridge to conditional volatility in Ch. 2.
- Figures/tables:
  - `fig-ch01-return-language`
  - `tbl-ch01-risk-language`
- R chunk policy:
  - keep only conceptual/demo chunks;
  - do not expand into diagnostics-heavy or empirical material.
- Main risks:
  - overlap with Ch. 2 on volatility basics;
  - drift into VaR taxonomy or backtesting.

### Ch. 2

- Active file: `chapters/ch02.qmd`
- Role: conditional volatility as a bridge to tail-risk measurement.
- Current state: blueprint outline.
- Legacy sources:
  - `chapters/legacy-ch02.qmd`
  - selective support from `chapters/legacy-ch01.qmd`
- Build target:
  - volatility as unobserved object;
  - rolling volatility and EWMA;
  - ARCH/GARCH logic and diagnostics;
  - explicit bridge from volatility forecast to tail-risk measurement;
  - clear statement that volatility is an input, not the full answer.
- Figures/tables:
  - create `tbl-ch02-volatility-to-tail-risk`
  - migrate only selected conceptual visuals if needed
- R chunk policy:
  - rewrite demo chunks cleanly;
  - avoid carrying long catalog-style examples.
- Main risks:
  - repeating Ch. 1 concepts;
  - importing too much material that belongs in empirical Ch. 6.

### Ch. 3

- Active file: `chapters/ch03.qmd`
- Role: VaR/ES model architecture and assumptions.
- Current state: blueprint outline.
- Legacy sources:
  - `chapters/legacy-ch04.qmd`
  - selective support from `chapters/legacy-ch01.qmd`
- Build target:
  - assumption map for model families;
  - historical simulation;
  - parametric and volatility-based VaR;
  - quantile-based or semi-parametric approaches;
  - EVT/POT and selected extensions;
  - synthesis by use-case rather than formula list.
- Figures/tables:
  - create `fig-ch03-model-taxonomy`
  - optionally add one compact synthesis table later
- R chunk policy:
  - keep illustrations compact;
  - do not turn Ch. 3 into a simulation-heavy methods notebook.
- Main risks:
  - overlap with Ch. 4 on backtesting;
  - drift into full empirical comparison.

### Ch. 4

- Active file: `chapters/ch04.qmd`
- Role: model evaluation, out-of-sample design, and backtesting.
- Current state: blueprint outline.
- Legacy sources:
  - `chapters/legacy-ch04.qmd`
  - selective support from `chapters/legacy-ch05.qmd`
- Build target:
  - move from in-sample to out-of-sample design;
  - explain core VaR backtesting tests;
  - introduce tail severity beyond violation counts;
  - explain model acceptance policy and practical interpretation.
- Figures/tables:
  - create `tbl-ch04-backtesting-tests`
  - create `fig-ch04-backtesting-workflow`
- R chunk policy:
  - use only small illustrations of evaluation logic;
  - avoid importing large empirical result blocks.
- Main risks:
  - repeating Ch. 3 method definitions;
  - pre-empting Ch. 7’s empirical backtesting narrative.

### Ch. 5

- Active file: `chapters/ch05.qmd`
- Role: VN-Index data design, return construction, stylized facts, and empirical windows.
- Current state: blueprint outline.
- Legacy sources:
  - `chapters/legacy-ch03.qmd`
  - `chapters/legacy-ch05.qmd`
- Build target:
  - define sample, variables, and transformations;
  - justify VN-Index as the empirical core;
  - present compact descriptive diagnostics and stylized facts;
  - define windows, horizons, and comparison logic for later chapters.
- Figures/tables:
  - `tbl-ch05-data-design`
  - `fig-ch05-vnindex-price`
  - `fig-ch05-vnindex-returns`
- R chunk policy:
  - migrate and rewrite data-loading and diagnostic chunks;
  - keep forecast and VaR/ES result chunks out of Ch. 5.
- Main risks:
  - repeating descriptive statistics in Ch. 6;
  - slipping into an empirical results chapter too early.

### Ch. 6

- Active file: `chapters/ch06.qmd`
- Role: volatility measurement and forecasting on VN-Index.
- Current state: blueprint outline.
- Legacy sources:
  - `chapters/legacy-ch03.qmd`
- Build target:
  - benchmark volatility measures;
  - fit and interpret GARCH-type models;
  - compare OHLC-based proxies where useful;
  - run common forecast comparison across horizons;
  - conclude which volatility candidates move forward to Ch. 7.
- Figures/tables:
  - `tbl-ch06-volatility-candidates`
  - `fig-ch06-volatility-forecast-comparison`
  - possible later compact ranking table if needed
- R chunk policy:
  - refactor model-fitting and forecast-exercise chunks;
  - collapse repetitive output tables into compact summaries.
- Main risks:
  - overlap with Ch. 2 on theory;
  - overlap with Ch. 5 on data description;
  - too many forecast metrics without synthesis.

### Ch. 7

- Active file: `chapters/ch07.qmd`
- Role: empirical comparison of VaR/ES models on VN-Index.
- Current state: blueprint outline.
- Legacy sources:
  - `chapters/legacy-ch05.qmd`
  - method logic from `chapters/legacy-ch04.qmd`
  - volatility shortlist support from `chapters/legacy-ch03.qmd`
- Build target:
  - compare historical, parametric, volatility-based, quantile-based, and EVT/POT families under one design;
  - report VaR and ES as joint evidence;
  - present backtesting as accountability, not just output;
  - end with conditional conclusions, not one universal winner.
- Figures/tables:
  - `tbl-ch07-model-summary`
  - `fig-ch07-var-comparison`
  - `tbl-ch07-backtesting-summary`
  - possible later ES/tail-severity support item
- R chunk policy:
  - rewrite legacy empirical chunks into one coherent pipeline;
  - avoid carrying snapshot tables and redundant family-by-family displays into the main text.
- Main risks:
  - becoming a table dump;
  - repeating Ch. 4’s evaluation logic instead of applying it.

### Ch. 8

- Active file: `chapters/ch08.qmd`
- Role: methodological and risk-management synthesis.
- Current state: needs major build.
- Legacy sources:
  - selective material from `chapters/legacy-ch03.qmd`
  - selective material from `chapters/legacy-ch04.qmd`
  - selective material from `chapters/legacy-ch05.qmd`
- Build target:
  - extract method lessons from the full comparison;
  - translate results into model-choice guidance;
  - discuss limits of the current empirical design;
  - propose future extensions.
- Figures/tables:
  - create `tbl-ch08-implication-map`
- R chunk policy:
  - minimal or none;
  - synthesis should be prose-led, not code-led.
- Main risks:
  - recycling Ch. 7 results without adding interpretation;
  - adding unverified market or regulatory claims.

## Control File Update Rules During Migration

- Update `terminology.md` when a migrated section introduces or normalizes a term, abbreviation, or notation.
- Update `figure-table-register.md` whenever a figure or table is migrated, relabeled, added, or dropped.
- Update `fact-ledger.md` before any current, regulatory, historical, or exact empirical claim enters manuscript prose.
- Update `revision-log.md` after each substantive chapter migration pass.
- Update `chapter-map.md` only if chapter role or inter-chapter boundaries materially change.
- Update `book-brief.md` only if book-level positioning, audience, scope, or software policy changes.

## Migration QA Checklist

- Does the migrated material strengthen the active chapter role in `chapter-map.md`?
- Has older terminology been normalized to `terminology.md`?
- Have duplicate labels been avoided?
- Have generated files in `_book/`, `_freeze/`, `chapters/*_files/`, and `chapters/*_cache/` been left untouched?
- Has empirical or unstable factual content been recorded in `fact-ledger.md` before being treated as final prose?
- Does the chapter end with a clean bridge to the next chapter rather than a recycled legacy conclusion?
