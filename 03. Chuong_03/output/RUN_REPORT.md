# Run report — Chương 3

- Source used: archive fallback
- Sample: 2010-01-06 to 2026-05-20; 4080 log returns.
- Mean equation: ARMA(2,1) selected by lowest BIC among ARMA(0:3,0:3) candidates with Ljung-Box p >= 0.05.
- Volatility models: GARCH-normal; GARCH-Student-t; GJR-GARCH-Student-t; GJR-GARCH-skewed-t; EGARCH-Student-t; EGARCH-skewed-t; APARCH-Student-t; APARCH-skewed-t.
- Forecast origins: 50; window = 1250; refit step = 20.
- QLIKE is the non-negative variance loss `actual/forecast - log(actual/forecast) - 1`.

## Best models by horizon and loss

# A tibble: 12 × 5
   model               horizon n_origins metric  value
   <chr>                 <int>     <int> <chr>   <dbl>
 1 GJR-GARCH-skewed-t        1        50 MAE     1.85 
 2 GJR-GARCH-Student-t       1        50 QLIKE   1.53 
 3 GJR-GARCH-Student-t       1        50 RMSE    6.11 
 4 EGARCH-skewed-t           5        50 MAE     5.08 
 5 EGARCH-skewed-t           5        50 QLIKE   0.363
 6 EGARCH-Student-t          5        50 RMSE    8.85 
 7 EGARCH-skewed-t          10        50 MAE     9.74 
 8 GARCH-normal             10        50 QLIKE   0.350
 9 GJR-GARCH-skewed-t       10        50 RMSE   14.4  
10 EGARCH-skewed-t          20        50 MAE    20.6  
11 GARCH-normal             20        50 QLIKE   0.401
12 APARCH-skewed-t          20        50 RMSE   32.0  
