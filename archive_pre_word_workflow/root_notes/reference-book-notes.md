# Reference Book Notes

Last updated: 2026-05-23

Purpose: record design lessons from reference books without copying prose, examples, diagrams, exercises, or distinctive organization. These notes should guide structure, level, scaffolding, boxes, empirical examples, and exercises.

## Local Reference Inventory

| Reference file | Likely role for this project | Status |
| --- | --- | --- |
| `2. Book Reference/Analysis of Financial Time Series, 3rd Edition .pdf` | Financial time-series depth, volatility modeling, model diagnostics, empirical style. | Benchmarked for volatility-model structure and forecast/evaluation sequencing. |
| `2. Book Reference/An Introduction to Analysis of Financial Data with R by Ruey S. Tsay (z-lib.org).pdf` | R-oriented explanation and applied financial-data workflow. | Benchmarked for chapter sequencing, R integration, volatility, VaR/ES, and EVT framing. |
| `2. Book Reference/Introductory Econometrics for Finance -- Chris Brooks.pdf` | Econometrics pedagogy, finance examples, graduate/advanced undergraduate pacing. | Benchmarked for textbook scaffolding, diagnostics, volatility chapter design, and worked empirical flow. |
| `2. Book Reference/Introductory Econometrics_ A Modern Approach.pdf` | General econometric scaffolding and applied interpretation. | Listed locally; detailed notes not yet extracted. |
| `2. Book Reference/Quantitative Risk Management_ Concepts, Techniques and Tools.pdf` | Risk-measure theory, VaR/ES, tail modeling, coherent risk perspective. | Benchmarked for risk-measure taxonomy, VaR/ES framing, EVT, and backtesting design. |
| `2. Book Reference/Value at Risk, 3rd Ed.pdf` | VaR practice, model governance, backtesting, risk-management framing. | Benchmarked for practitioner framing, backtesting placement, and system-level narrative. |
| `2. Book Reference/Securities Institute - an introduction to value-at-risk.pdf` | Practitioner introduction to VaR and communication style. | Skimmed as secondary practitioner support; not a primary design driver in this pass. |
| `2. Book Reference/FRM Exam Prep Market Risk Measurement and Management.pdf` | Professional risk taxonomy, market-risk measurement topics, exam-style clarity. | Skimmed as secondary checklist-style support; not a primary design driver in this pass. |
| `2. Book Reference/The Econometrics of Financial Markets.pdf` | Higher-level theoretical background for empirical finance. | Listed locally; detailed notes not yet extracted. |

## Benchmarking Rules For This Book

- Extract reusable design patterns, not text.
- Record chapter sequence logic, explanation depth, use of figures/tables/boxes, empirical workflow, and end-of-chapter devices.
- Do not copy prose, case narratives, diagrams, proprietary exercises, or a full table of contents.
- When a reference is mathematically dense, translate only the needed logic into the book's applied monograph voice.
- When a reference is practitioner-oriented, use it for communication discipline but verify regulatory or market claims separately.

## Benchmark Findings

This benchmark focuses on design lessons only. It does not authorize copying prose, examples, exercises, diagrams, or a distinctive table of contents.

