f <- function() c(rnorm(120, 0.0002, 0.006), rnorm(70, -0.0001, 0.022), rnorm(110, 0.0002, 0.010))
cand <- c(1:200000)
hits <- c()
for (s in cand) { set.seed(s); r <- f(); a <- which.max(r); b <- which.min(r)
  if (a >= 168 && a <= 176 && b >= 181 && b <= 189 && r[a] > 0.049 && r[a] < 0.056 && r[b] < -0.042 && r[b] > -0.048) hits <- c(hits, s) }
cat("hits:", head(hits, 50), "\n")
set.seed(20260708); r <- f(); cat("current seed: argmax", which.max(r), max(r), "argmin", which.min(r), min(r), "\n")
