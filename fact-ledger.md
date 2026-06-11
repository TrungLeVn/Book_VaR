# Fact Ledger

Last updated: 2026-05-23

Purpose: track source status for factual claims about data, markets, regulation, historical episodes, Basel rules, and empirical results. This file is a control ledger, not final manuscript prose.

## Source Policy

- Prefer primary or institutional sources for Vietnam market facts: State Securities Commission, Vietnam Stock Exchange, HOSE, HNX, Vietnam Securities Depository and Clearing Corporation, State Bank of Vietnam, Ministry of Finance, General Statistics Office, and official legal portals.
- Prefer Basel Committee, BIS, IMF, World Bank, OECD, central banks, securities regulators, and official methodology documents for international risk-management and regulatory claims.
- Record jurisdiction, date/period, and status for every unstable claim.
- If a claim has not been checked, mark confidence as `missing` or `uncertain` rather than writing it as current fact.

## Current Claim Ledger

| Claim/topic | Source | Date/period | Jurisdiction | Status | Confidence | Use in manuscript |
| --- | --- | --- | --- | --- | --- | --- |
| VN-Index is the central empirical proxy for Vietnamese stock-market risk in this book. | `index.qmd`, `chapters/ch05.qmd`; data files `data/VNI.csv`, `data/vni_data.xlsx` | Sample period not yet recorded in ledger | Vietnam | Manuscript framing | Likely; needs data-source verification | Ch. 5-Ch. 7 |
| The book uses R for illustration and reproducibility. | `index.qmd`, `AGENTS.md`, `WORKFLOW_CODEX.md` | Project setup as of 2026-05-23 | Project-level | Internal repo fact | Verified from local files | Book brief, empirical chapters |
| The book is a Quarto PDF project using `renv`. | `AGENTS.md`, `WORKFLOW_CODEX.md`, `_quarto.yml` | Project setup as of 2026-05-23 | Project-level | Internal repo fact | Verified from local files | Workflow and reproducibility notes |
| The active book has four parts and eight chapters before references. | `_quarto.yml`, `chapters/part*.qmd`, `chapters/ch01.qmd` to `chapters/ch08.qmd` | Project setup as of 2026-05-23 | Project-level | Internal repo fact | Verified from local files | Chapter map |
| VN-Index return data contain stylized facts relevant to volatility and tail-risk modeling. | Data analysis in legacy chapters; local data files | Sample period and exact source not yet verified | Vietnam | Empirical claim | Missing until data and results are re-run | Ch. 5-Ch. 7 |
| Specific market episodes explain high-volatility periods in VN-Index. | To be sourced from official market data, official releases, or reputable secondary sources | Exact dates needed | Vietnam / global spillovers | Historical-market claim | Missing | Ch. 1, Ch. 5, Ch. 8 |
| Basel market-risk rules use VaR/ES in specific ways. | Basel Committee and BIS documents needed | Rule date/effective date needed | International | Regulatory claim | Missing | Possible box or Ch. 4/Ch. 8 context |
| Backtesting tests such as Kupiec, Christoffersen, and DQ are standard tools for VaR evaluation. | Method references and original papers/textbooks needed | Stable method claim; cite source edition/year | International / methodological | Method claim | Missing citation verification | Ch. 4, Ch. 7 |
| EVT/POT is appropriate only with careful threshold selection and sensitivity checks. | Method references needed | Stable method claim; cite source edition/year | Methodological | Method claim | Missing citation verification | Ch. 3, Ch. 7 |
| Latest values or last-sample VaR/ES results from VN-Index are reported. | Must be generated from local data and recorded with run date | Depends on data run | Vietnam | Empirical result | Missing until code is run and checked | Ch. 7 |

## Data Source Checklist For VN-Index

| Item | Required record | Current status |
| --- | --- | --- |
| Original data provider | Official exchange/vendor/source URL or file provenance | Missing |
| Download/extraction date | Calendar date | Missing |
| Sample start/end | First and last observation used | Missing |
| Frequency | Daily, weekly, etc. | Missing |
| Price field | Close, adjusted close, OHLC, total return, etc. | Missing |
| Missing-value treatment | Rule and number of affected rows | Missing |
| Return definition | Simple return or log return; decimal or percent | To be standardized |
| Reproducibility script | R chunk or script that loads and cleans data | Exists in legacy chapters, needs consolidation |

## Claims Requiring Verification Before Manuscript Use

- Any statement about current Vietnamese market structure, exchange organization, listing rules, trading mechanisms, or market capitalization.
- Any statement about Basel rules, regulatory capital, ES replacing VaR, traffic-light backtesting, or effective dates.
- Any statement linking a VN-Index volatility spike to a specific crisis, policy event, pandemic wave, geopolitical event, or domestic market event.
- Any exact numerical result from data, including sample size, return moments, VaR/ES values, violation rates, test statistics, and p-values.
