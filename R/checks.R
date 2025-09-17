# Check directories and files ----------------------------------------------------

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

# Check object names -------------------------------------------------------------

check_name <- function(name) {
  usethis:::check_character(name)
  usethis:::check_name(name)
  new_name <- gsub("[^a-zA-Z0-9_]+", "_", name)
  if (new_name != name) {
    cli::cli_warn(
      c(
        "!" = "The name {.val {name}} has been sanitized to {.val {new_name}}.",
        "i" = "Only alphanumeric characters and underscores are allowed. Change the name to remove this error."
      )
    )
  }
  return(new_name)
}
