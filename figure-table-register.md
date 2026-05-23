# Figure And Table Register

Last updated: 2026-05-23

Purpose: track planned and existing figures/tables, their labels, source files, data, chapter use, and status.

## Register Rules

- Use Quarto labels beginning with `fig-` for figures and `tbl-` for tables.
- Do not hard-code figure or table numbers in manuscript prose.
- Every empirical figure/table should identify its data source, code source, and status.
- When a legacy figure/table is moved into an active chapter, update the destination chapter and status.

## Active Chapter Register

The active `chapters/ch01.qmd` to `chapters/ch08.qmd` files are currently blueprint-style outlines. They do not yet contain final executable figure/table chunks in the active chapter files.

| ID | Title or purpose | Type | Active chapter | Source/code file | Data source | Status | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- |
| `fig-ch01-return-language` | Price-to-return and return-distribution intuition | Figure | Ch. 1 | To be migrated from `chapters/legacy-ch01.qmd` | Simulated or VN-Index data, TBD | Planned | Should support the conceptual bridge from prices to returns. |
| `tbl-ch01-risk-language` | Core terms: return, loss, volatility, VaR, ES | Table | Ch. 1 | New or adapted from legacy material | Conceptual | Planned | Should align with `terminology.md`. |
| `tbl-ch02-volatility-to-tail-risk` | Volatility model -> implication for tail-risk measurement | Table | Ch. 2 | New synthesis table | Conceptual | Planned | Explicitly listed as missing in Ch. 2 outline. |
| `fig-ch03-model-taxonomy` | Taxonomy of VaR/ES model families and assumptions | Figure | Ch. 3 | New or adapted from `legacy-ch04.qmd` | Conceptual | Planned | Explicitly listed as missing in Ch. 3 outline. |
| `tbl-ch04-backtesting-tests` | Test statistic -> interpretation -> practical implication | Table | Ch. 4 | New or adapted from `legacy-ch04.qmd` | Method references | Planned | Explicitly listed as missing in Ch. 4 outline. |
| `fig-ch04-backtesting-workflow` | End-to-end model evaluation workflow | Figure | Ch. 4 | New | Conceptual | Planned | Should connect model forecast to acceptance policy. |
| `tbl-ch05-data-design` | VN-Index sample, variables, transformations, windows | Table | Ch. 5 | Adapt from `legacy-ch05.qmd` | `data/VNI.csv`, `data/vni_data.xlsx` | Planned; source-check needed | Must record exact sample period and provenance. |
| `fig-ch05-vnindex-price` | VN-Index level over sample | Figure | Ch. 5 | `legacy-ch05.qmd`; generated file exists under `chapters/ch05_files/figure-pdf/` | VN-Index data | Draft/generated | Verify code, data period, and caption before reuse. |
| `fig-ch05-vnindex-returns` | VN-Index returns and volatility clustering | Figure | Ch. 5 | `legacy-ch05.qmd`; generated file exists under `chapters/ch05_files/figure-pdf/` | VN-Index data | Draft/generated | Useful visual entry point for Ch. 5. |
| `tbl-ch06-volatility-candidates` | Volatility models carried forward to VaR/ES chapter | Table | Ch. 6 | New synthesis from Ch. 6 results | VN-Index data | Planned | Explicitly listed as missing in Ch. 6 outline. |
| `fig-ch06-volatility-forecast-comparison` | Forecast volatility vs proxy volatility | Figure | Ch. 6 | Adapt from `legacy-ch03.qmd` | VN-Index data | Planned | Should avoid overloading with too many model lines. |
| `tbl-ch07-model-summary` | Model -> strengths -> weaknesses -> suitable use-case | Table | Ch. 7 | New or adapted from `legacy-ch05.qmd` | Conceptual + empirical | Planned | Explicitly listed as missing in Ch. 7 outline. |
| `fig-ch07-var-comparison` | Selected VaR paths for key candidate models | Figure | Ch. 7 | Adapt from `legacy-ch05.qmd` | VN-Index data | Planned | Use only key models after backtesting logic. |
| `tbl-ch07-backtesting-summary` | Backtesting results by model and confidence level | Table | Ch. 7 | Adapt from `legacy-ch05.qmd` | VN-Index data | Planned; must re-run/check | Likely central empirical table. |
| `tbl-ch08-implication-map` | Finding -> method implication -> risk-management implication | Table | Ch. 8 | New synthesis | Ch. 7 results | Planned | Should prevent Ch. 8 from becoming a recycled conclusion. |

## Legacy And Generated Assets To Audit Later

| Source | Observed assets | Likely use | Status |
| --- | --- | --- | --- |
| `chapters/legacy-ch01.qmd` | Conceptual figures/tables on returns, VaR, ES, diagnostics, volatility. | Ch. 1 and selected support for Ch. 2/Ch. 3. | Source material; not yet migrated. |
| `chapters/legacy-ch02.qmd` | Rolling volatility, EWMA, GARCH, diagnostics, realized volatility examples. | Ch. 2 and Ch. 6. | Source material; not yet migrated. |
| `chapters/legacy-ch03.qmd` | VN-Index volatility measures, GARCH results, forecast comparison figures/tables. | Ch. 5 and Ch. 6. | Source material; not yet migrated. |
| `chapters/legacy-ch04.qmd` | VaR/ES model taxonomy, historical/parametric/semi-parametric/EVT examples, backtesting. | Ch. 3 and Ch. 4. | Source material; not yet migrated. |
| `chapters/legacy-ch05.qmd` | VN-Index VaR/ES empirical comparison, backtesting, tail severity. | Ch. 5, Ch. 7, Ch. 8. | Source material; not yet migrated. |
| `chapters/ch03_files/figure-pdf/` | Generated volatility and VN-Index figures from prior render/cache state. | Audit against current chapter plan before reuse. | Generated; do not edit manually. |
| `chapters/ch05_files/figure-pdf/` | Generated VN-Index and VaR/ES figures from prior render/cache state. | Audit against current chapter plan before reuse. | Generated; do not edit manually. |

## Open QA Items

- Extract a complete label inventory from legacy files before migration.
- Resolve any duplicate labels before moving chunks into active chapters.
- Confirm every empirical caption states data period and transformation.
- Ensure generated files under `chapters/*_files/` are treated as render outputs, not authoring sources.
