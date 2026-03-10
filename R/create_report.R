#' Create a Quarto report from the TOT
#'
#' @description
#' Create a Quarto report by combining a report template with all
#' figures and tables listed in the table of tables (TOT), in the order they appear.
#'
#' Captions and labels are taken from the TOT, so updates to the TOT are reflected
#' automatically in the generated report.
#'
#' The report is written to `report/report.qmd`.
#'
#' @param output_type *Character*. Output format of the report template.
#'   Must be one of `"html"` or `"docx"`.
#'
#'   *Default*: `"html"`.
#' @param quiet *Logical*. If `TRUE`, suppress informational messages. Important
#'   messages (e.g. directory creation or errors) are still shown.
#'
#'   *Default*: `FALSE` unless the global option `lbstproj.quiet` is set otherwise.
#' @return Invisibly returns the path to the generated report file.
#' @export
create_report <- function(
  output_type = "html",
  quiet = getOption("lbstproj.quiet", FALSE)
) {
  output_type <- rlang::arg_match(output_type, c("html", "docx"))
  # Load the report template
  template_path <- fs::path_package(
    "templates",
    paste0(output_type, "_report.qmd"),
    package = "lbstproj"
  )
  template <- readLines(template_path)
  # Generate template data from the DESCRIPTION file
  template_data <- list(
    title = desc::desc_get("Title"),
    author = get_author(),
    client = desc::desc_get("Client"),
    department = desc::desc_get("Department"),
    date = format(Sys.Date(), "%d %B %Y")
  )
  # Render the template with the data
  report_basis <- whisker::whisker.render(template, template_data)
  # Load the table of tables (TOT)
  tot <- load_tot()
  # Create chunks for all figures and tables in the TOT
  chunks <- purrr::map_chr(
    .x = tot$id,
    .f = ~ create_chunk(
      output_type = output_type,
      id = .x,
      print = FALSE,
      pad = TRUE
    )
  )
  # Combine the report basis and the chunks
  report <- c(report_basis, chunks)
  # Write the report to a file
  ensure_dir_exists("report", create = TRUE)
  report_path <- fs::path("report", paste0(output_type, "_report"), ext = "qmd")
  writeLines(report, con = report_path)
  # Inform the user if needed
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
