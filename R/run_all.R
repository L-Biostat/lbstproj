#' Run All R Scripts
#'
#' @description Run all R scripts in a directory in the `R` folder.
#'
#'   The functions `run_all_figures()` and `run_all_tables()` are wrappers
#'   around the more general `run_all()` function to run all R scripts in the
#'   `R/figures` or `R/tables` directories, respectively.
#'
#'   For these two cases, the function checks for discrepancies between the files
#'   in the directory and the table of tables (ToT) before running the scripts
#'   and throws a warning if any are found.
#'
#' @param dir Character. The directory to run the scripts from. Must be an
#'   existing directory in the `R` folder of the project. For example,
#'   `"figures"` will run all scripts in `R/figures`.
#' @param skip Optional integer. Number of scripts to skip from the start.
#'   Default is `NULL` meaning all scripts are run.
#'
#' @details All R scripts are found by matching `*.R` in the respective
#'   directory. Therefore, any file ending in `.r` (techically valid but not
#'   recommended) will be ignored.
#'
#' @examples
#' \dontrun{
#' run_all("figures")
#' run_all_figures() # equivalent to previous
#' run_all("data")
#' run_all("directory-that-does-not-exist") # throws an error
#' run_all_tables(skip = 3) # starts from the 4th script
#' }
#'
#' @name run_all
#' @export
run_all <- function(dir, skip = NULL) {
  # Check that dir exists
  full_dir <- usethis::proj_path("R", dir)
  if (!fs::dir_exists(full_dir)) {
    cli::cli_abort(
      "Directory {.path {fs::path_rel(full_dir)}} does not exist in the project.",
      call = rlang::caller_env()
    )
  }
  # Check that skip is a non-negative integer if non-NULL
  if (!is.null(skip)) {
    if (!is.numeric(skip) || skip <= 0 || !rlang::is_integerish(skip)) {
      cli::cli_abort(
        "{.arg skip} must be a positive integer.",
        call = rlang::caller_env()
      )
    }
  }
  # List all R files
  files <- fs::dir_ls(
    full_dir,
    type = "file",
    glob = "*.R",
    recurse = FALSE
  )
  n_files <- length(files)
  # If the directory is `figures` or `tables`, compare with the TOT
  if (dir %in% c("figures", "tables")) {
    compare_with_tot(dir, files)
  }
  # Printed message
  cli::cli_h1("Generating all files in {fs::path_rel(full_dir)}")
  cli::cli_alert_info("Found {n_files} file{?s}}")
  # End early if all files are skipped
  if (!is.null(skip)) {
    if (skip >= n_files) {
      cli::cli_alert_info("Skipping all {n_files} file{?s}.")
      return(invisible(NULL))
    }
    files <- files[-seq_len(skip)]
    cli::cli_alert_info("Skipping first {skip} file{?s}.")
    skip_idx <- skip
  } else {
    skip_idx <- 0
  }
  # Source each script with progress bar and message
  for (i in seq_along(files)) {
    f <- files[i]
    script <- f |>
      fs::path_file() |>
      fs::path_ext_remove()
    cli::cli_progress_step(
      msg = "Sourcing file {i+skip_idx}/{n_files}: {.strong {script}}",
      msg_done = "Sourced file {i+skip_idx}/{n_files}: {.strong {script}}"
    )
    withr::with_options(
      list(save.print = FALSE, export.print = FALSE),
      source(usethis::proj_path("R", dir, script, ext = "R"))
    )
    cli::cli_progress_done()
  }
}

compare_with_tot <- function(dir, files) {
  # List all files in the ToT
  tot <- load_tot()
  tot_files <- tot$name[tot$type == sub("s$", "", dir)] |>
    fs::path(ext = "R")
  # Remove parent path from the file names
  r_files <- files |>
    fs::path_file()
  # Compare
  only_in_dir <- setdiff(r_files, tot_files)
  only_in_tot <- setdiff(tot_files, r_files)
  if (length(only_in_dir) > 0) {
    # Truncate long vectors of file names
    f <- cli::cli_vec(
      only_in_dir,
      list("vec-trunc" = 3, "vec-trunc-style" = "head")
    )
    full_dir <- usethis::proj_path("R", dir)
    # Alert user
    cli::cli_alert_warning(
      "Found {length(f)} file{?s} in {full_dir} but not in the ToT: {f}"
    )
  }
  if (length(only_in_tot) > 0) {
    f <- cli::cli_vec(
      only_in_tot,
      list("vec-trunc" = 3, "vec-trunc-style" = "head")
    )
    cli::cli_alert_warning(
      "Found {length(f)} file{?s} in the ToT but not in {full_dir}: {f}"
    )
  }
}

#' @describeIn run_all run all R scripts in `R/figures`
#' @export
run_all_figures <- function(skip = NULL) {
  run_all("figures", skip)
}

#' @describeIn run_all run all R scripts in `R/tables`
#' @export
run_all_tables <- function(skip = NULL) {
  run_all("tables", skip)
}
