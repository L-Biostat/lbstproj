# -------------------------------------------------------------------------
# ┌────────────┐
# │  lbstproj  │
# └────────────┘
#
# run_all.R:
# Run all R scripts in a project subdirectory
# -------------------------------------------------------------------------

#' Run R Scripts in a Project Subdirectory
#'
#' @description
#' `run_all_files()` sources all R scripts matching a glob pattern inside a
#' subdirectory of the project's `R/` folder. The target subdirectory is derived
#' from the `type` argument using the same convention as [create_file()]:
#' `"figure"` maps to `R/figures/`, `"table"` maps to `R/tables/`,
#' `"data"` maps to `R/data/`, `"analysis"` maps to `R/analysis/`, and any
#' other value maps to `R/<type>s/`.
#'
#' For `type` values `"figure"` or `"table"`, the function additionally checks
#' for discrepancies between the files in the directory and the table of tables
#' (ToT) before sourcing, and issues a warning if any are found.
#'
#' `run_all_figures()` and `run_all_tables()` are convenient wrappers around
#' `run_all_files()`.
#'
#' @param type *Character*. The type of scripts to run. Controls the
#'   subdirectory of `R/` that is searched:
#'   - `"figure"` -> `R/figures/`
#'   - `"table"` -> `R/tables/`
#'   - `"data"` -> `R/data/`
#'   - `"analysis"` -> `R/analysis/`
#'   - any other value -> `R/<type>s/`
#' @param glob *Character*. A glob pattern passed to [fs::dir_ls()] to include
#'   or exclude files.
#'
#'   *Default*: `"*.R"` -- matches all R scripts (case-sensitive).
#' @param quiet *Logical*. If `TRUE`, suppress informational messages.
#'
#'   *Default*: `FALSE` unless the global option `lbstproj.quiet` is set
#'   otherwise. The default can be changed via `options(lbstproj.quiet = TRUE)`.
#'
#' @return Invisibly returns the character vector of sourced file paths.
#'
#' @examples
#' \dontrun{
#' run_all_files("figure")
#' run_all_figures()                                 # equivalent to the above
#' run_all_files("data")
#' run_all_files("figure", glob = "fig-[0-9]*.R")   # only numbered figures
#' run_all_files("figure", quiet = TRUE)             # suppress all messages
#' }
#'
#' @name run_all_files
#' @export
run_all_files <- function(
  type,
  glob = "*.R",
  quiet = getOption("lbstproj.quiet", FALSE)
) {
  check_string(type)
  check_string(glob)

  # Resolve subdirectory from type (same logic as create_file())
  subdir <- type_to_subdir(type)
  full_dir <- usethis::proj_path("R", subdir)
  rel_dir <- fs::path("R", subdir)

  # Ensure the directory exists
  if (!fs::dir_exists(full_dir)) {
    cli::cli_abort(
      "Directory {.path {rel_dir}} does not exist in the project.",
      call = rlang::caller_env()
    )
  }

  # List files, applying glob against filename only (not full path)
  files <- fs::dir_ls(full_dir, type = "file", recurse = FALSE)
  files <- files[grepl(utils::glob2rx(glob), fs::path_file(files), perl = TRUE)]
  n_files <- length(files)

  # For figure/table types, compare with the ToT
  if (type %in% c("figure", "table")) {
    compare_with_tot(type, files)
  }

  # Header message
  if (!quiet) {
    cli::cli_h1("Running all {type} files in {.path {rel_dir}}")
    cli::cli_alert_info("Found {n_files} file{?s}.")
  }

  # Source each script with progress messages, collecting any errors
  errors <- list()

  for (i in seq_along(files)) {
    script <- files[i] |> fs::path_file() |> fs::path_ext_remove()
    if (!quiet) {
      cli::cli_progress_step(
        msg = "Sourcing file {i}/{n_files}: {.strong {script}}",
        msg_done = "Sourced file {i}/{n_files}: {.strong {script}}",
        msg_failed = "Failed file {i}/{n_files}: {.strong {script}}"
      )
    }
    result <- tryCatch(
      withr::with_options(
        list(lbstproj.quiet = TRUE),
        source(usethis::proj_path("R", subdir, script, ext = "R"))
      ),
      error = function(e) e
    )
    if (inherits(result, "error")) {
      errors[[script]] <- result
      if (!quiet) cli::cli_progress_done(result = "failed")
    } else {
      if (!quiet) cli::cli_progress_done()
    }
  }

  # Always report failures, regardless of quiet
  if (length(errors) > 0L) {
    n_err <- length(errors)
    cli::cli_alert_warning(
      "{n_err} script{?s} failed and {?was/were} skipped:"
    )
    for (nm in names(errors)) {
      cli::cli_bullets(c(
        "x" = "{.strong {nm}}: {conditionMessage(errors[[nm]])}"
      ))
    }
  }

  invisible(files)
}

compare_with_tot <- function(type, files) {
  tot <- load_tot()
  tot_files <- tot$name[tot$type == type] |> fs::path(ext = "R")
  r_files <- files |> fs::path_file()
  only_in_dir <- setdiff(r_files, tot_files)
  # only_in_tot <- setdiff(tot_files, r_files)
  rel_dir <- fs::path("R", type_to_subdir(type))

  if (length(only_in_dir) > 0) {
    f <- cli::cli_vec(
      only_in_dir,
      list("vec-trunc" = 3, "vec-trunc-style" = "head")
    )
    cli::cli_alert_warning(
      "Found {length(f)} file{?s} in {.path {rel_dir}} but not in the ToT: {f}"
    )
  }
  # if (length(only_in_tot) > 0) {
  #   f <- cli::cli_vec(
  #     only_in_tot,
  #     list("vec-trunc" = 3, "vec-trunc-style" = "head")
  #   )
  #   cli::cli_alert_warning(
  #     "Found {length(f)} file{?s} in the ToT but not in {.path {rel_dir}}: {f}"
  #   )
  # }
}

#' @describeIn run_all_files Run all R scripts in `R/figures`
#' @export
run_all_figures <- function(
  glob = "*.R",
  quiet = getOption("lbstproj.quiet", FALSE)
) {
  run_all_files("figure", glob = glob, quiet = quiet)
}

#' @describeIn run_all_files Run all R scripts in `R/tables`
#' @export
run_all_tables <- function(
  glob = "*.R",
  quiet = getOption("lbstproj.quiet", FALSE)
) {
  run_all_files("table", glob = glob, quiet = quiet)
}
