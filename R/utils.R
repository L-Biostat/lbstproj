create_directory <- function(path, quiet = FALSE) {
  full_path <- fs::path(path)
  if (fs::dir_exists(full_path)) {
    return(invisible(FALSE))
  } else if (fs::file_exists(full_path)) {
    cli::cli_abort("{.path {(path)}} exists but is not a directory.")
  } else {
    fs::dir_create(full_path, recurse = TRUE)
    if (!quiet) {
      cli::cli_alert_success("Created directory {.path {(path)}}.")
    }
    return(invisible(TRUE))
  }
}
