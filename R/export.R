# TODO: document functions
export_table <- function(
  x,
  name,
  format,
  overwrite = FALSE,
  quiet = FALSE,
  ...
) {
  # Check object class validity
  check_tbl_class(x)

  # Check format validity
  check_format(format = format, type = "table")

  # Check name validity
  sane_name <- check_name(name)

  # Check that files doesn't already exist and create directory if needed
  check_dir_present(dir = "results/tables", quiet = quiet)
  file_path <- fs::path("results", "tables", sane_name, ext = format)
  check_files_absent(paths = file_path, overwrite = overwrite)

  # Export based on class and format
  if (inherits(x, "gt_tbl")) {
    gt::gtsave(data = x, filename = file_path, ...)
  } else if (inherits(x, "gt_tbl")) {
    if (format == "docx") {
      flextable::save_as_docx(x, path = file_path, ...)
    } else if (format == "html") {
      flextable::save_as_html(x, path = file_path, ...)
    }
  }

  # Inform user
  cli_export_msg(type = "table", file_path = file_path, quiet = quiet)
}

export_figure <- function(
  x,
  name,
  format,
  overwrite = FALSE,
  quiet = FALSE,
  ...
) {
  # Check object class validity
  check_fig_class(x)

  # Check format validity
  check_format(format = format, type = "figure")

  # Check name validity
  sane_name <- check_name(name)

  # Check that files doesn't already exist and create directory if needed
  check_dir_present(dir = "results/figures", quiet = quiet)
  file_path <- fs::path("results", "figures", sane_name, ext = format)
  check_files_absent(paths = file_path, overwrite = overwrite)

  # Export based on class and format
  if (inherits(x, "ggplot")) {
    ggplot2::ggsave(filename = file_path, plot = x, device = format, ...)
  } # other cases are checked above

  # Inform user
  cli_export_msg(type = "figure", file_path = file_path, quiet = quiet)
}
