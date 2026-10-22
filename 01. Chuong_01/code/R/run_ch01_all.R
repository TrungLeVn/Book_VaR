# Run the full Chapter 1 R workflow.
script_dir <- local({
  frame_files <- vapply(sys.frames(), function(env) {
    if (exists("ofile", envir = env, inherits = FALSE)) {
      get("ofile", envir = env, inherits = FALSE)
    } else {
      ""
    }
  }, character(1))
  frame_files <- frame_files[nzchar(frame_files)]
  if (length(frame_files) > 0) {
    dirname(normalizePath(frame_files[[length(frame_files)]], winslash = "/", mustWork = TRUE))
  } else {
    normalizePath(getwd(), winslash = "/", mustWork = TRUE)
  }
})

source(file.path(script_dir, "00_ch01_setup.R"), encoding = "UTF-8")
source(file.path(script_dir, "01_ch01_appendix_tables_figures.R"), encoding = "UTF-8")
source(file.path(script_dir, "99_ch01_export.R"), encoding = "UTF-8")
