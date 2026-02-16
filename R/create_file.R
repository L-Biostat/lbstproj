#' Create a R script pre-filled with boilerplate code
#'
#' @description A family of helpers that write a minimal R script into a project
#' subfolder under `R/`: figures, tables, functions, and data.
#'
#' @param name Name of the script (without file extension).
#' @param open Whether to open the new file in the editor. Defaults to `TRUE` if
#'   in an interactive session (i.e. in RStudio and other IDEs).
#' @param print Whether to print (default: `TRUE`) a success message to the
#'   console. You can set a default print behavior for all functions in this
#'   family by setting the global option `use.print` to `TRUE` or `FALSE`.
#' @param ... Additional arguments passed to the template rendering function.
#'   See details.
#'
#' @details These functions are called for their side effects: they create a new
#' script, make parent directories if needed, and (optionally) open the file.
#' They do not return a value.
#'
#' When creating a new *table* or a new *figure* script, you can pass the additional
#' argument `id`. It will be used to retrieve caption and label information from
#' the table of tables of the project. This allow dynamic changes to captions
#' and labels in a single place (i.e. the table of tables).
#'
#' @examples
#' \dontrun{
#' create_figure("eda_hist01")
#' create_table("summary_endpoints", open = FALSE)
#' create_function("strings_utils")
#' }
#' @md
#' @name create_scripts
NULL

#' @describeIn create_scripts Create a figure script in `R/figures/`.
#' @export
create_figure <- function(name, open = rlang::is_interactive(), ...) {
  create_file(
    type = "figure",
    name = name,
    open = open,
    ...
  )
}

#' @describeIn create_scripts Create a table script in `R/tables/`.
#' @export
create_table <- function(name, open = rlang::is_interactive(), ...) {
  create_file(type = "table", name = name, open = open, ...)
}

#' @describeIn create_scripts Create a function script in `R/functions/`.
#' @export
create_function <- function(name, open = rlang::is_interactive(), ...) {
  create_file(type = "function", name = name, open = open, ...)
}

#' @describeIn create_scripts Create a data script in `R/data/`.
#' @export
create_data <- function(name, open = rlang::is_interactive(), ...) {
  create_file(type = "data", name = name, open = open, ...)
}

#' @describeIn create_scripts Create a model script in `R/models/`.
#' @export
create_model <- function(name, open = rlang::is_interactive(), ...) {
  create_file(type = "model", name = name, open = open, ...)
}

#' Internal function to create a R-script file from a template based on type
#' @keywords internal
create_file <- function(type, name, open, print = NULL, ...) {
  # Check that type is valid
  type <- rlang::arg_match(
    type,
    c("data", "figure", "table", "function", "model")
  )
  # Define print behavior
  if (is.null(print)) {
    # If global option is not set, defaults to TRUE
    # This will print a success message after creating the file
    print <- getOption("use.print", TRUE)
  }
  # Create file path
  name <- gsub("\\.[rR]$", "", name)
  check_name(name)
  dir <- ifelse(type == "data", "data", paste0(type, "s"))
  file_path <- usethis::proj_path("R", dir, name, ext = "R")
  # If the file already exists skips the rest
  if (fs::file_exists(file_path)) {
    if (print) {
      cli::cli_alert_warning(
        paste(
          "File {.file {fs::path_rel(file_path, proj_get())}} already exists.",
          "Skipping creation."
        )
      )
    }
    return(invisible(NULL))
  } else {
    check_dir_exists(fs::path_dir(file_path))
    fs::file_create(file_path)
  }
  # Fill the corresponding template with appropriate data
  template_path <- fs::path_package(
    "lbstproj",
    "templates",
    paste0(type, ".R")
  )
  template_file <- readLines(template_path)
  template_data <- c(
    list(
      name = name,
      author = get_author(),
      date = format(Sys.Date(), "%d %b %Y")
    ),
    rlang::list2()
  )
  output_file <- whisker::whisker.render(
    template_file,
    template_data
  )
  writeLines(output_file, con = file_path)
  # Open the file if requested
  if (open) {
    if (rstudioapi::isAvailable() && rstudioapi::hasFun("navigateToFile")) {
      rstudioapi::navigateToFile(file_path)
    } else {
      utils::file.edit(file_path)
    }
  }
  # Inform the user
  if (print) {
    cli::cli_alert_success(
      paste(
        "{stringr::str_to_title(type)} created at",
        "{.file {fs::path_rel(file_path)}}"
      )
    )
  }
}
