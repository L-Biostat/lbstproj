#' Create a code chunk from the TOT
#'
#' @description
#' Generate the code chunk to include a figure or table in a report based on
#' the information stored in the table of tables (TOT). The element can be
#' identified by its `id` or `name`. The chunk includes the correct path to the
#' element as well as the caption and a chunk label (starting with `tbl`/`tab`
#' for tables and `fig` for figures to allow for cross-referencing).
#'
#' For **gt** projects the output is a Quarto (`.qmd`) chunk. For **flextable**
#' projects the output is an R Markdown (`.Rmd`) chunk suitable for use with
#' `officedown::rdocx_document`.
#'
#' If the function is called from RStudio or the console, the code chunk is
#' always copied to the clipboard to easily paste it in the report file.
#'
#' @param output_type *Character*. Output format to use when building the
#'   code chunk for **gt** projects. Should match the output type of the
#'   report. Only `"docx"` or `"html"` are supported. Ignored for flextable
#'   projects (always `"docx"`).
#'
#'   *Default*: `"html"`
#' @param id *Character*. Identifier of the element in the TOT. Either this or
#'   the `name` must be provided but not both.
#' @param name *Character*. Name of the element in the TOT. Either this or the
#'   `id` must be provided but not both.
#' @param print *Logical*. If `TRUE`, print the generated chunk to the console.
#'
#'   *Default*: `TRUE` to allow for quick visual check.
#' @param pad *Logical*. If `TRUE`, add blank lines before and after the chunk
#'   and insert a page break after it.
#'
#'   *Default*: `TRUE`
#' @param quiet *Logical*. If `TRUE`, suppress informational messages. Important
#'   messages (e.g. directory creation or errors) are still shown.
#'
#'   *Default*: `FALSE` unless the global option `lbstproj.quiet` is set
#'   otherwise.
#'
#' @return The rendered chunk as a character string, invisibly.
#' @examples
#' with_example_project({
#'   tot <- load_tot()
#'
#'   cat("# Chunk by id (padded, includes page break):\n")
#'   create_chunk(id = tot$id[[1]], print = TRUE, quiet = TRUE)
#'
#'   cat("\n# Chunk by name (no page break):\n")
#'   create_chunk(name = tot$name[[1]], pad = FALSE, print = TRUE, quiet = TRUE)
#' }, with_tot = TRUE)
#' @export
create_chunk <- function(
  output_type = "html",
  id = NULL,
  name = NULL,
  print = TRUE,
  pad = TRUE,
  quiet = getOption("lbstproj.quiet", FALSE)
) {
  details <- get_info(id = id, name = name)

  if (is_flextable_project()) {
    rendered_chunk <- create_chunk_flextable(details = details, pad = pad)
  } else {
    rendered_chunk <- create_chunk_gt(
      details = details,
      output_type = output_type,
      pad = pad
    )
  }

  if (print) {
    cat(rendered_chunk, sep = "\n")
  }
  if (rlang::is_interactive()) {
    utils::writeClipboard(rendered_chunk)
    if (isFALSE(quiet)) {
      cli::cli_alert_success(
        "The chunk for {details$type} {.val {details$name}} has been copied to the clipboard."
      )
    }
  }
  invisible(rendered_chunk)
}

# Build a Quarto-style chunk for gt projects.
#
# @param details Named list with `type` and `name` fields (from `get_info()`).
# @param output_type `"html"` or `"docx"`.
# @param pad Logical. Insert pagebreak padding.
# @return Character string.
# @keywords internal
create_chunk_gt <- function(details, output_type = "html", pad = TRUE) {
  template <- readLines(
    con = fs::path_package(
      fs::path("templates", paste0(details$type, "_chunk"), ext = "qmd"),
      package = "lbstproj"
    )
  )
  data_path <- ifelse(
    details$type == "figure",
    fs::path("results/figures", details$name, ext = "png"),
    fs::path("data/tables", details$name, ext = "rds")
  )
  tab_prefix <- ifelse(output_type == "docx", "tab", "tbl")
  template_data <- list(
    name = details$name,
    path = data_path,
    tab_prefix = tab_prefix
  )
  rendered <- whisker::whisker.render(template, template_data)
  if (pad) {
    rendered <- sprintf("%s\n\n{{< pagebreak >}}\n\n", rendered)
  }
  rendered
}

# Build an R Markdown-style chunk for flextable / officedown projects.
#
# @param details Named list with `type` and `name` fields (from `get_info()`).
# @param pad Logical. Insert pagebreak padding.
# @return Character string.
# @keywords internal
create_chunk_flextable <- function(details, pad = TRUE) {
  template <- readLines(
    con = fs::path_package(
      fs::path("templates", paste0(details$type, "_chunk"), ext = "Rmd"),
      package = "lbstproj"
    )
  )
  data_path <- ifelse(
    details$type == "figure",
    fs::path("results/figures", details$name, ext = "png"),
    fs::path("data/tables", details$name, ext = "rds")
  )
  template_data <- list(
    name = details$name,
    path = data_path
  )
  rendered <- whisker::whisker.render(template, template_data)
  if (pad) {
    rendered <- sprintf("%s\n\n\\newpage\n\n", rendered)
  }
  rendered
}
