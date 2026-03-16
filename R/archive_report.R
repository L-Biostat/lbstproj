# -------------------------------------------------------------------------
# ┌────────────┐
# │  lbstproj  │
# └────────────┘
#
# archive_report.R:
# Archive a quarto report
# -------------------------------------------------------------------------

#' Archive a rendered report
#'
#' Moves a rendered report from the `report/` directory to the
#' `results/reports/` directory and renames it to include the current date and
#' project version. This function is typically used after rendering a report
#' with [run_report()], to save a copy of the rendered output.
#'
#' @param file *Character* or `NULL`. The name of the report file to archive. If
#'   `NULL`, the most recently modified rendered report in `report/` is used.
#' @param overwrite *Logical*. Indicate whether to overwrite an existing archive file.
#'
#'   *Default*: `FALSE`, an error is raised if the archive file already exists.
#' @param quiet *Logical*. If `TRUE`, suppress informational messages. Important
#'   messages (e.g. directory creation or errors) are still shown.
#'
#'   *Default*: `FALSE` unless the global option `lbstproj.quiet` is set otherwise.
#' @export
archive_report <- function(
  file = NULL,
  overwrite = FALSE,
  quiet = getOption("lbstproj.quiet", FALSE)
) {
  file_path <- resolve_report_file(
    file = file,
    extensions = c("html", "docx"),
    action = "archive"
  )
  # Generate archive name
  ext <- fs::path_ext(file_path)
  filebase <- fs::path_ext_remove(fs::path_file(file_path))
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
  if (isFALSE(quiet)) {
    cli::cli_alert_success(
      "Report archived at {.path {proj_rel(archive_path)}}."
    )
  }
}
