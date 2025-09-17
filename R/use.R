#' Create a R script pre-filled with boilerplate code
#'
#' @description
#' A family of helpers that write a minimal R script into a project subfolder
#' under `R/`: figures, tables, functions, and data.
#'
#' @param name Name of the script (without file extension).
#' @param overwrite Whether to overwrite an existing file with the same name. Defaults to `FALSE`.
#' @param open Whether to open the new file in the editor. Defaults to `TRUE` if in an interactive session (i.e. in RStudio and other IDEs).
#'
#' @details
#' These functions are called for their side effects: they create a new script,
#' make parent directories if needed, and (optionally) open the file. They do
#' not return a value.
#'
#' @examples
#' \dontrun{
#' use_figure("eda_hist01", overwrite = FALSE)
#' use_table("summary_endpoints", open = FALSE)
#' use_function("strings_utils")
#' }
#' @md
#' @name use_scripts
NULL

#' @describeIn use_scripts Create a figure script in `R/figures/`.
#' @export
use_figure <- function(
  name,
  overwrite = FALSE,
  open = rlang::is_interactive()
) {
  use_file(type = "figure", name = name, overwrite = overwrite, open = open)
}

#' @describeIn use_scripts Create a table script in `R/tables/`.
#' @export
use_table <- function(name, overwrite = FALSE, open = rlang::is_interactive()) {
  use_file(type = "table", name = name, overwrite = overwrite, open = open)
}

#' @describeIn use_scripts Create a function script in `R/functions/`.
#' @export
use_function <- function(
  name,
  overwrite = FALSE,
  open = rlang::is_interactive()
) {
  use_file(type = "function", name = name, overwrite = overwrite, open = open)
}

#' @describeIn use_scripts Create a data script in `R/data/`.
#' @export
use_data <- function(name, overwrite = FALSE, open = rlang::is_interactive()) {
  use_file(type = "data", name = name, overwrite = overwrite, open = open)
}

# Internal function to create a R-script file from a template based on type
use_file <- function(type, name, overwrite, open) {
  # Create file path
  dir_name <- ifelse(
    type == "data",
    "data",
    paste0(type, "s")
  )
  file_path <- fs::path_wd("R", dir_name, name, ext = "R")
  # Check if file already exists
  check_file_absent(file_path, overwrite = overwrite)
  # Ensure the parent directory exists, create if not
  check_dir_exists(fs::path_dir(file_path))
  # Read the figure template
  template <- readLines(
    con = fs::path_package(
      fs::path("templates", type, ext = "R"),
      package = "lbstproj"
    )
  )
  # Generate data to use in the template
  author <- desc::desc_get_author()
  template_data <- list(
    name = paste0(name, ".R"),
    author = get_author(),
    date = format(Sys.Date(), "%d %B %Y")
  )
  # Render the template with the data
  rendered <- whisker::whisker.render(template = template, data = template_data)
  # Write the rendered template to the figure path
  writeLines(text = rendered, con = file_path)
  # Open the file if requested
  if (open) {
    file.edit(file_path)
  }
  # Inform the user
  cli::cli_alert_success(
    "{stringr::str_to_title(type)} created at {.file {fs::path_rel(file_path)}}"
  )
}
