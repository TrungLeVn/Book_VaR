# Terminology And Notation Register

Last updated: 2026-05-23

Purpose: keep English-Vietnamese terms, abbreviations, and notation consistent across the book.

## Term Register

| English term | Vietnamese term | Abbreviation | First introduced | Preferred later usage | Notes |
| --- | --- | --- | --- | --- | --- |
| return | tỷ suất sinh lời | NA | Ch. 1 | `tỷ suất sinh lời` | Prefer this over switching between `tỷ lệ sinh lời` and `suất sinh lời`; older legacy files may use variants. |
| log return | tỷ suất sinh lời logarit | NA | Ch. 1 | `log return` after first definition if concise. | Define formula before empirical use. |
| volatility | biến động | NA | Ch. 1 | `volatility` or `biến động` depending on sentence clarity. | First use should explain that volatility is not directly observed. |
| conditional volatility | biến động có điều kiện | NA | Ch. 2 | `biến động có điều kiện` | Use for model-implied time-varying volatility. |
| tail risk | rủi ro đuôi | NA | Ch. 1 | `rủi ro đuôi` | For return data, specify left-tail risk when relevant. |
| loss | tổn thất | NA | Ch. 1 | `tổn thất` | State whether loss is `-return` or monetary loss. |
| Value-at-Risk | giá trị chịu rủi ro | VaR | Ch. 1 | `VaR` after first definition. | First use pattern: `giá trị chịu rủi ro (Value-at-Risk, VaR)`. |
| Expected Shortfall | tổn thất kỳ vọng trong vùng đuôi | ES | Ch. 1 | `Expected Shortfall (ES)` or `ES` | Alternative Vietnamese translations should be avoided unless explicitly justified. |
| historical simulation | mô phỏng lịch sử | HS | Ch. 3 | `mô phỏng lịch sử` | Use `HS` only in tables if space is tight. |
| parametric VaR | VaR tham số | NA | Ch. 3 | `VaR tham số` | Always state distributional assumption. |
| semi-parametric | bán tham số | NA | Ch. 3 | `bán tham số` | Use for quantile-based or hybrid methods when appropriate. |
| Extreme Value Theory | lý thuyết giá trị cực trị | EVT | Ch. 3 | `EVT` after first definition. | Use with caution; distinguish block maxima and POT if relevant. |
| Peaks-over-threshold | vượt ngưỡng | POT | Ch. 3 | `POT` | Define threshold selection issue. |
| misspecification risk | rủi ro sai đặc tả | NA | Ch. 3 | `rủi ro sai đặc tả` | Use when model assumptions can distort tail-risk measurement. |
| backtesting | kiểm định ngược | NA | Ch. 4 | `backtesting` or `kiểm định ngược` | First use pattern: `kiểm định ngược (backtesting)`. |
| out-of-sample | ngoài mẫu | OOS | Ch. 4 | `ngoài mẫu` | Use `OOS` only in tables or diagrams. |
| in-sample | trong mẫu | NA | Ch. 4 | `trong mẫu` | Keep paired with `ngoài mẫu` where useful. |
| unconditional coverage | tính phủ không điều kiện | NA | Ch. 4 | `tính phủ không điều kiện` | Usually linked to exceedance frequency tests such as Kupiec. |
| conditional coverage | tính phủ có điều kiện | NA | Ch. 4 | `tính phủ có điều kiện` | Use when coverage and independence are assessed jointly. |
| rolling window | cửa sổ trượt | NA | Ch. 2 or Ch. 4 | `cửa sổ trượt` | Specify window length and update rule. |
| forecast horizon | chân trời dự báo | NA | Ch. 4 or Ch. 6 | `chân trời dự báo` | State unit: day, week, etc. |
| exceedance | vi phạm VaR | NA | Ch. 4 | `vi phạm VaR` | Use when realized loss exceeds VaR. |
| violation rate | tỷ lệ vi phạm | NA | Ch. 4 | `tỷ lệ vi phạm` | Compare with target tail probability. |
| tail severity | mức độ nghiêm trọng vùng đuôi | NA | Ch. 4 | `tail severity` after definition if concise. | Tie to ES and losses conditional on exceedance. |
| Dynamic Quantile test | kiểm định phân vị động | DQ | Ch. 4 | `DQ` after first definition if concise. | Use for hit-based dynamic specification checks in VaR evaluation. |
| model acceptance policy | chính sách chấp nhận mô hình | NA | Ch. 4 | `chính sách chấp nhận mô hình` | Reserve for pass/recalibrate/replace logic after evaluation. |
| ARCH effect | hiệu ứng ARCH | ARCH | Ch. 2 or Ch. 5 | `hiệu ứng ARCH` | Define through conditional heteroskedasticity. |
| GARCH | mô hình GARCH | GARCH | Ch. 2 | `GARCH` | Expand once: Generalized Autoregressive Conditional Heteroskedasticity. |
| EWMA | trung bình trượt hàm mũ | EWMA | Ch. 2 | `EWMA` | Define decay factor and half-life when used. |
| historical volatility | biến động lịch sử | NA | Ch. 2 | `biến động lịch sử` | Use when volatility is estimated directly from past return data. |
| unconditional volatility | biến động không điều kiện | NA | Ch. 2 | `biến động không điều kiện` | Distinguish from model-implied conditional volatility. |
| half-life | chu kỳ bán rã | NA | Ch. 2 | `chu kỳ bán rã` | Useful for interpreting EWMA memory length. |
| RiskMetrics | RiskMetrics | NA | Ch. 2 or Ch. 6 | `RiskMetrics` | Treat as method family/name; source-check if making historical claims. |
| VN-Index | VN-Index | NA | Ch. 5 | `VN-Index` | Use consistently; avoid `VNINDEX` in prose unless referring to a variable name. |

