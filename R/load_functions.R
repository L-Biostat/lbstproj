#' Load functions from the `R/functions` directory
#'
#' These helper functions load one or all functions from the `R/functions`
#' directory.
#'
#' @param name The name of the specific function file to load. It must be
#'   relative to the `R/functions` directory and can include or omit the `.R`
#'   extension.
#'
#' @examples
#' \dontrun{
#' load_all_functions()
#' load_function("data_cleaning") # Works
#' load_function("data_cleaning.R") # Also works
#' load_function("R/functions/data_cleaning.R") # Fails
#' }
#'
#' @name load_func
NULL

#' @describeIn load_func Load all function files.
#' @export
load_all_functions <- function() {
  fn_dir <- usethis::proj_path("R/functions")
  # List all functions (*.R files) in `R/functions`
  fn_files <- fs::dir_ls(fn_dir, glob = "*.R")
  # Source each function file
  purrr::walk(fn_files, source)
}

#' @describeIn load_func Load a single function file.
#' @export
load_function <- function(name) {
  # Delete any extensions to the file name
  clean_name <- gsub("\\.[Rr]$", "", name)
  # Construct the full path to the function file
  file_path <- usethis::proj_path("R/functions", clean_name, ext = "R")
  # Ensure the file exists
  if (!fs::file_exists(file_path)) {
    cli::cli_abort(
      "Function file {.path {fs::path_rel(file_path)}} does not exist."
    )
  }
  # Source the specified function file
  source(file_path)
}
