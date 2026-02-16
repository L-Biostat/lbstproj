#' Create a quarto code chunk from the TOT
#'
#' Generate the quarto code chunk  to include a figure or table in a report
#' based on the information in the table of tables (TOT). The TOT-element is
#' identified from its ID. The chunk includes the correct path to the element as
#' well as the caption and a quarto-safe chunk label (starting with `tbl` for
#' tables and `fig` for figures to allow for cross-referencing).
#'
#' @param id The id of the element as specified in the table of tables (TOT)
#' @param print Logical, whether to print the chunk to the console (default:
#'   TRUE)
#' @param copy Logical, whether to copy the chunk to the clipboard (default:
#'   TRUE if in interactive mode, FALSE otherwise)
#' @param pad Logical, whether to pad the chunk with blank lines before and
#'   after and add a page break after (default: FALSE)
#'
#' @return The rendered quarto chunk as a character string, invisibly
create_chunk <- function(id, copy = TRUE, print = TRUE, pad = FALSE) {
  rlang::check_required(id)
  # Retrieve figure details from the TOT
  details <- get_info(id)
  type <- details$type
  # Load the figure chunk template
  template <- readLines(
    con = fs::path_package(
      fs::path("templates", paste0(type, "_chunk"), ext = "qmd"),
      package = "lbstproj"
    )
  )
  # Define the template data
  data_path <- ifelse(
    type == "figure",
    fs::path("results/figures", details$name, ext = "png"),
    fs::path("data/tables", details$name, ext = "rds")
  )
  template_data <- list(
    id = details$name,
    caption = details$caption,
    path = data_path
  )
  # Render the template with the data
  rendered_chunk <- whisker::whisker.render(template, template_data)
  # Pad the chunk if requested
  if (pad) {
    rendered_chunk <- c("", rendered_chunk, "", "{{<pagebreak>}}", "")
  }
  # If needed, print the chunk to the console
  if (print) {
    cat(rendered_chunk, sep = "\n")
  }
  # Copy the chunk to the clipboard if in interactive mode
  if (rlang::is_interactive() && copy) {
    writeClipboard(rendered_chunk)
    cli::cli_alert_success("The chunk has been copied to the clipboard.")
  }
  # Return the rendered chunk invisibly
  invisible(rendered_chunk)
}
