#' Create a report from the TOT
#'
#' @description
#' Create a report by combining a report template with all figures and tables
#' listed in the table of tables (TOT), in the order they appear.
#'
#' Captions and labels are taken from the TOT, so updates to the TOT are
#' reflected automatically in the generated report.
#'
#' For **gt** projects the report is a Quarto (`.qmd`) file. For **flextable**
#' projects the report is an R Markdown (`.Rmd`) file configured for
#' `officedown::rdocx_document`.
#'
#' Generated report files are date-stamped, for example
#' `report/report_2026_03_16.qmd` (gt) or `report/report_2026_03_16.Rmd`
#' (flextable).
#'
#' @param output_type *Character*. Output format of the report template for
#'   **gt** projects. Must be one of `"html"` or `"docx"`. Ignored for
#'   flextable projects, which always produce a Word document.
#'
#'   *Default*: `"html"`.
#' @param overwrite *Logical*. If `TRUE`, overwrite an existing report file with
#'   the same dated name. If `FALSE`, raise an error instead.
#'
#'   *Default*: `FALSE`.
#' @param quiet *Logical*. If `TRUE`, suppress informational messages. Important
#'   messages (e.g. directory creation or errors) are still shown.
#'
#'   *Default*: `FALSE` unless the global option `lbstproj.quiet` is set
#'   otherwise.
#' @return Invisibly returns the path to the generated report file.
#' @examples
#' if(FALSE) {
#'   create_report()
#'   create_report(output_type = "docx", overwrite = TRUE)
#' }
#' @export
create_report <- function(
  output_type = "docx",
  overwrite = FALSE,
  quiet = getOption("lbstproj.quiet", FALSE)
) {
  output_type <- rlang::arg_match(output_type, c("html", "docx"))
  ensure_dir_exists("report", create = TRUE)

  if (is_flextable_project()) {
    report_path <- report_file_path(extension = "Rmd")
    check_can_overwrite(report_path, overwrite, what = "Report file")
    template_path <- fs::path_package(
      "templates", "flextable_report.Rmd",
      package = "lbstproj"
    )
  } else {
    report_path <- report_file_path(extension = "qmd")
    check_can_overwrite(report_path, overwrite, what = "Report file")
    template_path <- fs::path_package(
      "templates",
      paste0(output_type, "_report.qmd"),
      package = "lbstproj"
    )
  }

  template <- readLines(template_path)
  template_data <- list(
    title = desc::desc_get("Title"),
    author = get_author(),
    client = desc::desc_get("Client"),
    department = desc::desc_get("Department"),
    date = format(Sys.Date(), "%d %B %Y"),
    table_engine = get_table_engine()
  )
  report_basis <- whisker::whisker.render(template, template_data)

  tot <- load_tot()
  chunks <- purrr::map_chr(
    .x = tot$id,
    .f = ~ create_chunk(
      output_type = output_type,
      id = .x,
      print = FALSE,
      pad = TRUE,
      quiet = TRUE
    )
  )
  report <- c(report_basis, chunks)
  writeLines(report, con = report_path)

  if (!quiet) {
    cli::cli_bullets(
      c(
        "v" = "Writing report to {.file {report_path}}.",
        "i" = "Use {.fn run_report} to render the report."
      )
    )
  }
  invisible(report_path)
}