## Notation Register

| Symbol | Meaning | Unit | First introduced | Used in chapters | Notes |
| --- | --- | --- | --- | --- | --- |
| `P_t` | Asset or index price at time `t` | Index points or currency | Ch. 1 | Ch. 1, Ch. 5 | Define whether close, adjusted close, or other price. |
| `r_t` | Return at time `t` | Decimal or percent | Ch. 1 | Ch. 1-Ch. 7 | State decimal vs percent in every empirical table. |
| `L_t` | Loss at time `t` | Decimal, percent, or currency | Ch. 1 | Ch. 1, Ch. 3, Ch. 4, Ch. 7 | If `L_t = -r_t`, say so explicitly. |
| `\sigma_t` | Conditional volatility at time `t` | Same return scale | Ch. 2 | Ch. 2, Ch. 6, Ch. 7 | Avoid using for unconditional standard deviation without clarification. |
| `\alpha` | Tail probability | Probability | Ch. 1 or Ch. 3 | Ch. 1, Ch. 3, Ch. 4, Ch. 7 | Example: VaR at 99% confidence has tail probability 1%. |
| `VaR_{\alpha,t}` | Value-at-Risk at tail probability `\alpha` and time `t` | Loss scale | Ch. 1 | Ch. 1, Ch. 3, Ch. 4, Ch. 7 | State sign convention. |
| `ES_{\alpha,t}` | Expected Shortfall at tail probability `\alpha` and time `t` | Loss scale | Ch. 1 | Ch. 1, Ch. 3, Ch. 4, Ch. 7 | Define as conditional tail expectation under the chosen loss convention. |
| `I_t` | Exceedance indicator | 0/1 | Ch. 4 | Ch. 4, Ch. 7 | Define `I_t = 1` when realized loss exceeds VaR. |
| `h` | Forecast horizon | Days or periods | Ch. 4 or Ch. 6 | Ch. 4, Ch. 6, Ch. 7 | Always attach unit. |

## Style Rules

- First-use pattern: Vietnamese term, then English term and abbreviation in parentheses.
- Later uses can use the abbreviation if already introduced and unambiguous.
- Do not hard-code figure numbers; use Quarto cross-references such as `@fig-...` and `@tbl-...`.
- Keep `VaR`, `ES`, `EWMA`, `GARCH`, `EVT`, and `POT` uppercase.
- When translating older legacy material, normalize `tỷ lệ sinh lời` to `tỷ suất sinh lời` unless a specific context requires otherwise.