| Source | Reader level and mode | Structure pattern | Design lesson for this repo | Limitation for this repo |
| --- | --- | --- | --- | --- |
| Tsay, `Analysis of Financial Time Series` | Graduate / advanced applied time-series text | Moves from return properties and linear models into conditional heteroskedasticity, forecast evaluation, applications, and multivariate volatility. | For volatility chapters, build from stylized facts and model motivation into ARCH test, model family, extensions, forecasting, and then applications. Keep model variants tied to what each one adds. | More technical and broader than the current Vietnam-focused monograph; cannot be transplanted chapter-for-chapter. |
| Tsay, `An Introduction to Analysis of Financial Data with R` | Advanced undergraduate to master; application-first with software support | Introduces data/R tools early, then develops volatility models, then a separate applications chapter, then a risk-management chapter with VaR, ES, RiskMetrics, quantile methods, and EVT. | Strong template for separating core volatility logic from later risk-measure applications. Also supports the current split between Ch. 2, Ch. 3, Ch. 6, and Ch. 7. | Still wider than the current book and not designed around one continuous VN-Index empirical thread. |
| Brooks, `Introductory Econometrics for Finance` | Textbook with strong pedagogy and diagnostics | Econometrics foundations first, then univariate/multivariate time series, then a dedicated chapter on volatility and correlation with diagnostics, uses, forecasting, and multivariate extensions. | Helpful model for teaching progression: concept -> estimation -> diagnostic testing -> use case -> forecast comparison. Use this logic especially in Ch. 2 and Ch. 6. | Broader econometrics scope than needed here; much of the early textbook scaffolding would be too long for a specialized monograph. |
| Jorion, `Value at Risk` | Practitioner / MBA-level risk management | Frames VaR as a risk-management system: motivation, disasters, regulation, measurement tools, computing VaR, backtesting, portfolio methods, forecasting, systems, stress testing, and applications. | Best design cue for Ch. 3 and Ch. 4 is that VaR methods should be tied to governance and decision use, not only formulas. Backtesting belongs after readers understand how VaR is computed and before full empirical model comparison. | VaR-centric and institution-facing; needs adaptation because the current book also gives ES, EVT, and volatility-model comparisons stronger analytical weight. |
| McNeil, Frey, Embrechts, `Quantitative Risk Management` | Graduate / technical monograph | Starts from loss distributions, risk measures, stylized facts, then time series, GARCH, EVT, multivariate models, portfolio risk, and only later a dedicated applications section with backtesting. | Strong lesson for Ch. 3 and Ch. 4: define VaR/ES conceptually within a loss-distribution framework, and treat ES as a first-class measure rather than an appendix to VaR. Backtesting should cover more than exceedance counts and should be linked to predictive distributions and model comparison. | More mathematically dense than the target readership baseline; needs translation into clearer Vietnamese academic exposition. |
| FRM Schweser Notes, `Market Risk Measurement and Management` | Exam-prep / checklist style | Modular reading -> concept -> key points -> quiz logic. | Useful as a compression test: if a section cannot be summarized into a clean model-choice checklist, it is probably too diffuse. | Too condensed and exam-driven to serve as chapter architecture. |
| `An Introduction to Value-at-Risk` (Securities Institute) | Practitioner introduction | Starts from risk concepts, then volatility/correlation, then VaR-related intuition. | Useful reminder to open with intuitive risk language before technical detail in Ch. 1-Ch. 3 transitions. | Too introductory for the depth expected in Ch. 4, Ch. 6, and Ch. 7. |

## Focused Lessons By Theme

| Focus area | Benchmark lesson | Main references |
| --- | --- | --- |
| How Tsay and Brooks structure volatility modeling | Both move from data properties to conditional heteroskedasticity, then to model estimation, diagnostics, extensions, uses, and forecasting. Tsay separates volatility applications into a later chapter; Brooks keeps volatility and correlation together in one dedicated chapter. | Tsay `Analysis of Financial Time Series`; Tsay `Introduction ... with R`; Brooks |
| How Jorion and QRM frame VaR/ES | Jorion frames VaR as an institution-facing risk-management system with regulation, implementation, and control. QRM frames VaR/ES from loss distributions and risk-measure theory, with ES and tail modeling treated structurally rather than as add-ons. | Jorion; QRM |
| How backtesting is explained | Jorion places backtesting immediately after computing VaR to show model accountability. QRM broadens backtesting beyond simple violation counts toward predictive-distribution and method-comparison logic. | Jorion; QRM |
| How R-based examples should be integrated | Tsay introduces R packages and demonstrations early, but uses them to support empirical understanding rather than replace explanation. Software appears as compact demonstrations, case studies, and applications, not as long standalone scripts. Brooks reinforces the value of screenshots/boxes/checklists around procedure and diagnostics. | Tsay `Introduction ... with R`; Brooks |
| How empirical results should appear | Compact, question-driven tables and selected figures work better than large undifferentiated output dumps. Forecasting sections should compare candidate models under a common design and explain why the winning model wins. | Tsay; Brooks; Jorion; QRM |

## Design Implications For Current Chapters

