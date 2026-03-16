# -------------------------------------------------------------------------
# ┌────────────┐
# │  lbstproj  │
# └────────────┘
#
# save.R:
# Save project outputs
# -------------------------------------------------------------------------

#' Save outputs in the project
#'
#' @description
#' These functions standardize how outputs are saved in an
#' `lbstproj` project:
#'   * `save_data()` saves a data frame as `rds` to `data/processed`.
#'   * `save_table()` saves a table as `rds` to `data/tables` and optionally export it
#'     as `docx` to `results/tables`.
#'   * `save_figure()` saves a figure as `png` (or another extension) to `results/figures`.
#'
#' To save another R object (e.g. a model, a `mice` object, ...) to file, you need to
#' use [base::saveRDS] and manually define the file path.
#'
#' Each function saves the object using the given name, after validating it. Names can
#' only contain letters, numbers, and hyphens.
#'
#' @param name *Character*. File name without extension.
#' @param overwrite *Logical*. If `TRUE`, overwrite an existing file with the same
#'   name. If `FALSE`, an error is thrown when the target file already exists.
#'
#'   *Default*: `TRUE`. Outputs are overwritten by default.
#' @param quiet Logical. If `TRUE`, suppress informational messages.
#'
#'   *Default*: `FALSE` unless the global option `lbstproj.quiet` is set otherwise. The default option can be changed using `options(lbstproj.quiet = TRUE)`
#' @param data A `data.frame` to save.
#' @param table A `gt_tbl` object to save.
#' @param export *Logical*. If `TRUE`, also export the table as a `.docx` file.
#'
#'   *Default*: `TRUE`. Word tables are always produced unless specified otherwise.
#' @param figure A `ggplot` object to save.
#' @param extension *Character*. Output format for figures: `"png"` or `"pdf"`.
#'
#'   *Default*: `"png"`
#' @param width,height *Numeric*. Width and height of the saved figure in inches.
#'
#'   *Default*: A width of 6 and a height of 4. This fits nicely on a portrait A4 page.
#' @param ... Additional arguments passed to the saving function:
#'
#'   * For `save_table()`: passed to [gt::gtsave]
#'   * For `save_figure()`: passed to [ggplot2::ggsave]
#'
#' @return Invisibly returns the path of the saved file.
#' @examples
#' if(FALSE) {
#'   save_data(mtcars, name = "analysis_dataset")
#'
#'   summary_table <- gt::gt(head(mtcars))
#'   save_table(summary_table, name = "baseline_characteristics")
#'
#'   scatter_plot <- ggplot2::ggplot(
#'     mtcars,
#'     ggplot2::aes(wt, mpg)
#'   ) +
#'     ggplot2::geom_point()
#'   save_figure(scatter_plot, name = "mpg_vs_weight")
#' }
#'
#' @name save_outputs
NULL

#' @rdname save_outputs
#' @export
save_data <- function(
  data,
  name,
  overwrite = TRUE,
  quiet = getOption("lbstproj.quiet", FALSE)
) {
  # Ensure `data` is a data.frame
  if (!inherits(data, "data.frame")) {
    cli::cli_abort(
      "{.arg data} must have class {.cls data.frame}, but has class {.cls {class(data)}}."
    )
  }
  # Validate the name
  name <- validate_file_name(name)
  # Ensures the data directory exists
  ensure_dir_exists("data/processed", create = TRUE)
  # Check if file exists and handle overwrite logic
  file_path <- fs::path("data", "processed", name, ext = "rds")
  check_can_overwrite(path = file_path, overwrite = overwrite, what = "File")
  # Save the data frame as an RDS file
  saveRDS(data, file = file_path)
  # Inform user
  data_name <- deparse(substitute(data))
  inform_saved(
    object_name = data_name,
    path = file_path,
    what = "Data frame",
    quiet = quiet
  )
  invisible(file_path)
}

#' @rdname save_outputs
#' @export
save_table <- function(
  table,
  name,
  export = TRUE,
  overwrite = TRUE,
  quiet = getOption("lbstproj.quiet", FALSE),
  ...
) {
  # Ensure "table" is a `gt` object
  if (!inherits(table, "gt_tbl")) {
    cli::cli_abort(
      "{.arg table} must have class {.cls gt_tbl}, but has class {.cls {class(table)}}."
    )
  }
  # Validate the name
  name <- validate_file_name(name)
  # Ensures the data directory exists
  ensure_dir_exists("data/tables", create = TRUE)
  # Check if file exists and handle overwrite logic
  file_path <- fs::path("data", "tables", name, ext = "rds")
  check_can_overwrite(path = file_path, overwrite = overwrite, what = "Table")
  # Save the table as an RDS file
  saveRDS(table, file = file_path)
  # Inform user
  table_name <- deparse(substitute(table))
  inform_saved(
    object_name = table_name,
    path = file_path,
    what = "Table",
    quiet = quiet
  )
  # If export is `TRUE`, save the table as docx too.
  if (isTRUE(export)) {
    # Ensures the results directory exists
    ensure_dir_exists("results/tables", create = TRUE)
    # Check if the file can be overwritten
    export_file_path <- fs::path("results", "tables", name, ext = "docx")
    check_can_overwrite(
      path = export_file_path,
      overwrite = overwrite,
      what = "Table"
    )
    # Export the table to docx
    gt::gtsave(table, filename = export_file_path)
    # Inform about the export
    inform_saved(
      object_name = table_name,
      path = export_file_path,
      what = "Table",
      quiet = quiet,
      export = TRUE
    )
  }
  invisible(file_path)
}

#' @rdname save_outputs
#' @export
save_figure <- function(
  figure,
  name,
  extension = "png",
  width = 6,
  height = 4,
  overwrite = TRUE,
  quiet = getOption("lbstproj.quiet", FALSE),
  ...
) {
  # Ensure "figure" is a `ggplot` object
  if (!inherits(figure, "ggplot")) {
    cli::cli_abort(
      "{.arg figure} must have class {.cls ggplot}, but has class {.cls {class(figure)}}."
    )
  }
  # Validate the name
  name <- validate_file_name(name)
  # Ensures the data directory exists
  ensure_dir_exists("results/figures", create = TRUE)
  # Ensure extension is one of "png" or "pdf"
  check_string(extension)
  if (isFALSE(extension %in% c("png", "pdf"))) {
    cli::cli_abort(
      "{.arg extension} must be either {.val png} or {.val pdf}, but is {.val {extension}}."
    )
  }
  # Check if file exists and handle overwrite logic
  file_path <- fs::path("results", "figures", name, ext = extension)
  check_can_overwrite(path = file_path, overwrite = overwrite, what = "Figure")
  # Save the data frame as an RDS file
  ggplot2::ggsave(
    filename = file_path,
    plot = figure,
    device = extension,
    width = width,
    height = height,
    ...
  )
  # Inform user
  figure_name <- deparse(substitute(figure))
  inform_saved(
    object_name = figure_name,
    path = file_path,
    what = "Figure",
    quiet = quiet
  )
  invisible(file_path)
}

inform_saved <- function(object_name, path, what, quiet, export = FALSE) {
  if (quiet) {
    return(invisible(path))
  }
  verb <- ifelse(isTRUE(export), "exported", "saved")
  cli::cli_alert_success(
    "{what} {.val {object_name}} {verb} to {.file {path}}."
  )
  invisible(path)
}
