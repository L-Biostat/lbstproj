# -------------------------------------------------------------------------
# ┌────────────┐
# │  lbstproj  │
# └────────────┘
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
#' All report files are render to a file with the same name. If such a file
#' already exists, it will be overwritten without warning. If you want to keep a
#' copy of the rendered report, use the [archive_report()] function after
#' rendering to move it to the `results/reports/` directory with a unique name.
#'
#' @param file *Character*. The name of the report file to render. If this file isn't found, the
#'   function throws an error.
#'
#'   *Default*: `"report.qmd"`, the default name produced by [create_report()]
#' @param quiet *Logical*. If `TRUE`, suppress informational messages. Important
#'   messages (e.g. directory creation or errors) are still shown.
#'
#'   *Default*: `FALSE` unless the global option `lbstproj.quiet` is set otherwise.
#' @param ... Additional arguments passed to the rendering function, in this case,
#'  [quarto::quarto_render()].
#'
#' @export
#' @examples
#' \dontrun{
#' # Default usage
#' run_report()
#' # Rendering a specific file to a specific name
#' run_report(file = "new_report.qmd", output_file = "final_report_FINAL_v3.0")
#' }
run_report <- function(
  file = "report.qmd",
  quiet = getOption("lbstproj.quiet", FALSE),
  ...
) {
  # Check that the file exists, and throw error if not
  file_path <- usethis::proj_path("report", file)
  rel_path <- fs::path_rel(file_path, start = usethis::proj_get())
  if (!fs::file_exists(file_path)) {
    cli::cli_abort(
      c(
        "x" = "Report file {.path {rel_path}} does not exist.",
        "i" = "Please provide a valid report file to run."
      )
    )
  }
  # Depending on the file type, use different rendering functions
  if (fs::path_ext(file_path) == "qmd") {
    quarto::quarto_render(
      input = rel_path,
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
  # Inform the user
  if (isFALSE(quiet)) {
    report_rel_path <- proj_rel(file_path) |>
      fs::path_ext_set("html")
    cli::cli_alert_success("Report rendered at {.path {report_rel_path}}")
    cli::cli_alert_info(
      "Use {.fn archive_report} to archive the rendered report in {.path results/reports/}"
    )
  }
}
