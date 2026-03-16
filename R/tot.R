#' Validate the structure of a TOT data frame
#'
#' Checks that a TOT data frame has the required columns, that the `type`
#' column contains only `"table"` or `"figure"`, that `id` and `name` values
#' are unique, and that no required column contains missing values.
#'
#' @param tot_data A data frame (or tibble) to validate.
#'
#' @return Invisibly returns `tot_data` if valid; otherwise aborts with an
#'   informative error message.
#' @keywords internal
validate_tot <- function(tot_data) {
  required_cols <- c("id", "type", "name", "caption")
  valid_types <- c("table", "figure")

  # Check required columns are present
  missing_cols <- setdiff(required_cols, names(tot_data))
  if (length(missing_cols) > 0) {
    cli::cli_abort(
      "The TOT is missing required column{?s}: {.field {missing_cols}}."
    )
  }

  # Check for missing values in required columns
  for (col in required_cols) {
    if (anyNA(tot_data[[col]])) {
      cli::cli_abort(
        "The TOT column {.field {col}} contains missing values."
      )
    }
  }

  # Check that 'type' only contains valid values
  invalid_types <- setdiff(unique(tot_data[["type"]]), valid_types)
  if (length(invalid_types) > 0) {
    cli::cli_abort(
      c(
        "The TOT column {.field type} contains invalid value{?s}: {.val {invalid_types}}.",
        "i" = "Valid values are {.val {valid_types}}."
      )
    )
  }

  # Check that 'id' values are unique
  dup_ids <- tot_data[["id"]][duplicated(tot_data[["id"]])]
  if (length(dup_ids) > 0) {
    cli::cli_abort(
      "The TOT column {.field id} contains duplicate value{?s}: {.val {unique(dup_ids)}}."
    )
  }

  # Check that 'name' values are unique
  dup_names <- tot_data[["name"]][duplicated(tot_data[["name"]])]
  if (length(dup_names) > 0) {
    cli::cli_abort(
      "The TOT column {.field name} contains duplicate value{?s}: {.val {unique(dup_names)}}."
    )
  }

  invisible(tot_data)
}

#' Import the Table of Tables (TOT)
#'
#' Reads the TOT Excel file from `data/tot/table_of_tables.xlsx`, validates its
#' structure, and saves it as an RDS file in `data/tot/tot.rds`.
#'
#' @param quiet Logical. If `TRUE`, suppress informational messages.
#'
#'   *Default*: `FALSE` unless the global option `lbstproj.quiet` is set otherwise. The default option can be changed using `options(lbstproj.quiet = TRUE)`
#'
#' @return Invisibly returns the TOT data as a tibble.
#' @export
import_tot <- function(quiet = FALSE) {
  # Read the TOT Excel file
  tot_xlsx_path <- usethis::proj_path("data/tot/table_of_tables.xlsx")
  if (!fs::file_exists(tot_xlsx_path)) {
    cli::cli_abort(
      "The TOT file does not exist. Please create it using {.fn create_tot}."
    )
  }
  tot_data <- readxl::read_excel(tot_xlsx_path) |>
    tibble::as_tibble()

  # Validate the TOT data structure
  validate_tot(tot_data)

  # Save the TOT data as an RDS file in the project
  tot_path <- fs::path("data/tot/tot.rds")
  saveRDS(tot_data, file = tot_path)

  # Inform the user
  if (!quiet) {
    cli::cli_alert_info(
      "Importing Table of Tables (TOT) to {.file {fs::path_rel(tot_path)}}"
    )
  }

  # Return the TOT data invisibly
  invisible(tot_data)
}

#' Load the Table of Tables (TOT)
#'
#' Simple wrapper function to load the TOT RDS file.
#'
#' @param refresh Logical; if `TRUE`, re-imports the TOT from the Excel file
#'   using `import_tot()`. Default is `TRUE` because the TOT may be updated
#'   frequently.
#'
#' @examples
#' if(FALSE) {
#'  tot <- load_tot()
#' }
#' @return A tibble containing the TOT data with the following columns:
#' - `id`: Unique identifier for each item.
#' - `type`: Type of the item (either "table" or "figure").
#' - `name`: Name of the item.
#' - `caption`: Caption of the item.
#' @export
#' @md
load_tot <- function(refresh = TRUE) {
  tot_path <- usethis::proj_path("data/tot/tot.rds")
  # If refresh is TRUE, re-import the TOT from the Excel file
  if (refresh) {
    tot <- import_tot(quiet = TRUE) # Invisible return of the TOT
  } else {
    if (!fs::file_exists(tot_path)) {
      cli::cli_abort(
        paste(
          "The TOT {.val rds} file does not exist.",
          "Please import it using {.fn import_tot}."
        )
      )
    }
    tot <- readRDS(tot_path)
  }
  return(tot)
}
