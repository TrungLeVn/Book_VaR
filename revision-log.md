# Revision Log

Last updated: 2026-05-23

Purpose: record major editorial, structural, methodological, and workflow decisions. Minor sentence edits do not need entries unless they change the book's argument or reproducibility.

## Log

| Date | Area | Change or decision | Files touched | Reason | Follow-up |
| --- | --- | --- | --- | --- | --- |
| 2026-05-23 | Project state | Created initial project-state files for book brief, chapter map, reference notes, terminology, fact ledger, figure/table register, and revision log. | `book-brief.md`, `chapter-map.md`, `reference-book-notes.md`, `terminology.md`, `fact-ledger.md`, `figure-table-register.md`, `revision-log.md` | Establish a book-level control layer before editing manuscript chapters. | Use these files as checkpoints before major chapter rewrites. |
| 2026-05-23 | Book mode | Recorded current working mode as an applied scholarly monograph with teaching-oriented explanation where needed. | `book-brief.md`, `chapter-map.md` | `index.qmd` frames the project as a specialized applied monograph on volatility, VaR, ES, and VN-Index. | Revisit only if the project is repositioned as a course textbook. |
| 2026-05-23 | Chapter structure | Recorded active four-part, eight-chapter sequence from `_quarto.yml` and current chapter outlines. | `chapter-map.md` | Preserve coherence before migrating material from legacy chapters. | Update after any change to `_quarto.yml` chapter order. |
| 2026-05-23 | Fact control | Created fact-ledger structure and marked unstable or empirical claims as needing verification. | `fact-ledger.md` | Avoid fake currentness for market, data, Basel, regulatory, and crisis-history claims. | Fill source rows when chapters begin using specific claims. |
| 2026-05-23 | Terminology | Created initial English-Vietnamese terminology and notation register. | `terminology.md` | Keep VaR/ES, volatility, return, loss, and model terminology consistent across old and new material. | Normalize terminology during chapter rewrites. |
| 2026-05-23 | Figures/tables | Created initial figure/table register with planned active-chapter assets and legacy audit notes. | `figure-table-register.md` | Prevent duplicate labels, orphaned generated files, and unsupported empirical captions. | Run full label extraction before migrating code chunks. |

## Decision Rules Going Forward

- Update `book-brief.md` if the audience, book mode, software policy, jurisdiction, or empirical scope changes.
- Update `chapter-map.md` whenever chapter order, chapter role, or inter-chapter dependencies change.
- Update `terminology.md` when a new technical term, abbreviation, or symbol is introduced.
- Update `fact-ledger.md` before adding current market, regulatory, Basel, historical-crisis, or exact empirical claims.
- Update `figure-table-register.md` whenever a figure/table is added, removed, relabeled, migrated from legacy files, or regenerated from new data.
- Record major structural rewrites here before or immediately after the change.
