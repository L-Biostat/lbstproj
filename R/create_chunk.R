#' Create a quarto code chunk from the TOT
#'
#' @description
#' Generate the quarto code chunk to include a figure or table in a report
#' based on the information stored in the table of tables (TOT). The element
#' can be identified by its `id` or `name`. The chunk includes the correct path to the
#' element as well as the caption and a quarto-safe chunk label (starting with `tbl`
#' for tables and `fig` for figures to allow for cross-referencing).
#'
#' If the function is called from Rstudio or the console, the code chunk is always
#' copied to the clipboard to easily paste it in the report file if needed.
#'
#' @param output_type *Character*. Output format to use when building the
#'   code chunk. Should match the output type of the report. Only `"docx"` or `"html"`
#'   are supported.
#'
#'   *Default*: `"html"`
#' @param id *Character*. Identifier of the element in the TOT. Either this or the
#'   `name` must be provided but not both.
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
#'   *Default*: `FALSE` unless the global option `lbstproj.quiet` is set otherwise.
#'
#' @return The rendered quarto chunk as a character string, invisibly
#' @export
create_chunk <- function(
  output_type = "html",
  id = NULL,
  name = NULL,
  print = TRUE,
  pad = TRUE,
  quiet = getOption("lbstproj.quiet", FALSE)
) {
  # Retrieve element from the TOT
  details <- get_info(id = id, name = name) # Will error if both are given !
  # Load the code chunk template
  template <- readLines(
    con = fs::path_package(
      fs::path("templates", paste0(details$type, "_chunk"), ext = "qmd"),
      package = "lbstproj"
    )
  )
  # Define the template data
  data_path <- ifelse(
    details$type == "figure",
    fs::path("results/figures", details$name, ext = "png"),
    fs::path("data/tables", details$name, ext = "rds")
  )
  # Define the table prefix based on report output type
  tab_prefix <- ifelse(output_type == "docx", "tab", "tbl")
  template_data <- list(
    name = details$name,
    path = data_path,
    tab_prefix = tab_prefix
  )
  # Render the template with the data
  rendered_chunk <- whisker::whisker.render(template, template_data)
  # Pad the chunk if requested
  if (pad) {
    rendered_chunk <- sprintf(
      "%s\n\n{{< pagebreak >}}\n\n",
      rendered_chunk
    )
  }
  # If needed, print the chunk to the console
  if (print) {
    cat(rendered_chunk, sep = "\n")
  }
  # Copy the chunk to the clipboard if in interactive mode
  if (rlang::is_interactive()) {
    utils::writeClipboard(rendered_chunk)
    if (isFALSE(quiet)) {
      cli::cli_alert_success(
        "The chunk for {details$type} {.val {details$name}} has been copied to the clipboard."
      )
    }
  }
  # Return the rendered chunk invisibly
  invisible(rendered_chunk)
}
