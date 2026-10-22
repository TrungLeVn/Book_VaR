# B04 — the PPM macOS binary of gdtools links to XQuartz (/opt/X11/lib/libXrender.1.dylib),
# which is not installed on this Mac, so flextable fails to load. Rebuild gdtools from
# source against Homebrew cairo/freetype/fontconfig (needs Xcode CLT + pkg-config).
# The Homebrew fontconfig link line needs -lintl, so Makevars.gdtools adds -L/opt/homebrew/lib.
# Run from 02. Drafts/:
#   R_MAKEVARS_USER=results/B04_20261022-1420/Makevars.gdtools Rscript results/B04_20261022-1420/install_gdtools_source.R
renv::install("gdtools", type = "source", rebuild = TRUE, prompt = FALSE)
stopifnot(requireNamespace("gdtools", quietly = TRUE), requireNamespace("flextable", quietly = TRUE))
cat("gdtools", as.character(packageVersion("gdtools")), "| flextable", as.character(packageVersion("flextable")), "loadable\n")
