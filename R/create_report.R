#' Create a quarto report based on the table of tables (TOT)
#'
#' Creates a quarto report by using a html-report template and including all
#' elements found in the TOT in the order they appear. All captions and labels
#' are taken from the TOT, so any changes to those will be reflected in the
#' report when it is rendered.
#'
#' The report is created in `report/report.qmd`. If a report already exists, it
#' will be overwritten.
#'
#' @export
create_report <- function() {
  # Load the report template
  template <- readLines(
    con = fs::path_package(
      fs::path("templates", "report", ext = "qmd"),
      package = "lbstproj"
    )
  )
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
  chunks <- purrr::map(
    .x = tot$id,
    .f = ~ create_chunk(
      id = .x,
      type = .y,
      print = FALSE,
      pad = TRUE,
      copy = FALSE
    )
  ) |>
    unlist()
  # Combine the report basis and the chunks
  report <- c(report_basis, chunks)
  # Write the report to a file
  check_dir_exists("report")
  fs::file_create("report/report.qmd")
  writeLines(report, con = "report/report.qmd")
  cli::cli_bullets(
    c(
      "v" = "Writing report at {.path report/report.qmd}.",
      "i" = "Use {.fn run_report} to render the report."
    )
  )
}
