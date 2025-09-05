# Public functions to export figures and tables ----------------------------------

export_table <- function(x, name, format, overwrite = FALSE, quiet = FALSE) {
  # Check object class validity
  if (inherits(x, "gt_tbl")) {
    obj_class <- "gt"
  } else if (inherits(x, "flextable")) {
    obj_class <- "flextable"
  } else {
    cli::cli_abort(
      c(
        "x" = "Unsupported table class {.val {class(x)[1]}}.",
        "i" = "Supported classes are {.val gt} and {.val flextable}."
      )
    )
  }

  # Check details and get file path
  file_path <- check_export_details(
    name = name,
    type = "table",
    format = format,
    overwrite = overwrite,
    quiet = quiet
  )

  # Define export function based on class
  if (obj_class == "gt") {
    gt::gtsave(data = x, filename = file_path)
  } else if (obj_class == "flextable") {
    if (format == "docx") {
      flextable::save_as_docx(x, path = file_path)
    } else if (format == "html") {
      flextable::save_as_html(x, path = file_path)
    }
  }

  # Inform user
  if (!quiet) {
    cli::cli_alert_success("Exporting {.val table} to {.file {file_path}}.")
  }
}

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
