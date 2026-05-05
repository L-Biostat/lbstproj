#' Evaluate Code in a Temporary Example Project
#'
#' @description
#' `with_example_project()` creates a temporary, minimal project environment
#' and evaluates the provided code inside it. This is primarily intended for
#' use in `@examples`, vignettes, and tests to ensure reproducibility without
#' relying on the user's working directory.
#'
#' The temporary project replicates the full directory structure created by
#' [create_project()]: `R/figures/`, `R/tables/`, `R/data/`, `R/functions/`,
#' `data/raw/`, `data/processed/`, `data/tables/`, `data/tot/`,
#' `results/figures/`, `results/tables/`, `results/reports/`, and `report/`.
#' A minimal `DESCRIPTION` file and an `.Rproj` file are also written so that
#' [usethis::proj_path()] and related helpers work correctly throughout the
#' evaluation.
#'
#' @param code Code to evaluate inside the temporary project (use `{}`).
#' @param with_tot *Logical*. If `TRUE`, copies the package's example TOT
#'   (`inst/extdata/table_of_tables.xlsx`) into `data/tot/` and calls
#'   [import_tot()] so that [load_tot()], [get_info()], and related functions
#'   work immediately.
#'
#'   *Default*: `FALSE`.
#'
#' @return Invisibly returns the path to the temporary project directory.
#'
#' @details
#' Working directory and the active `usethis` project are both restored when
#' `with_example_project()` returns, even if `code` signals an error.
#'
#' @examples
#' with_example_project({
#'   create_figure("hr-by-age", open = FALSE, quiet = TRUE)
#'   fs::dir_tree("R/figures")
#' })
#'
#' @export
with_example_project <- function(code, with_tot = FALSE) {
  code <- substitute(code)

  root <- fs::dir_create(fs::file_temp("lbstproj-ex-"))

  # Capture state that must be restored on exit
  old_wd <- getwd()
  old_proj <- tryCatch(usethis::proj_get(), error = function(e) NULL)

  # Cleanup: restore wd -> restore project -> delete temp dir (FIFO order)
  on.exit(setwd(old_wd), add = TRUE)
  on.exit(
    tryCatch(
      if (!is.null(old_proj)) {
        suppressMessages(usethis::proj_set(old_proj, force = TRUE))
      },
      error = function(e) NULL
    ),
    add = TRUE
  )
  on.exit(fs::dir_delete(root), add = TRUE)

  setwd(root)

  # ---- Minimal project structure (mirrors create_structure()) ----
  fs::dir_create(c(
    "data/processed",
    "data/raw",
    "data/tables",
    "data/figures",
    "data/tot",
    "results/figures",
    "results/tables",
    "results/reports",
    "R/data",
    "R/figures",
    "R/functions",
    "R/tables",
    "report/utils"
  ))

  writeLines(
    c(
      "Package: exampleproject",
      "Title: Example Project",
      "Version: 0.1.0",
      "Description: Example project.",
      "License: MIT",
      "Client: Example Client",
      "Department: Example Dept",
      "TableEngine: gt"
    ),
    "DESCRIPTION"
  )

  writeLines("Version: 1.0", "exampleproject.Rproj")

  # Set the active usethis project to the temp root
  suppressMessages(usethis::proj_set(root, force = TRUE))

  # ---- Optional TOT ----
  if (with_tot) {
    tot_src <- fs::path_package("lbstproj", "extdata/table_of_tables.xlsx")
    fs::file_copy(tot_src, "data/tot/table_of_tables.xlsx")
    import_tot(quiet = TRUE)
  }

  # ---- Evaluate user code ----
  eval(code, envir = parent.frame())

  invisible(root)
}