| Chapter | Benchmark-led design rule | Main references |
| --- | --- | --- |
| Ch. 2 `Từ biến động có điều kiện đến thước đo rủi ro đuôi` | Structure the chapter as: volatility characteristics -> model-building logic -> ARCH test -> ARCH/GARCH family -> key extensions -> what volatility forecasts can and cannot do for tail risk. Keep each variant tied to a modeling problem, not listed as a catalog. | Tsay; Brooks; QRM |
| Ch. 3 `Các kiến trúc mô hình VaR và Expected Shortfall` | Organize model families by assumption and decision use: historical, parametric, volatility-based, quantile-based, EVT/tail. Introduce VaR and ES within a loss-distribution logic and keep ES visible throughout the taxonomy. | Jorion; QRM; Tsay `Introduction ... with R` |
| Ch. 4 `Thiết kế đánh giá mô hình rủi ro đuôi` | Place backtesting as a bridge from model construction to model accountability. Explain backtesting as a forecast-evaluation and governance problem, not just a list of tests. Include exceedance logic, dependence/clustering logic, and the practical meaning of model acceptance. | Jorion; QRM; Brooks |
| Ch. 6 `Đo lường và dự báo biến động trên VN-Index` | Follow the pattern concept -> estimation -> diagnostics -> forecast comparison -> implication for downstream VaR/ES use. Forecast comparison should be common-design and explicitly state why some volatility models are carried into Ch. 7 and others are not. | Tsay; Brooks; QRM |
| Ch. 7 `So sánh thực nghiệm các mô hình VaR và Expected Shortfall trên VN-Index` | Present the empirical comparison as a controlled contest among model families under one design, followed by backtesting, tail severity, and conditional conclusions. Do not treat one table as the verdict; combine forecast path intuition, violation behavior, and interpretation of model strengths/weaknesses. | Jorion; QRM; Tsay `Introduction ... with R` |

## Targeted Benchmark: Ch. 3–4 VaR/ES Architecture And Evaluation

This targeted benchmark uses the book-level findings already recorded above and applies them only to `chapters/ch03.qmd` and `chapters/ch04.qmd`.

### Ch. 3 Model Architecture

| Focus | Targeted benchmark lesson | Implication for current Ch. 3 |
| --- | --- | --- |
| Overall role | Jorion and QRM both imply that the model-architecture chapter should tell readers what kind of risk-measure logic each model family represents before any full empirical comparison begins. | Ch. 3 should stay a taxonomy and assumption chapter, not drift into backtesting results or VN-Index empirical ranking. |
| Organizing principle | The cleanest structure is by modelling logic and data use, not by historical chronology or by software implementation. | Keep the current five-family flow and make the opening `assumption matrix` the unifying frame for the whole chapter. |
| VaR and ES treatment | QRM supports defining VaR and ES within a loss-distribution framework; Tsay supports keeping ES visible alongside VaR when discussing risk-measure families. | Ch. 3 should not present ES as a late extension. Each family should indicate whether it yields VaR only, ES only, or both, and under what assumptions. |
| Family 1 | Historical simulation belongs as the benchmark nonparametric family. | Keep `historical simulation` in Ch. 3 as the baseline for data-driven quantile estimation. |
| Family 2 | Parametric VaR belongs as the distribution-assumption family. | Keep `parametric VaR` separate and make the distributional assumption explicit: normal, Student-t, skewed/heavy-tail variants where relevant. |
| Family 3 | Volatility-based VaR belongs as the family that maps conditional volatility into tail-risk forecasts. | Keep `volatility-based VaR` distinct from general parametric VaR so readers see the bridge from Ch. 2 into Ch. 3. |
| Family 4 | Quantile-based or semi-parametric methods belong as direct conditional-quantile approaches. | Keep `quantile-based` methods distinct from distribution-model families; this is where quantile regression/CAViaR-type logic should sit. |
| Family 5 | EVT/POT belongs as the explicit tail-model family. | Keep `EVT/POT` as the family for extreme-tail modelling rather than mixing it into general parametric or historical methods. |
| Extensions | Tsay and QRM suggest that Monte Carlo and higher-moment or hybrid extensions should be treated as extensions to core families, not as completely separate pedagogical universes. | `GARCH with simulation` and higher-moment extensions can remain in Ch. 3, but as late-chapter extensions after the five main families are established. |

### Ch. 4 Evaluation And Backtesting

