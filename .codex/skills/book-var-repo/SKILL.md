---
name: book-var-repo
description: Use this skill for the Book_VaR repository when writing or revising the Word-first Markdown chapter sources of the Vietnamese monograph on volatility and VaR/ES, including technical validation and pedagogical review.
---

# Book_VaR Book-Writing Skill

## When to use
Use this skill when the request involves:
- writing, revising, or reviewing chapters in this Word-first book,
- improving explanations of volatility modeling, risk forecasting, and Value at Risk (VaR),
- giving suggestions for student-friendly structure at undergraduate or master's level,
- validating related R/code and Markdown/DOCX changes in this repository.

## Domain focus and baseline knowledge
Assume the repository is a teaching-focused book on:
- financial return series,
- volatility dynamics (stylized facts, heteroskedasticity, clustering),
- VaR forecasting and backtesting.

When revising content, preserve mathematical correctness while improving readability and didactic flow. Treat `00. Book/outline.docx` as the authoritative content architecture.

## Authoritative six-chapter mapping

1. Foundations: returns, volatility, tail risk, VaR and ES.
2. Volatility measurement and forecasting methods.
3. Vietnam empirical volatility measurement and forecasting.
4. VaR and Expected Shortfall methods.
5. Vietnam empirical VaR/ES measurement.
6. Conclusions, implications and new directions.

## Pedagogical review standard
For each chapter request, review and suggest improvements across these dimensions:
1. **Learning objectives**: ensure chapter goals are explicit at the start.
2. **Conceptual flow**: move from intuition -> formal definition -> implementation -> interpretation.
3. **Mathematical clarity**: define notation before use and explain assumptions.
4. **Code-to-theory linkage**: each key equation should map to reproducible code/output.
5. **Student level fit**:
   - undergraduate: simpler language, more intuition and guided examples,
   - master's: deeper assumptions, limitations, diagnostics, and critical discussion.
6. **Assessment readiness**: include short exercises/checkpoints when useful.

## Chapter revision workflow
1. Identify target files in the relevant `0x. Chuong_0x/` folder and related data/code files.
2. Propose an edit plan: content fixes, structure changes, and optional enhancements.
3. Apply minimal source edits in `chapter.md`/`.R` files.
4. Provide a concise review report with:
   - strengths,
   - issues,
   - concrete rewrite suggestions,
   - priority order (high/medium/low).
5. Run targeted validation commands before finalizing.

## Repository conventions
- Prefer changing `chapter.md` first; regenerate/update `chapter.docx` only when needed.
- Keep chapter-specific datasets in `data/raw/` and `data/derived/`.
- Do not rename Vietnamese-language files unless explicitly requested.

## Common validation commands
- `Rscript -e "source('SourceOil.R')"`
- `quarto check`
- `quarto render`

## Output style for review requests
When asked to review/revise a chapter, structure the answer as:
1. Chapter summary (2-4 bullets)
2. Technical accuracy review
3. Pedagogical review (undergrad/master fit)
4. Suggested edits (actionable bullets)
5. Optional rewritten excerpt(s)

## Safety notes
- Keep changes scoped to the user's requested chapter(s).
- Avoid destructive commands.
