# -------------------------------------------------------------------------
# ┌------------┐
#   lbstproj
# \------------┘
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

#' Ensure a file does not exist
#'
#' @description
#' Verify if the path to a file exists and throws an error if it the case. This is used
#' purely for validation purposes.
#'
#' @param file *Character*. File path. Must be relative to active project
#'   and not absolute.
#'
#' @return Invisibly returns the normalized path to the file, relative to
#'   the active project.
#'
#' @keywords internal
ensure_file_does_not_exist <- function(file) {
  # Ensure path is a string
  check_string(file)
  # Normalize path just in case
  file <- fs::path_norm(file)
  # Errors if the path is absolute
  if (fs::is_absolute_path(file)) {
    cli::cli_abort(
      "Path must be relative to the active project, not absolute."
    )
  }
  # Error if it exists
  if (fs::file_exists(file)) {
    cli::cli_abort(
      "File {.path {file}} already exists and will not be overwritten."
    )
  }
  # Invisible return of the file path
  invisible(file)
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
  # Ensure only alphabetic characters, numbers, and hyphens are present
  if (!grepl("^[a-zA-Z0-9-]+$", name)) {
    cli::cli_abort(
      c(
        "File name {.val {name}} is invalid.",
        "i" = "Only letters, numbers, and hyphens are allowed."
      )
    )
  }
  # Returns the name
  name
}

#' Map a file type to its R subdirectory
#'
#' Converts a `type` string (as used in [create_file()] and [run_all_files()])
#' to the corresponding subdirectory name inside `R/`.
#'
#' @param type *Character*. The file type (e.g. `"figure"`, `"table"`,
#'   `"data"`, `"analysis"`).
#'
#' @return *Character*. The subdirectory name.
#'
#' @keywords internal
type_to_subdir <- function(type) {
  switch(
    type,
    data = "data",
    analysis = "analysis",
    paste0(type, "s")
  )
}

#' Check if a file can be overwritten
#'
#' @param path *Character*. Path of the file to check
#' @param overwrite *Logical*. Whether the file can be overwritten or not.
#' @param what *Character*. The type of file being checked. This is only used to customize the error message if the file can't be overwritten.
#'
#'   *Default*: `"File"`. A generic description
#' @return Invisibly return the path of the file
#'
#' @keywords internal
check_can_overwrite <- function(path, overwrite, what = "File") {
  if (fs::file_exists(path) && !overwrite) {
    cli::cli_abort(
      "{what} {.file {path}} already exists and {.arg overwrite} is set to {.val FALSE}."
    )
  }
  invisible(path)
}

# Return path relative to the active project root.
#
# @keywords internal
proj_rel <- function(path) {
  fs::path_rel(path, start = usethis::proj_get())
}

# Return the project-relative path to a dated report file.
#
# @keywords internal
report_file_path <- function(
  output_type,
  extension = "qmd",
  date = Sys.Date()
) {
  file_name <- paste0(output_type, "_report_", format(date, "%Y_%m_%d"))
  fs::path("report", file_name, ext = extension)
}

# Find the latest report file in report/ for one or more extensions.
#
# @keywords internal
find_latest_report_file <- function(extensions) {
  ensure_dir_exists("report", create = FALSE)

  files <- fs::dir_ls("report", type = "file", recurse = FALSE)
  files <- files[fs::path_ext(files) %in% extensions]

  if (length(files) == 0L) {
    return(character())
  }

  info <- fs::file_info(files)
  files[[order(info$modification_time, fs::path_file(files), decreasing = TRUE)[
    1
  ]]]
}

# Resolve a report file path from an explicit file name or the latest match.
#
# @keywords internal
resolve_report_file <- function(file = NULL, extensions, action = "use") {
  if (is.null(file)) {
    file_path <- find_latest_report_file(extensions)
    if (length(file_path) == 0L) {
      cli::cli_abort(
        c(
          "x" = "No report file found in {.path report/}.",
          "i" = "Create or render a report first, or provide {.arg file} explicitly."
        )
      )
    }
    return(file_path)
  }

  check_string(file)
  file_path <- usethis::proj_path("report", file)
  rel_path <- proj_rel(file_path)

  if (!fs::file_exists(file_path)) {
    cli::cli_abort(
      c(
        "x" = "Report file {.path {rel_path}} does not exist.",
        "i" = "Please provide a valid report file to {action}."
      )
    )
  }

  file_path
}

# Infer the output extension for a Quarto report file.
#
# @keywords internal
report_output_extension <- function(file_path) {
  lines <- readLines(file_path, warn = FALSE)
  header_delims <- which(trimws(lines) == "---")

  if (length(header_delims) >= 2 && header_delims[[1]] == 1) {
    header <- lines[(header_delims[[1]] + 1):(header_delims[[2]] - 1)]

    if (
      any(grepl("^\\s*format\\s*:\\s*html\\s*$", header)) ||
        any(grepl("^\\s*html\\s*:\\s*$", header))
    ) {
      return("html")
    }

    if (
      any(grepl("^\\s*format\\s*:\\s*docx\\s*$", header)) ||
        any(grepl("^\\s*docx\\s*:\\s*$", header))
    ) {
      return("docx")
    }
  }

  file_name <- fs::path_file(file_path)
  if (grepl("^docx_report(_\\d{4}_\\d{2}_\\d{2})?\\.qmd$", file_name)) {
    return("docx")
  }

  "html"
}