| Focus | Targeted benchmark lesson | Implication for current Ch. 4 |
| --- | --- | --- |
| Overall role | Jorion places backtesting after model construction; QRM broadens evaluation from simple violation counts to predictive and comparative logic. | Ch. 4 should begin from forecast design and model accountability, not reopen model taxonomy. |
| Organizing principle | Evaluation should move from forecast setup -> VaR backtesting -> ES/tail severity -> model acceptance. | The current four-part structure is sound and should be sharpened into an end-to-end evaluation workflow. |
| In-sample vs out-of-sample | Brooks and Jorion both imply that evaluation is only meaningful once the forecast design is explicit. | Ch. 4 should state horizon, rolling window, confidence level, forecast origin, and comparison fairness before introducing any test. |
| VaR backtesting | Jorion supports coverage and independence logic; QRM supports a richer backtesting perspective. | Ch. 4 should present Kupiec, Christoffersen, and DQ-type logic as answering different questions, not as interchangeable tests. |
| ES and tail severity | QRM supports treating ES evaluation as more than an appendix to VaR. | Ch. 4 should explain why exceedance frequency alone is insufficient and why tail severity matters once VaR is breached. |
| Model acceptance | Jorion strongly supports governance interpretation. | Ch. 4 should end with practical model-acceptance logic: acceptable, conservative, misspecified, or conditionally acceptable depending on test outcomes and use case. |

### Boundary Between Ch. 3 And Ch. 4

| Keep in Ch. 3 | Keep in Ch. 4 | Do not repeat |
| --- | --- | --- |
| Model families and their assumptions | Forecast design and evaluation logic | Full re-definition of each model family once Ch. 4 begins |
| Difference between distribution models, quantile models, and tail models | Difference between coverage, independence, DQ, and tail-severity criteria | Model-by-model formula catalogues |
| Conditions under which a model is likely to work or fail conceptually | Conditions under which a model passes or fails empirically | Repeating the same intuition about heavy tails, volatility clustering, or loss distribution unless needed for a specific test |
| Why ES should be visible in model architecture | Why ES/tail severity should matter in model evaluation | A second taxonomy of VaR/ES methods inside Ch. 4 |

### Tables And Figures To Add

| Item | Chapter | Current register status | Targeted benchmark use |
| --- | --- | --- | --- |
| `fig-ch03-model-taxonomy` | Ch. 3 | Planned in `figure-table-register.md` | Should visualize the full Ch. 3 family map: historical, parametric, volatility-based, quantile-based, EVT/POT, with ES visibility and assumption differences. |
| `tbl-ch04-backtesting-tests` | Ch. 4 | Planned in `figure-table-register.md` | Should map each test or criterion to the question it answers, the failure pattern it detects, and the practical implication for model use. |
| `fig-ch04-backtesting-workflow` | Ch. 4 | Planned in `figure-table-register.md` | Should show the sequence from forecast generation to exceedance identification, test execution, ES/tail-severity reading, and model-acceptance decision. |

Note: Ch. 3's own outline also calls for a compact synthesis table in addition to the taxonomy figure. If that table is added later, it should be registered in `figure-table-register.md`.

### Claims Requiring Verification For Ch. 3–4

| Claim area | Why it needs verification | Fact-ledger link |
| --- | --- | --- |
| Basel or regulatory uses of VaR and ES | Regulatory treatment is time-sensitive and jurisdiction-specific. | `Basel market-risk rules use VaR/ES in specific ways.` |
| Any statement that ES has replaced VaR in a named regulatory framework | Effective dates and scope can change and should not be stated loosely. | `Claims requiring verification before manuscript use` section in `fact-ledger.md`. |
| Any exact description of traffic-light backtesting, thresholds, or acceptance bands | These are unstable if framed as current regulation rather than historical or methodological description. | `Claims requiring verification before manuscript use` section in `fact-ledger.md`. |
| Statements that Kupiec, Christoffersen, DQ, or related procedures are standard or preferred tests | Stable in broad terms, but named-method claims should be supported by correct methodological sources. | `Backtesting tests such as Kupiec, Christoffersen, and DQ are standard tools for VaR evaluation.` |
| Statements about EVT/POT threshold selection, sensitivity analysis, or superiority in tails | These are methodological claims that need proper sourcing and cautious framing. | `EVT/POT is appropriate only with careful threshold selection and sensitivity checks.` |
| Any exact empirical values, violation rates, p-values, or reported forecast performance used to motivate evaluation rules | Those results depend on the VN-Index data run and should not be generalized before rerun and checking. | `Any exact numerical result from data...` and `Latest values or last-sample VaR/ES results...` |

## Targeted Benchmark: Ch. 5–7 VN-Index Empirical Pipeline

