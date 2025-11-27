# Check directories and files ---------------------------------------------

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
