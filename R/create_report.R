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
#' with_example_project({
#'   create_report(quiet = TRUE)
#'   fs::dir_tree("report")
#' }, with_tot = TRUE)
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
  headers <- build_section_headers(tot)
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
  chunks_with_headers <- ifelse(
    nzchar(headers),
    paste0(headers, "\n\n", chunks),
    chunks
  )
  report <- c(report_basis, chunks_with_headers)
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


# Build a character vector of Markdown section headers, one entry per TOT row.
#
# For each row, compares section/subsection/subsubsection values against the
# previous row. A header line is emitted only when the value at that level
# changes. Changing a parent level resets child-level tracking so sub-headers
# re-appear under a new parent even if their text is identical.
#
# Empty string values are never emitted as headers; they simply clear the
# current level's state.
#
# @param tot A data frame with columns `section`, `subsection`,
#   `subsubsection` (all character, added by `validate_tot()` if absent).
# @return A character vector of length `nrow(tot)`. Each element is either
#   `""` (no headers for this row) or one or more Markdown header lines joined
#   by `"\n\n"`.
# @keywords internal
build_section_headers <- function(tot) {
  n <- nrow(tot)
  headers <- character(n)

  prev_sec    <- NULL
  prev_sub    <- NULL
  prev_subsub <- NULL

  for (i in seq_len(n)) {
    sec    <- tot$section[i]
    sub    <- tot$subsection[i]
    subsub <- tot$subsubsection[i]

    sec_changed    <- !identical(sec, prev_sec)
    sub_changed    <- sec_changed    || !identical(sub, prev_sub)
    subsub_changed <- sub_changed    || !identical(subsub, prev_subsub)

    lines <- character(0)

    if (sec_changed) {
      prev_sec    <- sec
      prev_sub    <- NULL
      prev_subsub <- NULL
      if (nzchar(sec)) lines <- c(lines, paste0("# ", sec))
    }

    if (sub_changed) {
      prev_sub    <- sub
      prev_subsub <- NULL
      if (nzchar(sub)) lines <- c(lines, paste0("## ", sub))
    }

    if (subsub_changed) {
      prev_subsub <- subsub
      if (nzchar(subsub)) lines <- c(lines, paste0("### ", subsub))
    }

    headers[i] <- paste(lines, collapse = "\n\n")
  }

  headers
}