This targeted benchmark uses the benchmark findings already recorded above and applies them only to the empirical pipeline now split across Ch. 5, Ch. 6, and Ch. 7. The goal is to keep one VN-Index design running through the three chapters without repeating the same descriptive material or turning the final chapter into a results dump.

### Ch. 5 Data Design And Stylized Facts

| Focus | Targeted benchmark lesson | Implication for current Ch. 5 |
| --- | --- | --- |
| Overall role | Tsay and Brooks imply that the empirical application should begin by making the data-generating setting legible before model comparison starts. | Ch. 5 should function as the common empirical base for Ch. 6 and Ch. 7: data provenance, return construction, sample scope, forecast windows, and stylized facts. |
| Chapter sequence | The clean sequence is data source -> variable construction -> empirical design -> stylized facts -> why these facts matter for later models. | Ch. 5 should not become an early volatility-estimation chapter or an early VaR-results chapter. Its job is to establish the sample and motivate later model families. |
| Stylized-facts use | Benchmark books use descriptive evidence to motivate modeling choices, not to stand alone as a separate statistical report. | Ch. 5 should tie each fact directly to a later modeling consequence: fat tails -> non-Gaussian risk models; volatility clustering -> conditional variance models; asymmetry/regime sensitivity -> asymmetric or tail-aware specifications. |
| Literature placement | The empirical chapter works best when prior literature is brief and functional. | Any literature map carried from legacy material should be compressed so it supports the VN-Index design rather than interrupting the empirical setup. |
| Output discipline | R-based empirical chapters work best when a few decisive tables/figures anchor interpretation. | Ch. 5 should center on one design table, a small number of sample visuals, and one compact stylized-facts block rather than many near-duplicate diagnostics. |

### Ch. 6 Volatility Forecast Comparison

| Focus | Targeted benchmark lesson | Implication for current Ch. 6 |
| --- | --- | --- |
| Overall role | Tsay and Brooks structure volatility chapters as model candidates -> estimation/diagnostics -> forecast comparison -> interpretation. | Ch. 6 should be the volatility-comparison chapter, not a second data chapter. It should begin from the Ch. 5 design and move directly into candidate volatility models. |
| Model families | For the empirical volatility chapter, the relevant families are historical or rolling volatility, EWMA/RiskMetrics, GARCH-type models, and range-based or OHLC-based measures where they add forecast value. | Ch. 6 should compare volatility estimators and forecasting devices, then identify which conditional-volatility inputs are worth carrying into VaR/ES work in Ch. 7. |
| Comparison logic | Benchmark books compare models under one common forecast exercise and explain why the winner wins. | Ch. 6 should keep one forecast design across horizons and loss functions, then synthesize model ranking instead of presenting each metric as a separate mini-conclusion. |
| Bridge to tail-risk chapters | QRM implies that volatility is useful when it improves downstream risk measurement, not as an end in itself. | The end of Ch. 6 should explicitly state which volatility models become inputs to volatility-based VaR/ES models in Ch. 7 and why others are dropped. |
| R integration | Software demonstrations should support model interpretation and reproducibility, not crowd out the narrative. | Ch. 6 should use compact code-backed results and explain the economic meaning of persistence, diagnostics, and forecast loss rather than displaying extensive scripts or raw console-like output. |

### Ch. 7 VaR/ES Empirical Comparison And Backtesting

| Focus | Targeted benchmark lesson | Implication for current Ch. 7 |
| --- | --- | --- |
| Overall role | Jorion and QRM both imply that the empirical VaR/ES chapter should look like a controlled contest among risk architectures under a fixed design. | Ch. 7 should be the main empirical comparison chapter for VaR/ES on VN-Index, using the data design from Ch. 5 and the volatility shortlist from Ch. 6. |
| Model families | The core family set remains historical, parametric, volatility-based, quantile-based, and EVT/POT. | Ch. 7 should compare one representative implementation from each family or a tightly justified subset, rather than exhausting every variant in the main flow. |
| Evaluation sequence | Jorion places model accountability after model construction; QRM adds severity and comparative interpretation. | Ch. 7 should move from model set and forecast paths -> backtesting summary -> tail severity/ES comparison -> synthesis of practical suitability. |
| Role of ES | QRM treats ES as a first-class risk measure rather than a postscript. | Ch. 7 should not report ES only as a side note after VaR. ES or tail-severity evidence should appear in the comparison logic once exceedances are discussed. |
| Final synthesis | Benchmark books do not let a single dense table carry all interpretation. | Ch. 7 should end with a compact synthesis table or narrative matrix explaining which model family is conservative, balanced, fragile, or context-dependent for VN-Index risk measurement. |

