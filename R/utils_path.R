# -------------------------------------------------------------------------
# ┌────────────┐
# │  lbstproj  │
# └────────────┘
#
# utils_path.R:
# utility functions to handle paths and directories in the project
# -------------------------------------------------------------------------

#' Ensure a directory exists
#'
#' @description
#' `r lifecycle::badge("stable")`
#'
#' Create a directory (recursively) if it does not exist already or throw an
#' error if needed. Paths must be relative to the active project, not absolute.
#'
#' @param path *Character*. Directory path. Must be relative to active project
#'   and not absolute.
#' @param create *Logical*. If `FALSE`, throws an error if the directory does
#'   not exist. If `TRUE` creates it.
#'
#'   *Default*: `TRUE`
#'
#' @return Invisibly returns the normalized path to the directory, relative to
#'   the active project.
#'
#' @keywords internal
ensure_dir_exists <- function(path, create = TRUE) {
  # Ensure path is a string
  check_string(path)
  # Normalize path just in case
  path <- fs::path_norm(path)
  # Errors if the path is absolute
  if (fs::is_absolute_path(path)) {
    cli::cli_abort(
      "Path must be relative to the active project, not absolute."
    )
  }
  # Ends early if it exists
  if (fs::dir_exists(path)) {
    return(invisible(path))
  }
  # If create is FALSE, throw an error
  if (!isTRUE(create)) {
    cli::cli_abort("Directory {.path {path}} does not exist.")
  }
  # Else create and inform user
  fs::dir_create(path)
  cli::cli_alert_info("Created directory {.path {path}}.")
  invisible(path)
}

#' Validate the name of a script
#'
#' Ensures that the name of a R script only contains valid characters (letters, numbers, underscores, and hyphens) and remove any potential extension.
#'
#' @param name *Character*. The name of the script to validate.
#'
#' @return *Character*. The validated name of the script without any extension.
#'
#' @keywords internal
validate_file_name <- function(name) {
  # Ensure the name is a string
  check_string(name)
  # Remove any .r/.R extension if present
  name <- fs::path_ext_remove(name)
  # Ensure only alphabetic characters, numbers, underscores, and hyphens
  # are present
  if (!grepl("^[a-zA-Z0-9_-]+$", name)) {
    cli::cli_abort(
      c(
        "File name {.val {name}} is invalid.",
        "i" = "Only letters, numbers, underscores, and hyphens are allowed."
      )
    )
  }
  # Returns the name
  name
}
