---
name: book-var-repo
description: Use this skill for the Book_VaR repository when writing or revising Quarto book chapters on volatility and VaR forecasting with financial returns, including technical validation and pedagogical review for undergraduate and master's students.
---

# Book_VaR Book-Writing Skill

## When to use
Use this skill when the request involves:
- writing, revising, or reviewing chapters in this Quarto book,
- improving explanations of volatility modeling, risk forecasting, and Value at Risk (VaR),
- giving suggestions for student-friendly structure at undergraduate or master's level,
- validating related R/Quarto changes in this repository.

## Domain focus and baseline knowledge
Assume the repository is a teaching-focused book on:
- financial return series,
- volatility dynamics (stylized facts, heteroskedasticity, clustering),
- VaR forecasting and backtesting.

When revising content, preserve mathematical correctness while improving readability and didactic flow.

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
1. Identify target files in `chapters/` and related data/code files.
2. Propose an edit plan: content fixes, structure changes, and optional enhancements.
3. Apply minimal source edits in `.qmd`/`.R` files.
4. Provide a concise review report with:
   - strengths,
   - issues,
   - concrete rewrite suggestions,
   - priority order (high/medium/low).
5. Run targeted validation commands before finalizing.

## Repository conventions
- Prefer changing source files first; regenerate artifacts only when needed.
- Treat `_freeze/` as generated output.
- Keep canonical datasets in `data/`.
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
