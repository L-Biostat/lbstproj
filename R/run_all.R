#' Run All R Scripts in ToT
#'
#' @description Run all R scripts listed in the Table of Tables (ToT) for a
#' specified type (figure or table).
#'
#' @param skip Optional vector of non-negative integers corresponding to the
#'   `id` column in the ToT. Any scripts with these IDs will be skipped.
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
    if (!is.numeric(skip) || skip < 0 || rlang::is_integerish(skip)) {
      cli::cli_abort(
        "{.arg skip} must be a positive integer.",
        call = rlang::caller_env()
      )
    }
  }
  # List all R files
  dirname <- fs::path("R", paste0(type, "s"))
  files <- fs::dir_ls(
    dirname,
    type = "file",
    glob = "*.R",
    recurse = FALSE
  ) |>
    fs::path_file()
  # List corresponding files in TOT
  tot <- load_tot()
  tot_files <- tot$name[tot$type == type] |>
    fs::path(ext = "R")
  # Compare files
  compare_files(type, files, tot_files)

  # Printed message
  cli::cli_h1("Generating all {type}s\n")
  cli::cli_alert_info(
    "Found {length(files)} {type}{cli::qty(length(files))}{?s} in {dirname}"
  )

  # Source each script with progress bar and message
  for (f in files) {
    script <- f |>
      fs::path_file() |>
      fs::path_ext_remove()
    cli::cli_progress_step("Generating {type} {.strong {script}}")
    withr::with_options(
      list(save.print = FALSE, export.print = FALSE),
      source(fs::path("R", paste0(type, "s"), script, ext = "R"))
    )
    Sys.sleep(runif(1))
    cli::cli_progress_done()
  }
}

compare_files <- function(type, files, tot_files) {
  dir_name <- fs::path("R", paste0(type, "s"))
  # Compare
  only_in_dir <- setdiff(files, tot_files)
  only_in_tot <- setdiff(tot_files, files)
  if (length(only_in_dir) > 0) {
    f <- cli::cli_vec(
      only_in_dir,
      list("vec-trunc" = 3, "vec-trunc-style" = "head")
    )
    cli::cli_alert_warning(
      "Found {length(f)} file{?s} in {dir_name} but not in the ToT: {f}"
    )
  }
  if (length(only_in_tot) > 0) {
    f <- cli::cli_vec(
      only_in_tot,
      list("vec-trunc" = 3, "vec-trunc-style" = "head")
    )
    cli::cli_alert_warning(
      "Found {length(f)} file{?s} in the ToT but not in {dir_name}: {f}"
    )
  }
}
