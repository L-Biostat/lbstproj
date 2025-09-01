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
#'  * `use_data()`: `R/data/`
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
use_data <- function(
  name,
  open = rlang::is_interactive(),
  overwrite = FALSE
) {
  use_skeleton(name, open, type = "data", overwrite)
}

#' @rdname use_data
#' @export
use_table <- function(name, open = rlang::is_interactive(), overwrite = FALSE) {
  use_skeleton(name, open, type = "table", overwrite)
}

#' @rdname use_data
#' @export
use_figure <- function(
  name,
  open = rlang::is_interactive(),
  overwrite = FALSE
) {
  use_skeleton(name, open, type = "figure", overwrite)
}

#' @rdname use_data
#' @export
use_function <- function(
  name,
  open = rlang::is_interactive(),
  overwrite = FALSE
) {
  use_skeleton(name, open, type = "function", overwrite)
}

# Helper functions --------------------------------------------------------------
# All dot-functions are internal and DO NOT CHECK arguments. They are called
# from use_skeleton() which does all the necessary checks.

.sanitize_name <- function(name) {
  usethis:::check_character(name)
  gsub("[^a-zA-Z0-9_]+", "_", name)
}

.check_dir_exists <- function(type) {
  if (type %in% c("figure", "table")) {
    dir_path <- fs::path("R", paste0(type, "s"))
  } else {
    dir_path <- fs::path("R", type)
  }
  if (!fs::dir_exists(dir_path)) {
    fs::dir_create(dir_path)
    cli::cli_alert_info("Creating directory {.path {dir_path}}")
  }
}

.generate_file_path <- function(type, name) {
  good_name <- sanitize_name(name)
  if (type %in% c("figure", "table")) {
    file_path <- fs::path("R", paste0(type, "s"), good_name, ext = "R")
  } else {
    file_path <- fs::path("R", type, good_name, ext = "R")
  }
}

.get_author <- function() {
  # Check if the DESCRIPTION file exists
  if (!fs::file_exists("DESCRIPTION")) {
    cli::cli_alert_warning(
      "No DESCRIPTION file found. Using a placeholder author name."
    )
    return("Your Name")
  }
  sub("\\s*<.*", "", desc::desc_get_author())
}

.fill_template <- function(type, name, file_path, open) {
  usethis::use_template(
    template = paste0(type, ".R"),
    package = "lbstproj",
    save_as = file_path,
    data = list(
      name = name,
      date = format(Sys.Date(), "%d %b %Y"),
      author = .get_author()
    ),
    ignore = FALSE,
    open = open
  )
  # User message
  cli::cli_alert_success("Writing file {.path {file_path}}")
  cli::cli_alert_warning("Finish editing the script !")
  if (type != "function") {
    cli::cli_alert_info(
      "Save your {.val {type}} using {.fn lbstproj::save_{type}}"
    )
  }
}

use_skeleton <- function(name, open, type, overwrite) {
  # Check the name is valid
  usethis:::check_file_name(name)
  # Check that type is valid
  accepted_types <- c("data", "figure", "table", "function")
  if (!type %in% accepted_types) {
    cli::cli_abort(
      "Invalid type {.val {type}}. Accepted types are: {.val {accepted_types}}."
    )
  }
  # Create directory if it doesn't exist
  .check_dir_exists(type)
  # Generate file path
  file_path <- .generate_file_path(type, name)
  # Check if the file already exists
  usethis:::check_file_name(file_path, overwrite)
  # Fill the template
  .fill_template(type, name, file_path, open)
  # Return the file path invisibly
  invisible(file_path)
}
