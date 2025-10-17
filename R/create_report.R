#'  Create a Rmd report based on the table of tables (TOT)
#'
#' @export
create_report <- function(overwrite = TRUE) {
  # Check if the report file already exists
  check_file_absent("report/report.Rmd", overwrite = overwrite)
  # Load the report template
  template <- readLines(
    con = fs::path_package(
      fs::path("templates", "report", ext = "Rmd"),
      package = "lbstproj"
    )
  )
  # Generate template data from the DESCRIPTION file
  desc <- desc::desc(file = "DESCRIPTION")
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
  chunks <- purrr::map2(
    .x = tot$id,
    .y = tot$type,
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
  fs::file_create("report/report.Rmd")
  writeLines(report, con = "report/report.Rmd")
  cli::cli_bullets(
    c(
      "v" = "Writing report at {.path report/report.Rmd}.",
      "i" = "Use {.fn run_report} to render the report."
    )
  )
}
