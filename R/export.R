export_figure <- function(
  fig,
  name,
  ext = "png",
  width = 8,
  height = 6,
  overwrite = FALSE,
  ...
) {
  # Check fig is a ggplot object
  if (!inherits(fig, "ggplot")) {
    cli::cli_abort("{.arg fig} must be a {.cls ggplot} object")
  }
  # Check extension is valid
  valid_ext <- c("png", "pdf", "jpeg", "tiff", "bmp", "svg")
  if (!(ext %in% valid_ext)) {
    cli::cli_abort("{.arg ext} must be one of {.val {valid_ext}}")
  }
  # Create file path
  file_path <- fs::path("results", "figures", name, ext = ext)
  # Check if file already exists
  check_file_absent(file_path, overwrite = overwrite)
  # Ensure the parent directory exists, create if not
  check_dir_exists(fs::path_dir(file_path))
  # Save the figure
  ggplot2::ggsave(
    filename = file_path,
    plot = fig,
    width = width,
    height = height,
    ...
  )
  # Inform user
  cli::cli_alert_success("Figure saved to {.file {file_path}}")
}

export_table <- function(
  tbl,
  name,
  ext,
  overwrite = FALSE,
  landscape = FALSE,
  ...
) {
  # Check tbl is a gt table or a flextable object
  if (!(inherits(tbl, "gt_tbl") || inherits(tbl, "flextable"))) {
    cli::cli_abort(
      "{.arg tbl} must be a {.cls gt_tbl} or {.cls flextable} object"
    )
  }
  # Check extension is valid
  valid_ext <- c("docx", "pdf", "html", "rtf")
  if (!(ext %in% valid_ext)) {
    cli::cli_abort("{.arg ext} must be one of {.val {valid_ext}}")
  }
  # Create file path
  file_path <- fs::path("results", "tables", name, ext = ext)
  # Check if file already exists
  check_file_absent(file_path, overwrite = overwrite)
  # Ensure the parent directory exists, create if not
  check_dir_exists(fs::path_dir(file_path))
  # Save the table based on the extension and class
  if (inherits(tbl, "gt_tbl")) {
    if (landscape) {
      cli::cli_alert_warning(
        "Landscape mode is not supported for gt tables. Ignoring {.arg landscape} argument."
      )
    }
    gt::gtsave(data = tbl, filename = file_path, ...)
  } else if (inherits(tbl, "flextable")) {
    # Define page orientation if landscape is TRUE
    if (landscape) {
      pr <- officer::prop_section(
        page_size = officer::page_size(orient = "landscape"),
        type = "continuous"
      )
    } else {
      pr <- NULL
    }
    # Save based on extension
    switch(
      ext,
      docx = flextable::save_as_docx(
        tbl,
        path = file_path,
        pr_section = pr,
        ...
      ),
      pdf = flextable::save_as_pdf(tbl, path = file_path, pr_section = pr, ...),
      html = flextable::save_as_html(
        tbl,
        path = file_path,
        pr_section = pr,
        ...
      ),
      rtf = flextable::save_as_rtf(tbl, path = file_path, pr_section = pr, ...)
    )
  }
  # Inform user
  cli::cli_alert_success("Table saved to {.file {file_path}}")
}
