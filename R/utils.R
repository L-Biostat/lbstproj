# Custom cli messages ------------------------------------------------------------

cli_export_msg <- function(type, file_path, quiet) {
  # Ensure path is relative
  file_path <- fs::path_rel(file_path)
  if (!quiet) {
    cli::cli_alert_success("Exporting {.val {type}} to {.file {file_path}}.")
  }
}

cli_save_msg <- function(type, file_path, quiet) {
  # Ensure path is relative
  file_path <- fs::path_rel(file_path)
  if (!quiet) {
    cli::cli_alert_success("Saving {.val {type}} to {.file {file_path}}.")
  }
}
