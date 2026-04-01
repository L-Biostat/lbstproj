# -------------------------------------------------------------------------
# ┌------------┐
#   lbstproj
# \------------┘
#
# create_file.R:
# Create a new R file in the project
# -------------------------------------------------------------------------

#' Create an R file from a template
#'
#' @description Create a R file from a template. Dedicated templates are used
#'   when `type` is `"data"`, `"figure"`, or `"table"`. Any other `type` uses the
#'   default template.
#'
#'   Files are created under `R/<type>(s)/` (e.g. `R/figures/` for `type =
#'   "figure"`), except `type = "data"` which goes to `R/data/`, or `type =
#'   "analysis"` which goes to `R/analysis/`.
#'
#'   For types other than `"figure"`, `"table"`, and `"data"` (which have
#'   dedicated [save_outputs] functions), a matching `data/<subdir>/` directory
#'   is also created. This is the conventional location to save objects produced
#'   by scripts in `R/<subdir>/` using [base::saveRDS].
#'
#'   If the target directory does not exist, it will be created automatically.
#'
#' @param type *Character*. Used to choose both the subdirectory and the
#'   template.
#' @param name *Character*. File name (with or without `.R`).
#' @param open *Logical*. Open the file after creation.
#' @param quiet *Logical*. If `TRUE`, suppress informational messages. Important
#'   messages (e.g. directory creation or errors) are still shown.
#'
#'   *Default*: `TRUE` unless the global option `lbstproj.quiet` is set otherwise.
#' @param ... Additional fields passed as data to the file template.
#'
#' @return Invisibly returns the path of the file created.
#' @examples
#' if(FALSE) {
#' # Hypothetical project layout:
#' # .
#' # \- R/
#' #    |- figures/
#' #    \- tables/
#'
#' # 1) Create a figure file in `R/figures/`
#' create_file(type = "figure", name = "hr_by_age")
#' # > v Figure file created at 'R/figures/hr_by_age.R'
#'
#' # 2) Create a table file in `R/tables/`
#' create_file(type = "table", name = "baseline_characteristics.R")
#' # > v Table file created at 'R/tables/baseline_characteristics.R'
#'
#' # 3) Create a model file (custom type): creates R/models/ and data/models/
#' create_file(type = "model", name = "primary_model")
#' # > i Created directory 'R/models'.
#' # > i Created directory 'data/models'.
#' # > v Model file created at 'R/models/primary_model.R'.
#'
#' # 4) Calling again does not overwrite
#' create_file(type = "model", name = "primary_model")
#' # > ! File 'R/models/primary_model.R' already exists and will not be overwritten.
#' }
#'
#' @export
create_file <- function(
  type,
  name,
  open = TRUE,
  quiet = getOption("lbstproj.quiet", FALSE),
  ...
) {
  # Validate inputs
  check_string(type)
  name <- validate_file_name(name)

  # Subdirectory rule: figure -> figures, table -> tables, etc.
  # Special-cases: data -> data; analysis -> analysis
  subdir <- type_to_subdir(type)

  # Create directory path and ensure it exists
  dir_path <- fs::path("R", subdir)
  ensure_dir_exists(dir_path)

  # For custom types (not figure/table/data which have dedicated save_* functions),
  # also create the matching data/<subdir>/ directory
  if (!type %in% c("figure", "table", "data")) {
    ensure_dir_exists(fs::path("data", subdir))
  }

  # Create file path and ensure it DOES NOT exist
  file_path <- fs::path(dir_path, name, ext = "R")
  ensure_file_does_not_exist(file_path)

  # Find type-specific template
  template_name <- switch(
    type,
    figure = "figure",
    table = "table",
    data = "data",
    "file"
  )
  template_path <- fs::path_package(
    package = "lbstproj",
    fs::path("templates", template_name, ext = "R")
  )

  # Generate template data (name, author, date and additional arguments)
  template_data <- c(
    list(
      name = name,
      type = type,
      author = get_author(),
      date = format(Sys.Date(), "%d %b %Y")
    ),
    rlang::list2(...)
  )

  # Render template
  file_content <- whisker::whisker.render(
    template = readLines(template_path),
    data = template_data
  )

  # Write it to file
  writeLines(file_content, file_path)

  # Open the file if interactive mode and Rstudio
  if (isTRUE(open)) {
    if (rstudioapi::isAvailable() && rstudioapi::hasFun("navigateToFile")) {
      rstudioapi::navigateToFile(file_path)
    } else {
      utils::file.edit(file_path)
    }
  }

  # Inform user about file creation
  if (isFALSE(quiet)) {
    cli::cli_alert_success(
      "{.strong {stringr::str_to_title(name)}} file created at {.file {file_path}}."
    )
  }

  # Invisible return
  invisible(file_path)
}
