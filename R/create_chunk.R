#' Standardized way to create a Rmd code chunk to insert a figure or a table
#'
#' @param id The id of the figure as specified in the table of tables (TOT)
#' @param type The type of the entry, either "figure" or "table"
#' @param print Logical, whether to print the chunk to the console (default:
#'   TRUE)
#' @param copy Logical, whether to copy the chunk to the clipboard (default:
#'   TRUE if in interactive mode)
#' @param pad Logical, whether to pad the chunk with blank lines before and
#'   after and a pagebreak after (default: FALSE)
#'
#' @return The rendered Rmd chunk as a character string, invisibly
create_chunk <- function(id, type, copy = TRUE, print = TRUE, pad = FALSE) {
  rlang::check_required(id)
  rlang::arg_match(type, values = c("figure", "table"))
  # Retrieve figure details from the TOT
  details <- get_info(id)
  # Throw error if the corresponding entry is not a figure
  if (details$type != type) {
    cli::cli_abort(
      "The entry with id {.val {id}} is not a {.val {type}} but a
      {.val {details$type}}."
    )
  }
  # Load the figure chunk template
  chk_name <- paste0(type, "_chunk")
  template <- readLines(
    con = fs::path_package(
      fs::path("templates", chk_name, ext = "Rmd"),
      package = "lbstproj"
    )
  )
  # Define the template data
  data_path <- ifelse(
    type == "figure",
    fs::path("results/figures", details$name, ext = "png"),
    fs::path("data/tables", details$name, ext = "rds")
  )
  prefix <- ifelse(type == "figure", "fig-", "tab-")
  template_data <- list(
    id = paste0(prefix, details$name),
    caption = details$caption,
    path = data_path
  )
  # Render the template with the data
  rendered_chunk <- whisker::whisker.render(template, template_data)
  # Pad the chunk if requested
  if (pad) {
    rendered_chunk <- c("", rendered_chunk, "", "\\newpage", "")
  }
  # If needed, print the chunk to the console
  if (print) {
    cat(rendered_chunk, sep = "\n")
  }
  # Copy the chunk to the clipboard if in interactive mode
  if (rlang::is_interactive() && copy) {
    clipr::write_clip(rendered_chunk, allow_non_interactive = FALSE)
    cli::cli_alert_success("The chunk has been copied to the clipboard.")
  }
  # Return the rendered chunk invisibly
  invisible(rendered_chunk)
}

#' Create a Rmd code chunk to insert a table
#'
#' @inheritParams create_chunk
#'
#' @export
create_table_chunk <- function(id, copy = TRUE, print = TRUE, pad = FALSE) {
  create_chunk(id = id, type = "table", copy = copy, print = print, pad = pad)
}

#' Create a Rmd code chunk to insert a figure
#'
#' @inheritParams create_chunk
#'
#' @export
create_figure_chunk <- function(id, copy = TRUE, print = TRUE, pad = FALSE) {
  create_chunk(id = id, type = "figure", copy = copy, print = print, pad = pad)
}
