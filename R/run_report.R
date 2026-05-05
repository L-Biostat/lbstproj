# -------------------------------------------------------------------------
# ┌------------┐
#   lbstproj
# \------------┘
#
# run_report.R:
# Render a quarto report
# -------------------------------------------------------------------------

#' Render a report
#'
#' @description
#' Renders a report file located in the `report/` directory. The rendered
#' output is saved in the same `report/` directory under the same name (with a
#' different extension).
#'
#' If `file` is not supplied, the most recently modified report file (`.qmd` or
#' `.Rmd`) in `report/` is rendered.
#'
#' - **gt projects** produce a Quarto (`.qmd`) report rendered via
#'   [quarto::quarto_render()].
#' - **flextable projects** produce an R Markdown (`.Rmd`) report rendered via
#'   [rmarkdown::render()].
#'
#' @param file *Character* or `NULL`. The name of the report file to render. If
#'   `NULL`, the most recently modified `.qmd` or `.Rmd` report in `report/`
#'   is used.
#' @param quiet *Logical*. If `TRUE`, suppress informational messages. Important
#'   messages (e.g. directory creation or errors) are still shown.
#'
#'   *Default*: `FALSE` unless the global option `lbstproj.quiet` is set
#'   otherwise.
#' @param ... Additional arguments passed to the rendering function
#'   ([quarto::quarto_render()] for `.qmd` files, [rmarkdown::render()] for
#'   `.Rmd` files).
#'
#' @return Invisibly returns the path to the report file.
#' @examples
#' \dontrun{
#'   with_example_project({
#'     create_report(quiet = TRUE)
#'     run_report()
#'   }, with_tot = TRUE)
#' }
#' @export
run_report <- function(
  file = NULL,
  quiet = getOption("lbstproj.quiet", FALSE),
  ...
) {
  file_path <- resolve_report_file(
    file = file,
    extensions = c("qmd", "Rmd"),
    action = "run"
  )
  ext <- fs::path_ext(file_path)
  if (ext == "qmd") {
    quarto::quarto_render(input = file_path, ...)
  } else if (ext == "Rmd") {
    rmarkdown::render(input = file_path, ...)
  } else {
    cli::cli_abort(
      c(
        "x" = "Unsupported file extension {.val {ext}} for report file.",
        "i" = "Please provide a {.val .qmd} or {.val .Rmd} file."
      )
    )
  }
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
