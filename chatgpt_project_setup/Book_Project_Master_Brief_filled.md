# Book Project Master Brief

Last updated: 2026-06-15

## 1. Working Title

Volatility and Value-at-Risk for Vietnamese Financial Returns: Methods, Forecasting, Backtesting, and Evidence from VN-Index

Vietnamese working title:

Biến động và giá trị chịu rủi ro trên thị trường chứng khoán Việt Nam: mô hình, dự báo, kiểm định ngược và bằng chứng từ VN-Index

## 2. Book Type

Vietnamese academic monograph / specialist textbook hybrid.

The book should read as one coherent argument about market-risk measurement, not as separate lecture notes, a software manual, or a collection of independent papers.

## 3. Central Thesis

Reliable market-risk measurement requires a disciplined chain from return construction, volatility dynamics, distributional and tail assumptions, VaR/ES model architecture, forecast evaluation, and backtesting to risk-management interpretation. VN-Index provides a focused empirical setting where volatility clustering, heavy tails, model misspecification, and tail-risk evaluation can be studied in an applied Vietnamese market context.

## 4. Book Promise

After reading this book, the reader should be able to explain, estimate, forecast, compare, and critically evaluate volatility, VaR, and ES models for financial return data, using reproducible R workflows and empirical applications to Vietnamese stock market data.

## 5. Target Readers

- Advanced undergraduate and master's students in finance, banking, financial markets, risk management, and empirical finance.
- Early PhD students needing a structured applied bridge from volatility models to VaR/ES.
- Lecturers, research assistants, analysts, and practitioners who need disciplined market-risk measurement and model-comparison logic.

Assumed background: basic finance, probability/statistics, and introductory time series or econometrics. Do not assume prior fluency in GARCH, EVT, VaR backtesting, or R-based reproducible research.

## 6. Language And Style

- Main language: Vietnamese.
- Style: clear Vietnamese academic prose, precise but readable.
- First-use rule: introduce Vietnamese term, English term, and abbreviation together.
- Later use should follow `sources/notes/terminology.md`.
- Avoid slogan-like prose, generic summaries, and long author-by-author literature surveys.

## 7. Quantitative Level

Baseline: advanced undergraduate to master's level.

Add early-PhD nuance only when needed for model risk, diagnostics, tail behavior, forecast evaluation, or empirical design. Equations should serve interpretation and reproducibility, not ornamental derivation.

## 8. Empirical Focus

Primary empirical object: VN-Index daily return data.

Current local assets include:

- `data/raw/VNI.csv`
- `data/raw/vni_data.xlsx`
- `data/processed/` derived assets for chapters 5-7
- `outputs/ch01/` through `outputs/ch05/` figures/tables/docx outputs
- `code/rscripts/ch01/` verified R workflow for chapter 1

Data provenance, sample period, price field, return definition, missing-value treatment, and run date must be verified before final empirical prose.

## 9. Current Production Mode

Word-first manuscript workflow.

Authoritative current working candidates:

- `manuscript/current/Outline.docx`
- `manuscript/current/chuong_1_sach_chuyen_khao.docx`
- `manuscript/current/chuong_2_sach_chuyen_khao.docx`
- `manuscript/current/chuong_3_sach_chuyen_khao.docx`
- `manuscript/current/chuong_4_sach_chuyen_khao.docx`
- `manuscript/current/chuong_5_sach_chuyen_khao.docx`

Chapters 6-8 likely need Word-first drafting or conversion from Quarto archive material.

Quarto material in `ebook_quarto_archive/` is preserved for later ebook/online-book conversion and as source material, not automatically the current manuscript authority.

## 10. Active Chapter Architecture

| Chapter | Working role |
| --- | --- |
| Ch. 1. Rủi ro đuôi trong chuỗi tỷ suất sinh lời | Establish the shared language of prices, returns, losses, volatility, VaR, ES, and tail risk. |
| Ch. 2. Từ biến động có điều kiện đến thước đo rủi ro đuôi | Bridge volatility modeling and tail-risk measurement. |
| Ch. 3. Các kiến trúc mô hình VaR và Expected Shortfall | Map model families, assumptions, and use cases for VaR/ES. |
| Ch. 4. Thiết kế đánh giá mô hình rủi ro đuôi | Turn model construction into forecast evaluation and backtesting design. |
| Ch. 5. Dữ liệu VN-Index và cấu trúc thực nghiệm của rủi ro thị trường | Establish data provenance, return construction, empirical design, and stylized facts. |
| Ch. 6. Đo lường và dự báo biến động trên VN-Index | Evaluate volatility measures and forecasts as inputs to VaR/ES. |
| Ch. 7. So sánh thực nghiệm các mô hình VaR và Expected Shortfall trên VN-Index | Conduct the main empirical VaR/ES model comparison and backtesting. |
| Ch. 8. Hàm ý phương pháp và hàm ý quản trị rủi ro cho thị trường Việt Nam | Synthesize methodological and practical implications. |

## 11. Key Reference Families

Local reference books in `sources/books/` include:

- Ruey S. Tsay, Analysis of Financial Time Series
- Ruey S. Tsay, An Introduction to Analysis of Financial Data with R
- Chris Brooks, Introductory Econometrics for Finance
- McNeil, Frey, and Embrechts, Quantitative Risk Management
- Philippe Jorion, Value at Risk
- FRM Market Risk materials
- Additional econometrics and financial-market references

Use these as structural and methodological references. Do not copy prose, examples, diagrams, exercises, or distinctive organization.

## 12. Reproducibility Assets

- Main tools: Word manuscript, R scripts, project data, outputs, bibliography, and archived Quarto sources.
- Chapter 1 has the most complete current R workflow.
- Chapters 2-5 have Word drafts and historical figures.
- Chapters 6-8 need production planning and possibly conversion/migration from archived Quarto sources.

## 13. Verification Priorities

Before final manuscript use, verify:

- VN-Index data source, extraction date, sample start/end, frequency, and price field.
- Return construction and scaling convention.
- Exact descriptive statistics, diagnostics, and test results.
- VaR/ES values, violation rates, backtesting p-values, and model rankings.
- Any claim about Basel, ES replacing VaR, traffic-light backtesting, or regulatory capital.
- Any explanation of market episodes or volatility spikes.

## 14. Project Risks

- Multiple manuscript systems coexist: Word, archived Quarto, exported PDFs, generated outputs.
- Chapters 1-5 are current Word candidates; chapters 6-8 need a final Word workflow decision.
- Some figures and outputs are duplicated across archive/cache/output folders.
- Empirical claims may rely on old runs unless regenerated and ledgered.
- Chapter 7 can easily become a table dump unless model comparison is synthesized.
- Chapter 8 needs original synthesis and should not simply repeat conclusions.

## 15. Immediate Next Tasks

1. Confirm authoritative Word drafts for chapters 1-5.
2. Decide whether chapters 6-8 should be converted from Quarto archive to Word drafts.
3. Build a chapter-by-chapter production plan for Word manuscript plus R outputs.
4. Verify VN-Index data provenance and sample period.
5. Create or migrate R workflows for chapters 2-8, starting with the chapters most dependent on empirical outputs.
6. Build a live literature and source-verification bank for VaR/ES, backtesting, EVT/POT, GARCH, and Vietnam market context.

