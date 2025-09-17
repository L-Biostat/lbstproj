#' Save analysis objects as `.rds`
#'
#' @description
#' A family of helpers that save figures, tables, and data sets as
#' **`.rds`** files via [base::saveRDS()]. Each function writes to its
#' designated output directory.
#'
#' @param object The object to save (figure/table/data). Any R object supported
#'   by [base::saveRDS()].
#' @param name Name used to save the object (without file extension).
#' @inheritParams use_scripts
#' @param ... Additional arguments passed to [base::saveRDS()] (e.g.,
#'   `compress`, `version`).
#'
#' @details
#' These helpers are called for their side effects and do not return a value.
#'
#' @examples
#' \dontrun{
#' # Figures
#' save_figure(plot, "main_effect", compress = "xz")
#'
#' # Tables
#' save_table(tbl, "baseline_summary")
#'
#' # Data (saved to data/processed/)
#' save_data(df, "patients_clean", version = 3)
#' }
#'
#' @seealso [base::saveRDS()]
#' @md
#' @name save_scripts
NULL

#' @describeIn save_scripts Save a data object to `data/processed/`.
#' @export
save_data <- function(object, name, overwrite = FALSE, ...) {
  save_object(type = "data", object, name, overwrite, ...)
}

#' @describeIn save_scripts Save a figure to `data/figures/`.
#' @export
save_figure <- function(object, name, overwrite = FALSE, ...) {
  save_object(type = "figure", object, name, overwrite, ...)
}

#' @describeIn save_scripts Save a table to `data/tables/`.
#' @export
save_table <- function(object, name, overwrite = FALSE, ...) {
  save_object(type = "table", object, name, overwrite, ...)
}

# Internal function to save an R object to the appropriate directory
save_object <- function(type, object, name, overwrite, ...) {
  # Create file path
  dir_name <- ifelse(
    type == "data",
    "processed",
    paste0(type, "s")
  )
  file_path <- fs::path("data", dir_name, name, ext = "rds")
  # Check if file already exists
  check_file_absent(file_path, overwrite = overwrite)
  # Ensure the parent directory exists, create if not
  check_dir_exists(fs::path_dir(file_path))
  # Save the object as an RDS file
  saveRDS(plot, file = file_path, ...)
  # Inform the user
  cli::cli_alert_success(
    "{stringr::str_to_title(type)} saved to {.file {fs::path_rel(file_path)}}"
  )
}