### Migration Of Legacy Figures And Tables

| Legacy source asset | Suggested active destination | Register alignment | Migration lesson |
| --- | --- | --- | --- |
| `legacy-ch05.qmd` `tbl-ch05-research-design` | Ch. 5 `tbl-ch05-data-design` | Already planned in `figure-table-register.md` | Use as the main Ch. 5 design table, but consolidate any overlapping sample/design fields now duplicated in legacy Ch. 3. |
| `legacy-ch05.qmd` `fig-ch05-vnindex-price` | Ch. 5 `fig-ch05-vnindex-price` | Already planned | Keep as the market-level context figure if the caption is tightened around sample period and interpretation. |
| `legacy-ch05.qmd` `fig-ch05-vnindex-returns` | Ch. 5 `fig-ch05-vnindex-returns` | Already planned | Keep as the key visual for volatility clustering and tail events. |
| `legacy-ch03.qmd` `tbl-vnindex-data-info` and `tbl-forecast-design` | Ch. 5 support for `tbl-ch05-data-design` | Supports planned Ch. 5 table | Merge useful columns into one shared data-design table instead of carrying separate design tables into Ch. 6 or Ch. 7. |
| `legacy-ch03.qmd` `tbl-volatility-measure-comparison` | Ch. 6 support for `tbl-ch06-volatility-candidates` | Supports planned Ch. 6 table | Use as the synthesis table that shows which volatility measures are conceptually and empirically worth carrying forward. |
| `legacy-ch03.qmd` `fig-forecast-vs-proxy` | Ch. 6 `fig-ch06-volatility-forecast-comparison` | Already planned | This is the clearest bridge from estimation to forecast evaluation and should remain central. |
| `legacy-ch03.qmd` `tbl-volatility-forecast-rmse`, `tbl-volatility-forecast-mae`, `tbl-volatility-forecast-qlike`, `tbl-best-model-by-horizon` | Ch. 6 supporting comparison block | Partly beyond current register; may require one added compact summary table later | Do not migrate all four tables unchanged into the main chapter. Collapse them into a compact ranking summary plus one supporting table if needed. |
| `legacy-ch03.qmd` `tbl-garch-ic-comparison`, `tbl-garch-persistence`, `tbl-garch-diagnostics-vnindex` | Ch. 6 supporting estimation/diagnostics block | Not yet registered separately | Use selectively to justify the shortlist; avoid carrying all estimation output if it does not change the forecast conclusion. |
| `legacy-ch05.qmd` `tbl-ch05-model-summary` | Ch. 7 `tbl-ch07-model-summary` | Already planned | Good candidate for the opening synthesis table of the Ch. 7 model contest. |
| `legacy-ch05.qmd` `tbl-ch05-backtesting-summary` | Ch. 7 `tbl-ch07-backtesting-summary` | Already planned | This should be the central accountability table, after tightening columns to the tests that matter most. |
| `legacy-ch05.qmd` `fig-ch05-parametric-var-comparison`, `fig-ch05-semi-parametric-var`, `fig-ch05-var-best-candidates` | Ch. 7 `fig-ch07-var-comparison` | Already planned | Rebuild as one selective comparison figure for key models only, rather than several family-specific plots in the main text. |
| `legacy-ch05.qmd` `fig-ch05-violation-rate` | Ch. 7 supporting backtesting figure | Supports planned Ch. 7 evaluation logic | Use if it adds intuition beyond the summary table; otherwise keep it secondary. |
| `legacy-ch05.qmd` `tbl-ch05-tail-severity` and `fig-ch05-tail-severity` | Ch. 7 ES/tail-severity block | Not yet registered separately | Strong candidates for a future Ch. 7 ES-support item because they prevent VaR exceedance counts from being the only verdict. |
| `legacy-ch05.qmd` `tbl-ch05-hs-latest` and `tbl-ch05-parametric-latest` | Avoid direct migration into main Ch. 7 flow | Not in active register | These last-day snapshot tables are weak main-text anchors and should not crowd the core comparison unless later moved to an appendix. |

### Avoiding Repetition Between Ch. 5 And Ch. 6

