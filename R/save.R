#' 
save_data <- function(
  x,
  overwrite = FALSE,
  compress = "xz",
  version = 3,
  quiet = FALSE
) {
  # Check that given object is a data frame
  if (!inherits(x, "tbl_df") & !inherits(x, "data.frame")) {
    cli::cli_abort("{.arg data} must be a data frame or tibble.")
  }
  # Derive the name of the object
  name <- deparse(substitute(x))
  usethis:::check_name(name)
  # Create file path
  file_path <- fs::path("data/processed", sanitize_name(name), ext = "rds")
  # Create directory if it doesn't exist
  f <- function() {
    usethis::use_directory(paste0("data/processed"), ignore = FALSE)
  }
  # Run it silently if quiet is TRUE
  if (!quiet) {
    f()
  } else {
    usethis::ui_silence(f())
  }
  # Check if file already exists
  usethis:::check_files_absent(file_path, overwrite = overwrite)
  # Save the data
  saveRDS(x, file = file_path, compress = compress, version = version)
  # Inform the user
  if (!quiet) {
    cli::cli_alert_success("Saving {.val {name}} to {.path {file_path}}.")
  }
}

save_table <- function(
  x,
  name = deparse(substitute(x)),
  overwrite = FALSE,
  export = NULL,
  quiet = FALSE
) {
  # Check that given object is either a gt table of a flextable
  if (!inherits(x, "gt_tbl") & !inherits(x, "flextable")) {
    cli::cli_abort(
      "{.arg x} must be a {.cls gt_tbl} or {.cls flextable} object."
    )
  }
  # If export is not NULL, it must be 'docx' or 'html'
  authorized_export_formats <- c("docx", "html")
  if (!is.null(export)) {
    if (!export %in% authorized_export_formats) {
      cli::cli_abort(
        c(
          "x" = "Unknown export format {.val {export}}.",
          "i" = "Supported formats are {.val {authorized_export_formats}}."
        )
      )
    }
  }
  # Check the name validity
  usethis:::check_name(name)
  # Create file path and export path if needed
  data_path <- fs::path("data/tables", sanitize_name(name), ext = "rds")
  if (!is.null(export)) {
    export_path <- fs::path(
      "output/tables",
      paste0(sanitize_name(name)),
      ext = export
    )
  }
  # Create directory if it doesn't exist
  f <- function() {
    usethis::use_directory(paste0("data/tables"), ignore = FALSE)
    if (!is.null(export)) {
      usethis::use_directory(paste0("output/tables"), ignore = FALSE)
    }
  }
  # Run it silently if quiet is TRUE
  if (!quiet) {
    f()
  } else {
    usethis::ui_silence(f())
  }
  # Check if file already exists
  usethis:::check_files_absent(data_path, overwrite = overwrite)
  if (!is.null(export)) {
    usethis:::check_files_absent(export_path, overwrite = overwrite)
  }
  # Save the table object
  saveRDS(x, file = data_path, compress = "xz", version = 3)
  # Export if needed
  if (!is.null(export)) {
    if (inherits(x, "gt_tbl")) {
      gt::gtsave(x, filename = export_path)
    } else if (inherits(x, "flextable")) {
      if (export == "docx") {
        flextable::save_as_docx(x, path = export_path)
      } else if (export == "html") {
        flextable::save_as_html(x, path = export_path)
      }
    }
  }
  # Inform the user
  if (!quiet) {
    cli::cli_alert_success("Saving table {.val {name}} to {.path {data_path}}.")
    if (!is.null(export)) {
      cli::cli_alert_success(
        "Exporting table {.val {name}} as {.val {export}} to {.path {export_path}}."
      )
    }
  }
}

save_figure <- function(
  x,
  name = deparse(substitute(x)),
  overwrite = FALSE,
  export = NULL,
  quiet = FALSE
)