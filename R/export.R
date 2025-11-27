#' Export a figure to `results/figures/`
#'
#' @description
#' Save a publication-ready figure to `results/figures/<name>.<ext>` using
#' [ggplot2::ggsave()]. The parent directory is created if needed and an
#' existing file is not overwritten unless `overwrite = TRUE`.
#'
#' @param fig A [ggplot2::ggplot] object.
#' @param name Name used to save the figure (without file extension).
#' @param ext Output format/extension. One of `"png"`, `"pdf"`, `"jpeg"`,
#'   `"tiff"`, `"bmp"`, `"svg"`. Defaults to `"png"`. (Raster:
#'   png/jpeg/tiff/bmp; Vector: pdf/svg.)
#' @param width,height Plot dimensions passed to [ggplot2::ggsave()] (in inches
#'   by default; you can pass `units = "cm"` or `units = "mm"` via `...`).
#' @inheritParams create_scripts
#' @param print Whether to print (default: `TRUE`) a success message to the
#'   console. You can set a default print behavior for all functions in this
#'   family by setting the global option `export.print` to `TRUE` or `FALSE`.
#' @param ... Additional arguments forwarded to [ggplot2::ggsave()]
#'   (e.g., `dpi`, `units`, `bg`, `device`).
#'
#' @details
#' The function is called for its side effects and does not return a value.
#'
#' @examples
#' \dontrun{
#' library(ggplot2)
#' p <- ggplot(mtcars, aes(mpg, wt)) + geom_point()
#' export_figure(p, name = "scatter_mpg_wt", ext = "pdf", width = 7, height = 5)
#' export_figure(p, name = "scatter_png", dpi = 300)  # defaults to PNG
#' }
#'
#' @seealso [ggplot2::ggsave()]
#' @md
#' @export
export_figure <- function(
  fig,
  name,
  ext = "png",
  print = NULL,
  width = 8,
  height = 6,
  overwrite = TRUE,
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
  # Define printing behavior
  if (is.null(print)) {
    print <- getOption("export.print", TRUE)
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
  if (print) {
    cli::cli_alert_success("Figure saved to {.file {file_path}}")
  }
}

#' Export a table to `results/tables/`
#'
#' @description Save a formatted table to `results/tables/<name>.<ext>`.
#' Supports `gt` tables via [gt::gtsave()] and `flextable` via the corresponding
#' `save_as_*()` helpers. The parent directory is created if needed and an
#' existing file is not overwritten unless `overwrite = TRUE`.
#'
#' @param tbl A [gt::gt()] table (`gt_tbl`) or a [flextable::flextable()]
#'   object.
#' @param name Name used to save the table (without file extension).
#' @param ext Output format/extension. One of `"docx"`, `"pdf"`, `"html"`,
#'   `"rtf"`.
#' @inheritParams create_scripts
#' @param print Whether to print (default: `TRUE`) a success message to the
#'   console. You can set a default print behavior for all functions in this
#'   family by setting the global option `export.print` to `TRUE` or `FALSE`.
#' @param landscape Logical; for `flextable` exports only, set page orientation
#'   to landscape. Ignored for `gt` tables.
#' @param ... Additional arguments forwarded to [gt::gtsave()] (for `gt`) or the
#'   relevant `flextable::save_as_*()` function (for `flextable`).
#'
#' @details The function is called for its side effects and does not return a
#' value.
#'
#' @examples
#' \dontrun{
#' library(gt)
#' gt_tbl <- head(mtcars) |> gt()
#' export_table(gt_tbl, name = "mtcars_head", ext = "html")
#'
#' library(flextable)
#' ft <- flextable(head(iris))
#' export_table(ft, name = "iris_doc", ext = "docx", landscape = TRUE)
#' }
#'
#' @seealso [gt::gtsave()], [flextable::save_as_docx()],
#'   [flextable::save_as_html()], [flextable::save_as_rtf()]
#' @md
#' @export
export_table <- function(
  tbl,
  name,
  ext,
  print = NULL,
  overwrite = TRUE,
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
  if (inherits(tbl, "flextable") && ext == "pdf") {
    cli::cli_abort(
      paste(
        "{.cls flextable} objects can only be saved as",
        "{.val {setdiff(valid_ext, \"pdf\")}}"
      )
    )
  }
  # Define printing behavior
  if (is.null(print)) {
    print <- getOption("export.print", TRUE)
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
        paste(
          "Landscape mode is not supported for gt tables.",
          "Ignoring {.arg landscape} argument."
        )
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
  if (print) {
    cli::cli_alert_success("Table saved to {.file {file_path}}")
  }
}
