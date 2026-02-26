# -------------------------------------------------------------------------
# ┌────────────┐
# │  lbstproj  │
# └────────────┘
#
# checks.R:
# Quick checks for types or values
# -------------------------------------------------------------------------

check_string <- function(x) {
  arg <- deparse(substitute(x))
  if (!rlang::is_string(x)) {
    cli::cli_abort("{.arg {arg}} must be a single character string.")
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
