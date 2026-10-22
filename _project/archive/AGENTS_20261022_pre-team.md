# Repo Guide For Codex

## Project shape

- This is a Word-first Vietnamese VAR monograph workspace.
- Markdown files `01. Chuong_*/chapter.md` are the canonical agent-editable sources.
- DOCX files `01. Chuong_*/chapter.docx` are authoring/rendered copies.
- The authoritative book architecture is `00. Book/outline.docx`.
- Each chapter owns its code, data, references, and generated outputs.
- Project control material lives in `_project/`; historical material is outside this workspace in `99. Archive/`.

## Working rules

- Read the target chapter README and `_project/asset_register.csv` before changing content or paths.
- Treat the six-chapter mapping in `00. Book/outline.docx` as the content authority; do not infer chapter roles from legacy filenames.
- Preserve Vietnamese academic tone unless the user asks for a rewrite.
- Treat Markdown, R code, data, and output register as one unit; avoid changing one without checking the others.
- When editing references, keep citation keys stable unless the user asks otherwise.
- Do not overwrite the original DOCX or delete historical files; archive superseded versions with a manifest.

## Verification

- If R/package changes are involved, check whether `renv` is relevant.
- Before converting Markdown to DOCX, validate chapter flow, figure/table references, and bibliography references.
- Do not run models merely as part of a file-organization task.

## Typical requests

- Improve chapter writing while preserving meaning.
- Refactor R chunks for clarity or reuse.
- Add or revise sections in an existing chapter.
- Review current changes for build risks, reference issues, and analytical mistakes.
