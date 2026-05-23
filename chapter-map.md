# Chapter Map

Last updated: 2026-05-23

This map follows the active book order in `_quarto.yml`. Legacy chapter files are treated as source material for later drafting, not as the official chapter sequence.

## Part Structure

| Part | Active file | Role in book |
| --- | --- | --- |
| Front matter | `index.qmd` | States the monograph promise, audience, method, and reading path. |
| Part I | `chapters/part01.qmd` | Establishes the research problem and conceptual foundation. |
| Part II | `chapters/part02.qmd` | Develops model architecture and evaluation standards for tail-risk measurement. |
| Part III | `chapters/part03.qmd` | Builds empirical evidence from VN-Index. |
| Part IV | `chapters/part04.qmd` | Synthesizes methodological and risk-management implications. |

## Chapter Dependency Map

| Chapter | Role | Depends on | Introduces | Used later by | Main reader output |
| --- | --- | --- | --- | --- | --- |
| Ch. 1. Rủi ro đuôi trong chuỗi tỷ suất sinh lời | Establishes the shared language of returns, distributions, volatility, VaR, and ES. | Reader background in basic finance and statistics. | Tail risk, left tail of returns, loss distribution, VaR/ES as risk language. | Ch. 2, Ch. 3, Ch. 5. | Explain why market-risk analysis moves from prices to returns and from average volatility to tail behavior. |
| Ch. 2. Từ biến động có điều kiện đến thước đo rủi ro đuôi | Bridges volatility modeling and tail-risk measurement. | Ch. 1 concepts on returns, volatility, tail risk. | Conditional volatility, rolling volatility, EWMA, ARCH/GARCH logic, volatility forecast as input. | Ch. 3, Ch. 6, Ch. 7. | Explain what volatility forecasts can and cannot tell us about VaR/ES. |
| Ch. 3. Các kiến trúc mô hình VaR và Expected Shortfall | Core method chapter for model families and assumptions. | Ch. 1 risk language; Ch. 2 volatility logic. | Assumption map, historical simulation, parametric VaR, volatility-based VaR, quantile approaches, EVT/POT. | Ch. 4, Ch. 7, Ch. 8. | Compare VaR/ES model families by assumptions, data use, and misspecification risk. |
| Ch. 4. Thiết kế đánh giá mô hình rủi ro đuôi | Turns model construction into forecast evaluation and backtesting design. | Ch. 3 model families. | In-sample vs out-of-sample, VaR backtesting, tail severity, model acceptance policy. | Ch. 5, Ch. 7, Ch. 8. | Design a fair comparison of VaR/ES models and interpret backtesting outcomes. |
| Ch. 5. Dữ liệu VN-Index và cấu trúc thực nghiệm của rủi ro thị trường | Opens the empirical part and justifies VN-Index as the central evidence block. | Ch. 1 return concepts; Ch. 4 evaluation design. | Data design, return construction, distributional diagnostics, ARCH effects, empirical windows. | Ch. 6, Ch. 7. | Describe the VN-Index dataset and identify features that matter for volatility and tail-risk modeling. |
| Ch. 6. Đo lường và dự báo biến động trên VN-Index | Tests volatility measures and forecasts as inputs to tail-risk models. | Ch. 2 volatility methods; Ch. 5 data design. | VN-Index volatility benchmarks, GARCH-type models, OHLC-based proxies, forecast horizons. | Ch. 7, Ch. 8. | Decide which volatility models are credible candidates for VaR/ES comparison. |
| Ch. 7. So sánh thực nghiệm các mô hình VaR và Expected Shortfall trên VN-Index | Main empirical evidence chapter. | Ch. 3 model taxonomy; Ch. 4 evaluation design; Ch. 5 data; Ch. 6 volatility candidates. | Full model comparison, VaR/ES estimates, backtesting results, tail severity. | Ch. 8. | Make conditional conclusions about which models perform better under which criteria and market states. |
| Ch. 8. Hàm ý phương pháp và hàm ý quản trị rủi ro cho thị trường Việt Nam | Synthesis chapter that converts results into method and practice implications. | All previous chapters, especially Ch. 7. | Method lessons, model-use guidance, limitations, future extensions. | Closing synthesis. | Translate empirical findings into disciplined model choice and risk-management interpretation. |

## Transition Logic

| From | To | Required bridge |
| --- | --- | --- |
| Ch. 1 | Ch. 2 | Move from descriptive properties of returns to conditional volatility as a dynamic input. |
| Ch. 2 | Ch. 3 | Clarify that volatility alone is incomplete; VaR/ES also require distributional and tail assumptions. |
| Ch. 3 | Ch. 4 | Shift from "how models are built" to "how models are judged." |
| Ch. 4 | Ch. 5 | Turn evaluation principles into an empirical design for VN-Index. |
| Ch. 5 | Ch. 6 | Use the dataset's stylized facts to motivate volatility modeling choices. |
| Ch. 6 | Ch. 7 | Carry only defensible volatility candidates into VaR/ES comparison. |
| Ch. 7 | Ch. 8 | Convert model results into qualified methodological and practical conclusions. |

## Known Structural Risks

- Ch. 1 and Ch. 2 may overlap on basic volatility concepts; Ch. 1 should stay conceptual, while Ch. 2 should focus on conditional-volatility logic.
- Ch. 3 and Ch. 4 must stay distinct: Ch. 3 is model architecture; Ch. 4 is evaluation design.
- Ch. 5 and Ch. 6 must avoid repeating the same VN-Index descriptive statistics; Ch. 5 sets up data, Ch. 6 evaluates volatility forecasts.
- Ch. 7 should not become a table dump; it needs a clear model-comparison narrative.
- Ch. 8 currently needs the most original synthesis and should not merely recycle old conclusions.
