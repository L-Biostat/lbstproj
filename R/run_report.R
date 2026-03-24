# -------------------------------------------------------------------------
# ┌------------┐
#   lbstproj
# \------------┘
#
# run_report.R:
# Render a quarto report
# -------------------------------------------------------------------------

#' Render a quarto report
#'
#' @description
#' Renders a quarto (`.qmd`) report file located in the `report/` directory. The
#' rendered output is saved in the same `report/` directory under the same name (with a
#' different extension).
#'
#' If `file` is not supplied, the most recently modified report file in
#' `report/` is rendered. Rendered outputs keep the same date-stamped stem as
#' the input `.qmd` file.
#'
#' @param file *Character* or `NULL`. The name of the report file to render. If
#'   `NULL`, the most recently modified `.qmd` report in `report/` is used.
#' @param quiet *Logical*. If `TRUE`, suppress informational messages. Important
#'   messages (e.g. directory creation or errors) are still shown.
#'
#'   *Default*: `FALSE` unless the global option `lbstproj.quiet` is set otherwise.
#' @param ... Additional arguments passed to the rendering function, in this case,
#'  [quarto::quarto_render()].
#'
#' @return Invisibly returns the path to the report file.
#' @examples
#' if(FALSE) {
#'   run_report()
#'   run_report(file = "html_report_2026_03_16.qmd")
#'   run_report(file = "new_report.qmd", output_file = "final_report_FINAL_v3.0")
#' }
#' @export
run_report <- function(
  file = NULL,
  quiet = getOption("lbstproj.quiet", FALSE),
  ...
) {
  # Find the corresponding qmd report file
  file_path <- resolve_report_file(
    file = file,
    extensions = "qmd",
    action = "run"
  )
  # Ensure the report is a quarto file and then renders it
  ext <- fs::path_ext(file_path)
  if (ext == "qmd") {
    quarto::quarto_render(
      input = file_path,
      ...
    )
  } else {
    cli::cli_abort(
      c(
        "x" = "Unsupported file extension {.val {ext}} for report file.",
        "i" = "Please provide a .qmd file."
      )
    )
  }
  # Extract the report name
  report_name <- paste0(fs::path_ext_remove(file_path), ".docx/.html")
  if (isFALSE(quiet)) {
    cli::cli_alert_success(
      "Report rendered at {.path {report_name}}"
    )
    cli::cli_alert_info(
      "Use {.fn archive_report} to archive the rendered report in {.path results/reports/}"
    )
  }
  invisible(file_path)
}
