# Public functions to export figures and tables ----------------------------------

# Helper functions to export objects ---------------------------------------------

check_export_details <- function(
  name,
  type,
  format,
  overwrite = FALSE,
  quiet = FALSE
) {
  # Check the type validity
  valid_types <- c("figure", "table")
  if (!type %in% valid_types) {
    cli::cli_abort(
      c(
        "x" = "Unknown type {.val {type}}.",
        "i" = "Supported types are {.val {valid_types}}."
      )
    )
  }
  # Check the format validity based on the type
  valid_formats <- switch(
    type,
    figure = c("png", "jpeg", "tiff", "bmp", "svg", "pdf"),
    table = c("docx", "html")
  )
  if (!format %in% valid_formats) {
    cli::cli_abort(
      c(
        "x" = "Unknown format {.val {format}} for type {.val {type}}.",
        "i" = "Supported formats are {.val {valid_formats}}."
      )
    )
  }
  # Check the name validity
  usethis:::check_name(name)

  # Ensure output directory exists
  out_dir <- fs::path("results", paste0(type, "s"))
  create_directory(out_dir, quiet = quiet)

  # Create the file path
  file_path <- fs::path(out_dir, .sanitize_name(name), ext = format)
  # Check if file already exists
  usethis:::check_files_absent(file_path, overwrite = overwrite)
  return(file_path)
}
