#' Render a Rmd/qmd report
#'
#' Renders a report file located in the `report/` directory. The report can be
#' either an R Markdown (`.Rmd`) or Quarto (`.qmd`) file. The rendered output
#' is saved in the same `report/` directory under the same name (with a
#' different extension).
#'
#' @param file The name of the report file to render. Default is `"report.qmd"`.
#'   If this file isn't found, the function looks for a file with the same name
#'   but with a `.Rmd` extension before throwing an error.
#' @param ... Additional arguments passed to the rendering function. For R
#'   Markdown files, these are passed to [rmarkdown::render()]. For Quarto
#'   files, these are passed to [quarto::quarto_render()].
#'
#' @details
#' All report files are render to a file with the same name. If such a file
#' already exists, it will be overwritten without warning. If you want to keep a
#' copy of the rendered report, use the [archive_report()] function after
#' rendering to move it to the `results/reports/` directory with a unique name.
#'
#'
#' @export
#' @examples
#' \dontrun{
#' # Default usage
#' run_report()
#' # Rendering a specific R Markdown file to pdf
#' run_report(file = "pdf_report.Rmd", output_format = "pdf_document")
#' }
run_report <- function(file = "report.qmd", ...) {
  # Check that the file exists
  file_path <- usethis::proj_path("report", file)
  if (!fs::file_exists(file_path)) {
    rel_path <- fs::path_rel(file_path, usethis::proj_get())

    # If non-existing check for ".Rmd" extension as alternative
    alt_file_path <- fs::path_ext_set(file_path, "Rmd")
    rel_alt_path <- fs::path_rel(alt_file_path, usethis::proj_get())
    if (fs::file_exists(alt_file_path)) {
      cli::cli_alert_danger("Report file {.path {rel_path}} not found.")
      file_path <- alt_file_path
      cli::cli_alert_info(
        "Using existing report file {.path {rel_alt_path}} instead."
      )
    } else {
      # If still non-existing, abort
      cli::cli_abort(
        c(
          "x" = "Report file {.path {rel_path}} does not exist.",
          "i" = "Please provide a valid report file to run."
        )
      )
    }
  }
  # Depending on the file type, use different rendering functions
  ext <- fs::path_ext(file_path)
  rel_path <- proj_rel(file_path)
  if (ext %in% c("rmd", "Rmd")) {
    rmarkdown::render(
      input = rel_path,
      ...
    )
  } else if (ext %in% c("qmd", "Qmd")) {
    quarto::quarto_render(
      input = rel_path,
      ...
    )
  } else {
    cli::cli_abort(
      c(
        "x" = "Unsupported file extension {.val {ext}} for report file.",
        "i" = "Please provide a .Rmd or .qmd file."
      )
    )
  }
  # Inform the user
  report_rel_path <- proj_rel(file_path) |>
    fs::path_ext_set("html")
  cli::cli_alert_success("Report rendered at {.path {report_rel_path}}")
  cli::cli_alert_info(
    "Use {.fn archive_report} to archive the rendered report in {.path results/reports/}"
  )
}


#' Archive a rendered report
#'
#' Moves a rendered report from the `report/` directory to the
#' `results/reports/` directory and renames it to include the current date and
#' project version. This function is typically used after rendering a report
#' with [run_report()], to save a copy of the rendered output.
#'
#' @param file The name of the report file to archive. Default is `"report.html"`.
#' @param overwrite Logical indicating whether to overwrite an existing archive file.
#' Defaults to `FALSE`, so an error is raised if the archive file already exists.
#'
#' @export
archive_report <- function(file = "report.html", overwrite = FALSE) {
  # Check that the file exists
  file_path <- usethis::proj_path("report", file)
  if (!fs::file_exists(file_path)) {
    rel_path <- fs::path_rel(file_path, usethis::proj_get())
    cli::cli_abort(
      c(
        "x" = "Report file {.path {rel_path}} does not exist.",
        "i" = "Please provide a valid report file to archive."
      )
    )
  }
  # Generate archive name
  ext <- fs::path_ext(file)
  filebase <- fs::path_ext_remove(file)
  version <- desc::desc_get("Version")
  archive_name <- glue::glue(
    "{filebase}_{format(Sys.Date(), '%Y_%m_%d')}_v{version}.{ext}"
  )
  archive_path <- usethis::proj_path("results/reports", archive_name)
  # If needed, check archive does not exist
  if (fs::file_exists(archive_path) & !overwrite) {
    cli::cli_abort(
      c(
        "x" = "Archive file {.path {proj_rel(archive_path)}} already exists.",
        "i" = "Use {.code overwrite = TRUE} to overwrite the existing archive."
      )
    )
  }
  # Move file to archive
  fs::file_move(file_path, archive_path)
  # Inform user
  cli::cli_alert_success(
    "Report archived at {.path {proj_rel(archive_path)}}."
  )
}


#' Save a report file
#'
#' Rename a report file located in the `report/` directory to a unique name
#' including the current date and project version. This function is used when
#' the current version of a report needs to be preserved before making further
#' changes (e.g. write methodology, document new analyses, ...), because
#' [create_report()] will automatically overwrite existing report file.
#'
#' @param file The name of the report file to save. Default is `"report.qmd"`.
#' @param overwrite Logical indicating whether to overwrite an existing file.
#' Defaults to `FALSE`, so an error is raised if the target file already exists.
#'
#' @examples
#' \dontrun{
#' # Creates a file named like "report_interim_2024_06_15_v1.0.0.qmd" in the
#' # same folder
#' save_report("report_interim.qmd")
#' }
#'
#' @export
save_report <- function(file = "report.qmd", overwrite = FALSE) {
  # Check that the file exists
  file_path <- usethis::proj_path("report", file)
  if (!fs::file_exists(file_path)) {
    rel_path <- fs::path_rel(file_path, usethis::proj_get())
    cli::cli_abort(
      c(
        "x" = "Report file {.path {rel_path}} does not exist.",
        "i" = "Please provide a valid report file to archive."
      )
    )
  }
  # Generate archive name
  ext <- fs::path_ext(file)
  filebase <- fs::path_ext_remove(file)
  version <- desc::desc_get("Version")
  archive_name <- glue::glue(
    "{filebase}_{format(Sys.Date(), '%Y_%m_%d')}_v{version}.{ext}"
  )
  archive_path <- usethis::proj_path("report", archive_name)
  # If needed, check archive does not exist
  if (fs::file_exists(archive_path) & !overwrite) {
    cli::cli_abort(
      c(
        "x" = "Report file {.path {proj_rel(archive_path)}} already exists.",
        "i" = "Use {.code overwrite = TRUE} to overwrite the existing save."
      )
    )
  }
  # Move file to archive
  fs::file_move(file_path, archive_path)
  # Inform user
  cli::cli_alert_success(
    "Report saved as {.path {proj_rel(archive_path)}}."
  )
}


#' Project-relative path
proj_rel <- function(path) {
  fs::path_rel(path, usethis::proj_get())
}
