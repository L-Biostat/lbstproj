#' Create a skeleton script
#'
#' These functions set up a directory (if needed) and create a new R script from
#' a template. The script serves as a starting point for preparing data,
#' generating tables, creating figures, or writing helper functions in your
#' project.
#'
#' @details
#' Depending on the function you use, the script will be placed in one of the
#' following directories:
#'  * `use_data_raw()`: `R/data/`
#'  * `use_table()`: `R/tables/`
#'  * `use_figure()`: `R/figures/`
#'  * `use_function()`: `R/functions/`
#'
#' @param name Name of the dataset/table/figure/function. This will be sanitized
#'   and used as the script file name.
#' @param open Open the newly created file for editing? Happens in RStudio, if
#'   applicable, or via [utils::file.edit()] otherwise.
#' @param overwrite By default, all the `use_*` functions will not overwrite
#'   existing files. Set to `TRUE` if you really want to do so.
#'
#' @md
#' @export
use_data_raw <- function(
  name,
  open = rlang::is_interactive(),
  overwrite = FALSE
) {
  # Use the helper function
  file_path <- use_skeleton(name, open, overwrite, type = "data")
  # Print info message
  cli::cli_bullets(c(
    "*" = "Finish writing the data preparation script in {.path {file_path}}.",
    "*" = "Use {.fun lbstproj::save_data} to save prepared data in {.path data/processed}."
  ))
}

#' @rdname use_data_raw
#' @export
use_table <- function(name, open = rlang::is_interactive(), overwrite = FALSE) {
  # Use the helper function
  file_path <- use_skeleton(name, open, overwrite, type = "table")
  # Print info message
  cli::cli_bullets(c(
    "*" = "Finish writing the table-generating script in {.path {file_path}}.",
    "*" = "Use {.fun lbstproj::save_table} to save your table (stored in {.path data/tables} and optionally exported to {.path output/tables})."
  ))
}

#' @rdname use_data_raw
#' @export
use_figure <- function(
  name,
  open = rlang::is_interactive(),
  overwrite = FALSE
) {
  # Use the helper function
  file_path <- use_skeleton(name, open, overwrite, type = "figure")
  # Print info message
  cli::cli_bullets(c(
    "*" = "Finish writing the figure-generating script in {.path {file_path}}.",
    "*" = "Use {.fun lbstproj::save_figure} to save your figure (stored in {.path data/figures} and optionally exported to {.path output/figures})."
  ))
}

#' @rdname use_data_raw
#' @export
use_function <- function(
  name,
  open = rlang::is_interactive(),
  overwrite = FALSE
) {
  # Use the helper function
  file_path <- use_skeleton(name, open, overwrite, type = "function")
  # Print info message
  cli::cli_bullets(c(
    "*" = "Finish writing the helper function in {.path {file_path}}."
  ))
}

use_skeleton <- function(name, open, overwrite, type) {
  # Type should match data, figure, table, or function
  stopifnot(type %in% c("data", "figure", "table", "function"))
  # Check the name
  usethis:::check_name(name)
  # Create file path
  file_path <- fs::path("R", paste0(type, "s"), sanitize_name(name), ext = "R")
  # Create directory if it doesn't exist
  usethis::use_directory(paste0("R/", type, "s"), ignore = FALSE)
  # Create the file based on the template
  usethis::use_template(
    template = paste0(type, ".R"),
    package = "lbstproj",
    save_as = file_path,
    data = list(
      name = name,
      date = format(Sys.Date(), "%d %b %Y"),
      author = get_author()
    ),
    ignore = FALSE,
    open = open,
    overwrite = overwrite
  )
  # Return the file path invisibly
  invisible(file_path)
}

get_author <- function() {
  sub("\\s*<.*", "", desc::desc_get_author())
}

sanitize_name <- function(name) {
  usethis:::check_character(name)
  gsub("[^a-zA-Z0-9_]+", "_", name)
}
