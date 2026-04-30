# -------------------------------------------------------------------------
# ┌------------┐
#   lbstproj
# \------------┘
#
# load_functions.R:
# Source R helper files from R/functions/
# -------------------------------------------------------------------------

#' Source a file from `R/functions/`
#'
#' @description
#' `load_function()` sources a single R script from `R/functions/`. Use this
#' to bring helper functions defined in a `create_function()` script into the
#' current session.
#'
#' `load_all_functions()` sources every `.R` file found in `R/functions/`.
#'
#' @param name *Character*. File name (with or without `.R`) of the script to
#'   load from `R/functions/`.
#' @param quiet *Logical*. If `TRUE`, suppress informational messages.
#'
#'   *Default*: `FALSE` unless the global option `lbstproj.quiet` is set
#'   otherwise.
#'
#' @return Invisibly returns the path of the sourced file.
#'
#' @examples
#' if (FALSE) {
#' load_function("helpers")
#' # > v Sourced 'R/functions/helpers.R'
#' }
#'
#' @name load_functions
#' @export
load_function <- function(
  name,
  quiet = getOption("lbstproj.quiet", FALSE)
) {
  check_string(name)

  # Strip .R extension if provided, then rebuild the path
  name <- fs::path_ext_remove(name)
  rel_path <- fs::path("R", "functions", name, ext = "R")
  full_path <- usethis::proj_path(rel_path)

  if (!fs::file_exists(full_path)) {
    cli::cli_abort(
      "File {.file {rel_path}} does not exist in the project.",
      call = rlang::caller_env()
    )
  }

  source(full_path)

  if (isFALSE(quiet)) {
    cli::cli_alert_success("Sourced {.file {rel_path}}")
  }

  invisible(full_path)
}


#' @describeIn load_functions Source all R scripts in `R/functions/`
#'
#' @return Invisibly returns the character vector of sourced file paths.
#'
#' @examples
#' if (FALSE) {
#' load_all_functions()
#' # > v Sourced 'R/functions/helpers.R'
#' # > v Sourced 'R/functions/utils.R'
#' }
#'
#' @export
load_all_functions <- function(
  quiet = getOption("lbstproj.quiet", FALSE)
) {
  full_dir <- usethis::proj_path("R", "functions")
  rel_dir <- fs::path("R", "functions")

  if (!fs::dir_exists(full_dir)) {
    cli::cli_abort(
      "Directory {.path {rel_dir}} does not exist in the project.",
      call = rlang::caller_env()
    )
  }

  files <- fs::dir_ls(full_dir, type = "file", glob = "*.R", recurse = FALSE)

  if (length(files) == 0L) {
    if (isFALSE(quiet)) {
      cli::cli_alert_info("No R files found in {.path {rel_dir}}.")
    }
    return(invisible(character()))
  }

  for (f in files) {
    source(f)
    if (isFALSE(quiet)) {
      cli::cli_alert_success(
        "Sourced {.file {fs::path(rel_dir, fs::path_file(f))}}"
      )
    }
  }

  invisible(files)
}
