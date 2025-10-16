#' Run All R Scripts in ToT
#'
#' @description
#' Run all R scripts listed in the Table of Tables (ToT) for a specified type (figure or table).
#'
#' @param skip Optional vector of non-negative integers corresponding to the `id` column in the ToT. Any scripts with these IDs will be skipped.
#'
#' @md
#' @name run_all
NULL

#' @describeIn run_all run all scripts of type "figure"
#' @export
run_all_figures <- function(skip = NULL) {
  run_all_programs("figure", skip)
}

#' @describeIn run_all run all scripts of type "table"
#' @export
run_all_tables <- function(skip = NULL) {
  run_all_programs("table", skip)
}


run_all_programs <- function(type, skip = NULL) {
  # Check that type is valid
  type <- rlang::arg_match(type, c("figure", "table"))
  # Check that skip is a vector of non-negative integers if non-NULL
  if (!is.null(skip)) {
    if (!is.numeric(skip) || any(skip < 0) || any(skip != as.integer(skip))) {
      cli::cli_abort("{.arg skip} must be a vector of non-negative integers.")
    }
  }
  # Printed message
  cli::cli_h1("Generating all {type}s\n")
  # Load the ToT
  tot <- load_tot()
  # Isolate corresponding scripts in the ToT
  script_names <- tot$name[tot$type == type]
  if (!is.null(skip)) {
    script_names <- tot$name[tot$type == type & !(tot$id %in% (skip))]
  }
  n_scripts <- length(script_names)
  cli::cli_alert_info(
    "Found {cli::no(n_scripts)} {type}{cli::qty(n_scripts)}{?s} in ToT"
  )

  # Source each script with progress bar and message
  seq <- seq_len(n_scripts)
  for (i in seq) {
    script <- script_names[i]
    cli::cli_progress_step(
      "Generating {type} {.val {i}}: {.emph {script}}"
    )
    withr::with_options(
      list(save.print = FALSE, export.print = FALSE),
      source(fs::path("R", type, script, ext = "R"))
    )
  }
  cli::cli_progress_done()
}
