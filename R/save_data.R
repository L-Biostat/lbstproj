# -------------------------------------------------------------------------
# ┌────────────┐
# │  lbstproj  │
# └────────────┘
#
# save_data.R:
# Save a processed dataset to the project
# -------------------------------------------------------------------------

#' Save a processed dataset to the project
#'
#' This function saves a `data.frame` as an `.rds` file in the `data/processed/`
#' folder of the project. If the folder does not exists, it will be created. The
#' file name is validated to ensure that it only contains letters, numbers, and
#' hyphens.
#'
#' @param data *A `data.frame` object*. The data to be saved.
#' @param name *Character*. File name (without extension). Must only contain
#'   letters, numbers, and hyphens
#' @param overwrite *Logical*. If `TRUE`, overwrite existing file with the same
#'   name. If `FALSE`, an error is thrown if a file with the same name already
#'   exists.
#'
#'   *Default*: `TRUE`
#' @param quiet *Logical*. If `TRUE`, suppress informational message for file
#'   saving.
#'
#'   *Default*: `TRUE` unless the global option `lbstproj.quiet` is set
#'   otherwise.
#'
save_data <- function(
  data,
  name,
  overwrite = TRUE,
  quiet = getOption("lbstproj.quiet", FALSE)
) {
  # Ensure `data` is a data.frame
  if (!inherits(data, "data.frame")) {
    cli::cli_abort(
      "{.arg data} must have class {.cls data.frame}, but has class {.cls {class(data)}}."
    )
  }
  # Validate the name
  name <- validate_file_name(name)
  # Ensures the data directory exists
  ensure_dir_exists("data/processed", create = TRUE)
  # Check if file exists and handle overwrite logic
  file_path <- fs::path("data", "processed", name, ext = "rds")
  if (fs::file_exists(file_path) && !overwrite) {
    cli::cli_abort(
      "File {.file {file_path}} already exists and {.arg overwrite} is set to {.val FALSE}."
    )
  }
  # Save the data frame as an RDS file
  saveRDS(data, file = file_path)
  # Inform user
  if (!quiet) {
    data_name <- deparse(substitute(data))
    cli::cli_alert_success(
      "Data {.val {data_name}} saved to {.file {file_path}}."
    )
  }
  invisible(file_path)
}
