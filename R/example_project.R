# -------------------------------------------------------------------------
# ┌------------┐
#   lbstproj
# \------------┘
#
# example_project.R:
# Set up a temporary project environment for use in examples
# -------------------------------------------------------------------------

#' Set Up a Temporary Example Project
#'
#' @description
#' `example_project()` creates a temporary, minimal project environment for use
#' in `@examples`, vignettes, and tests. It sets up the standard directory
#' structure and optionally creates a table of tables (TOT), then changes the
#' working directory and active project to the temporary location for the
#' **calling** scope.
#'
#' All files and directories are cleaned up automatically when the calling
#' scope exits (e.g. at the end of the example or test function).
#'
#' @param with_tot *Logical*. If `TRUE`, creates a minimal table of tables
#'   (`data/tot/table_of_tables.xlsx`) from scratch. Default: `TRUE`.
#' @param quiet *Logical*. If `TRUE`, suppresses setup messages. Default: `TRUE`.
#'
#' @return The path to the temporary project directory (invisibly).
#'
#' @details
#' This function is intended exclusively for `@examples`, vignettes, and tests —
#' not for production code. It modifies the working directory and active
#' `usethis` project in the **calling** scope via [withr::local_tempdir()],
#' [withr::local_dir()], and [usethis::local_project()], ensuring full cleanup
#' on exit with no persistent side effects.
#'
#' @keywords internal
#' @export
example_project <- function(with_tot = TRUE, quiet = TRUE) {
  # Create a temp directory that lives as long as the calling scope
  tmp <- withr::local_tempdir(
    pattern = "lbstproj-example-",
    .local_envir = parent.frame()
  )

  # Change directory to the temp project for the calling scope
  withr::local_dir(tmp, .local_envir = parent.frame())

  # ---- Minimal project structure ----
  fs::dir_create(c(
    "data/processed",
    "data/raw",
    "data/tot",
    "R/data",
    "R/figures",
    "R/functions",
    "R/tables",
    "output/figures",
    "output/tables",
    "report"
  ))

  # ---- Minimal DESCRIPTION ----
  writeLines(
    c(
      "Package: exampleproject",
      "Version: 0.0.0",
      "Title: Example Project",
      "Description: Temporary example project.",
      "License: MIT",
      "Client: Example Client",
      "Department: EXAMPLE",
      "TableEngine: gt"
    ),
    "DESCRIPTION"
  )

  # ---- Minimal .Rproj file ----
  writeLines(
    c(
      "Version: 1.0",
      "",
      "RestoreWorkspace: No",
      "SaveWorkspace: No"
    ),
    "exampleproject.Rproj"
  )

  # ---- Optional TOT (created from scratch, not copied from extdata) ----
  if (with_tot) {
    rlang::check_installed(
      "writexl",
      reason = "to write the table of tables in `example_project()`"
    )
    tot_data <- data.frame(
      id = c("1", "2"),
      type = c("figure", "table"),
      name = c("fig1", "tab1"),
      caption = c("Figure 1 caption", "Table 1 caption"),
      stringsAsFactors = FALSE
    )
    writexl::write_xlsx(
      x = list(tot = tot_data),
      path = "data/tot/table_of_tables.xlsx"
    )
  }

  # Set the active project to the temp dir for the calling scope
  usethis::local_project(tmp, .local_envir = parent.frame(), quiet = TRUE)

  # Inform the user
  cli::cli_alert_info("Working in example project {.path {tmp}}")

  invisible(tmp)
}
