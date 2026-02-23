#' Create an R script from a template
#'
#' Uses dedicated templates for `data`, `figure`, and `table`. Any other `type`
#' uses the default template `file.R`.
#'
#' Files are created under `R/<type>s/` (e.g. `R/figures/` for `type =
#' "figure"`), except `type = "data"` which goes to `R/data/`, or `type =
#' "analysis"` which goes to `R/analysis/`.
#'
#' If the target directory does not exist, the user is asked to confirm its
#' creation.
#'
#' @param type Character scalar. Used to choose both the subdirectory and the
#'   template.
#' @param name File name (with or without `.R`).
#' @param open Logical. Open the file after creation.
#' @param print Logical. Print informative messages about file creation.
#'   Value taken from the global option `use.print` (which defaults to `TRUE`).
#' @param ... Additional fields passed to the template renderer (whisker).
#'
#' @return Invisibly returns the created file path, or `NULL` if
#'   skipped/aborted.
#' @examples
#' #' @examples
#' \dontrun{
#' # Hypothetical project layout:
#' # .
#' # └─ R/
#' #    ├─ figures/
#' #    └─ tables/
#'
#' # 1) Create a figure script in `R/figures/`
#' create_file(type = "figure", name = "hr_by_age")
#' # > ✓ Figure script created at R/figures/hr_by_age.R
#'
#' # 2) Create a table script in `R/tables/`
#' create_file(type = "table", name = "baseline_characteristics.R")
#' # > ✓ Table script created at R/tables/baseline_characteristics.R
#'
#' # 3) Create an analysis script (uses default template) in R/analysis/
#' #    If `R/analysis` does not exist, you will be prompted:
#' create_file(type = "analysis", name = "primary_model")
#' # > ? Directory `R/analysis` does not exist. Create it? [Y/n]:
#' # > ✓ Created directory R/analysis.
#' # > ✓ Analysis script created at R/analysis/primary_model.R
#'
#' # 4) Calling again does not overwrite
#' create_file(type = "analysis", name = "primary_model")
#' # > ! File R/analysis/primary_model.R already exists. Skipping creation.
#' }
#'
#' @export
create_file <- function(
  type,
  name,
  open = TRUE,
  print = getOption("use.print", TRUE),
  ...
) {
  # --- defaults ----------------------------------------------------------------
  # Normalize inputs
  type <- as.character(type)[1]
  name <- gsub("\\.[rR]$", "", as.character(name)[1])
  check_name(name)

  # Subdirectory rule: figure -> figures, table -> tables, etc.
  # Special-cases: data -> data; analysis -> analysis
  subdir <- switch(
    type,
    data = "data",
    analysis = "analysis",
    paste0(type, "s")
  )

  dir_path <- usethis::proj_path("R", subdir)

  # Ensure directory exists (asks user if needed)
  dir_path <- ensure_dir_exists(dir_path, print = print)
  if (is.null(dir_path)) return(invisible(NULL))

  file_path <- fs::path(dir_path, fs::path_ext_set(name, "R"))
  rel_file_path <- proj_rel_path(file_path)

  # --- skip if file already exists --------------------------------------------
  if (fs::file_exists(file_path)) {
    if (isTRUE(print)) {
      cli::cli_alert_warning(
        "File {.file {rel_file_path}} already exists. Skipping creation."
      )
    }
    return(invisible(NULL))
  }

  # --- choose template ---------------------------------------------------------
  template_key <- if (type %in% c("data", "figure", "table")) type else "file"
  template_path <- fs::path_package(
    "lbstproj",
    "templates",
    paste0(template_key, ".R")
  )

  if (!fs::file_exists(template_path)) {
    cli::cli_abort("Template {.file {template_path}} not found.")
  }

  # --- render template ---------------------------------------------------------
  template_file <- readLines(template_path, warn = FALSE)

  template_data <- c(
    list(
      name = name,
      type = type,
      author = get_author(),
      date = format(Sys.Date(), "%d %b %Y")
    ),
    rlang::list2(...)
  )

  output_file <- whisker::whisker.render(template_file, template_data)
  writeLines(output_file, con = file_path)

  # --- open in editor if requested --------------------------------------------
  if (isTRUE(open)) {
    if (rstudioapi::isAvailable() && rstudioapi::hasFun("navigateToFile")) {
      rstudioapi::navigateToFile(file_path)
    } else {
      utils::file.edit(file_path)
    }
  }

  # --- user feedback -----------------------------------------------------------
  if (isTRUE(print)) {
    cli::cli_alert_success(
      "{stringr::str_to_title(type)} script created at {.file {rel_file_path}}"
    )
  }

  invisible(file_path)
}
