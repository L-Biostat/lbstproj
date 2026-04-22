# -------------------------------------------------------------------------
# ┌------------┐
#   lbstproj
# \------------┘
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
#'   * `save_table()` saves a table as `rds` to `data/tables` and optionally
#'     exports it as `docx` to `results/tables`. The accepted table class and
#'     the export method depend on the project's table engine (`"gt"` or
#'     `"flextable"`), stored in the `TableEngine` field of the project
#'     `DESCRIPTION` file. Legacy projects without that field default to `"gt"`.
#'   * `save_figure()` saves a figure as `png` (or another extension) to `results/figures`.
#'
#' To save another R object (e.g. a model, a `mice` object, ...) to file, use
#' [base::saveRDS]. By convention, save it to `data/<subdir>/` where `<subdir>`
#' matches the subdirectory in `R/` where the script lives. For example, a model
#' created in `R/models/` should be saved to `data/models/`. When using
#' [create_file()] with a custom type, the matching `data/<subdir>/` directory
#' is created automatically.
#'
#' Each function saves the object using the given name, after validating it.
#' Figure and table names can only contain letters, numbers, and hyphens.
#' Data names may also contain underscores.
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
#' @param table A table object to save. Must be a `gt_tbl` for `gt` projects or
#'   a `flextable` for `flextable` projects.
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
#'   * For `save_table()`: passed to [gt::gtsave()] (gt projects) or
#'     [flextable::save_as_docx()] (flextable projects)
#'   * For `save_figure()`: passed to [ggplot2::ggsave]
#'
#' @return Invisibly returns the path of the saved file.
#' @examples
#' if(FALSE) {
#'   save_data(mtcars, name = "analysis_dataset")
#'
#'   # gt project (default)
#'   summary_table <- gt::gt(head(mtcars))
#'   save_table(summary_table, name = "baseline_characteristics")
#'
#'   # flextable project
#'   ft <- flextable::flextable(head(mtcars))
#'   save_table(ft, name = "baseline_characteristics")
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
  # Validate table class against the project engine
  check_table_object(table)
  # Validate the name
  name <- validate_file_name(name, strict = TRUE)
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
    # Export the table to docx using the engine-appropriate method
    export_table_docx(table, path = export_file_path, ...)
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
  name <- validate_file_name(name, strict = TRUE)
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

# Dispatch docx export to the engine-appropriate function.
#
# Uses `gt::gtsave()` for `gt` projects and `flextable::save_as_docx()` for
# `flextable` projects. `...` is forwarded to the underlying export function.
#
# @param table A table object (`gt_tbl` or `flextable`).
# @param path *Character*. Output file path (must end in `.docx`).
# @param ... Additional arguments forwarded to the underlying export function.
#
# @return Invisibly returns `path`.
#
# @keywords internal
export_table_docx <- function(table, path, ...) {
  if (is_gt_project()) {
    gt::gtsave(table, filename = path, ...)
  } else {
    flextable::save_as_docx(table, path = path, ...)
  }
  invisible(path)
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
