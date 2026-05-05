# -------------------------------------------------------------------------
# ┌------------┐
#   lbstproj
# \------------┘
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
#' @return Invisibly returns the path to the archived report file.
#' @examples
#' with_example_project({
#'   # Create two report files; make the first one older
#'   writeLines("<html><body>Report v1</body></html>", "report/report-v1.html")
#'   fs::file_touch(
#'     "report/report-v1.html",
#'     modification_time = Sys.time() - 60
#'   )
#'   writeLines("<html><body>Report v2</body></html>", "report/report-v2.html")
#'
#'   cat("Modification times (report-v2 is more recent):\n")
#'   print(fs::file_info(fs::dir_ls("report"))[c("path", "modification_time")])
#'
#'   cat("\nBefore:\n")
#'   fs::dir_tree("results/reports")
#'
#'   # file = NULL: automatically archives the most recently modified file
#'   archive_report(quiet = TRUE)
#'
#'   cat("\nAfter:\n")
#'   fs::dir_tree("results/reports")
#' })
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
  archive_path <- fs::path(
    "results",
    "reports",
    paste0(filebase, "_v", version),
    ext = ext
  )
  # If needed, check archive does not exist
  check_can_overwrite(archive_path, overwrite, what = "Archive file")
  # Move file to archive
  fs::file_move(file_path, archive_path)
  # Inform user
  if (isFALSE(quiet)) {
    cli::cli_alert_success(
      "Report archived at {.path {archive_path}}."
    )
  }
  invisible(archive_path)
}
