#' Ensure directory exists
#'
#' Checks if a directory exists and creates it if it doesn't. If the session is
#' non-interactive, an error is thrown instead of prompting the user. If the
#' directory already exists, the function silently ends.
#'
#' @param dir Character. The path of the directory to check/create.
#' @param print Logical. If `TRUE`, prints a message to the CLI about the
#'   creation status of the directory. Defaults to the global option `use.print`
#'   (which defaults to `TRUE`).
#'
#' @return Invisibly returns the relative path of the directory if it exists or
#'
#' @keywords internal
ensure_dir_exists <- function(dir, print = getOption("use.print", TRUE)) {
  dir_rel_path <- proj_rel_path(dir)
  if (fs::dir_exists(dir)) {
    return(invisible(dir))
  }
  if (!interactive()) {
    cli::cli_abort(
      "Directory {dir_rel_path} does not exist and session is non-interactive."
    )
  }
  ok <- usethis::ui_yeah(
    x = "Directory {dir_rel_path} does not exist. Create it?",
    yes = c("Yes"),
    no = c("No"),
    shuffle = FALSE
  )
  if (!isTRUE(ok)) {
    if (isTRUE(print))
      cli::cli_alert_warning("Aborted. Directory was not created.")
    return(invisible(NULL))
  }

  fs::dir_create(dir, recurse = TRUE)

  if (isTRUE(print)) {
    cli::cli_alert_success(
      "Created directory {dir_rel_path}."
    )
  }

  invisible(dir_rel_path)
}

check_dir_exists <- function(dir) {
  # If dir does not exist, create it and warn user
  if (!fs::dir_exists(dir)) {
    fs::dir_create(dir)
    cli::cli_alert_warning("Directory created at {.file {fs::path_rel(dir)}}")
  }
}

check_file_absent <- function(file_path, overwrite) {
  if (overwrite) {
    return()
  } else if (fs::file_exists(file_path)) {
    cli::cli_abort(
      c(
        "x" = "File {.file {file_path}} already exists.",
        "i" = "To overwrite the file, set {.code overwrite = TRUE}."
      )
    )
  }
}

# Check object names ------------------------------------------------------

check_name <- function(name) {
  if (!rlang::is_character(name)) {
    cli::cli_abort("{.arg name} must be a character string.")
  }
  if (!grepl("^[A-Za-z][A-Za-z0-9_]*$", name)) {
    cli::cli_abort(
      paste(
        "{.arg name} must start with a letter and contain only letters,",
        "numbers or underscores."
      )
    )
  }
  return(invisible(name))
}