| Repeat-risk | Keep in Ch. 5 | Keep in Ch. 6 | Do not repeat |
| --- | --- | --- | --- |
| Sample description | Data source, sample period, return definition, cleaning choices, rolling-window plan | One brief reminder only if needed for forecast interpretation | Full restatement of sample construction |
| Descriptive statistics | One compact block of moments and stylized facts used to motivate model choice | Only re-cite the specific fact needed to interpret forecast behavior | A second descriptive-statistics table with the same moments |
| ARCH and clustering motivation | Introduce clustering and tail behavior as empirical reasons for modeling | Use those facts only to explain why candidate models differ in performance | Re-teaching the same intuition about clustering or heavy tails |
| Forecast design | Establish horizons, evaluation window, and fairness rules once | Execute the common forecast exercise | Rebuild the design table from scratch |
| Data visuals | Price/return figures that orient the reader | Forecast-versus-proxy or model-comparison visuals | Reusing the same return-series visual as if it were new evidence |

### Avoiding A Table Dump In Ch. 7

| Risk of overload | Targeted benchmark lesson | Operational rule for current Ch. 7 |
| --- | --- | --- |
| One table per model family | Benchmark books compare families under one design instead of printing separate result blocks that force readers to self-synthesize. | Use one cross-family summary table and one backtesting table as the backbone, then only a small number of supporting visuals. |
| Repeating similar VaR plots | A few selective path figures do more work than many overlapping charts. | Show only key candidate models or one representative from each family in the main figure. |
| Too many accuracy metrics without narrative | Comparative chapters should explain what each metric changes in the verdict. | Restrict main-text metrics to those that alter model choice; move purely confirmatory detail out of the core narrative. |
| Treating exceedance count as the whole story | QRM implies that severity and conditional behavior matter once breaches occur. | Pair backtesting with ES or tail-severity evidence so Ch. 7 does not reduce evaluation to hit counts. |
| No concluding synthesis | Without a decision matrix, the chapter reads like a catalogue of outputs. | End Ch. 7 with a compact suitability synthesis: which models are robust, conservative, unstable, or only conditionally acceptable. |

### Empirical Claims To Record In Fact Ledger Before Final Prose

| Claim family | Why record before prose | Main chapter use |
| --- | --- | --- |
| Exact VN-Index data provenance, download/extraction date, sample start/end, and price field used | These are the base conditions for every empirical statement in Ch. 5-Ch. 7. | Ch. 5-Ch. 7 |
| Exact return definition, scaling convention, missing-value treatment, and rolling-window design | These choices affect comparability across volatility and VaR/ES exercises. | Ch. 5-Ch. 7 |
| Exact descriptive moments and test statistics for stylized facts, including normality, stationarity, serial dependence, and ARCH-type evidence | These are empirical claims, not generic textbook facts. | Ch. 5 |
| Any claim linking high-volatility intervals to named market episodes or crisis periods | Episode labels require date-specific sourcing and should not be inferred loosely from charts alone. | Ch. 5, Ch. 8 |
| Exact volatility forecast rankings by horizon and loss function, including any statement that one model dominates another | These are contingent empirical results and may change after rerun or redesign. | Ch. 6 |
| Exact persistence, half-life, or diagnostics claims used to justify carrying a volatility model into Ch. 7 | These are model-specific results that must be tied to the actual estimation run. | Ch. 6 |
| Exact VaR and ES values, model-by-model comparisons, and any last-sample or representative-day numbers | These are numerical outputs that require a verified run context. | Ch. 7 |
| Exact violation counts, violation rates, Kupiec/Christoffersen/DQ results, p-values, and pass/fail labels | These are central empirical claims and should be ledgered before they are narrated as findings. | Ch. 7 |
| Exact tail-severity or average-loss-beyond-VaR claims | These are needed if ES or severity is used to break ties among VaR models. | Ch. 7 |

## Working Rules For Future Benchmarking

- Keep using benchmark books to extract chapter logic, exposition depth, figure/table discipline, and software-placement patterns.
- Do not imitate a full table of contents, named case sequence, or proprietary pedagogical packaging too closely.
- For this repo, Tsay and Brooks are the main structural references for volatility chapters; Jorion and QRM are the main structural references for VaR/ES and backtesting chapters.
- Other books in `2. Book Reference/` can be mined later for narrower needs such as empirical-finance theory, practitioner framing, or glossary calibration.
