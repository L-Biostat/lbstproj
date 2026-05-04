#' Evaluate Code in a Temporary Example Project
#'
#' @description
#' `with_example_project()` creates a temporary, minimal project environment
#' and evaluates the provided code inside it. This is primarily intended for
#' use in `@examples`, vignettes, and tests to ensure reproducibility without
#' relying on the user’s working directory.
#'
#' @param code Code to evaluate inside the temporary project (use `{}`).
#' @param with_tot Logical. Should a minimal table of tables (TOT) file be created?
#' @param tot_data Optional data.frame used as TOT content.
#'
#' @return Invisibly returns the path to the temporary project directory.
#'
#' @details
#' The temporary project includes a minimal directory structure, a
#' `DESCRIPTION` file, and an `.Rproj` file. All changes are scoped to the
#' evaluation and do not affect the global environment.
#'
#' @examples
#' with_example_project({
#'   create_file("table", "baseline", open = FALSE)
#' })
#'
#' @keywords internal
#' @export
with_example_project <- function(code) {
  code <- substitute(code)

  root <- fs::dir_create(fs::file_temp("lbstproj-"))

  withr::with_dir(root, {
    # ---- minimal scaffold ----
    fs::dir_create("data")
    fs::dir_create("R/figures")
    fs::dir_create("R/tables")
    fs::dir_create("R/data")
    fs::dir_create("output/figures")
    fs::dir_create("output/tables")

    writeLines("Package: fakeproject", "DESCRIPTION")
    # writeLines("Version: 1.0", "fakeproject.Rproj")
    fs::file_create(".here")

    # ---- evaluate user code ----
    eval(code, envir = parent.frame())
  })

  invisible(root)
}
