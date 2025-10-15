#' Create a Empty Table of Tables (TOT) Excel file in the project
#'
#' This function copies a template TOT Excel file from the `lbstproj` package
#' to the `data/tot/` directory of your project. The example TOT file contains
#' an example row for guidance. It should be deleted before use.
#'
#' @inheritParams use_data
#' @md
create_tot <- function(path, overwrite = FALSE) {
  # Find the path to the TOT excel file example in the `lbstproj` package
  tot_example_path <- fs::path_package(
    package = "lbstproj",
    "extdata/table_of_tables.xlsx"
  )

  # Check that the `data/tot/` directory exists; if not, create it
  tot_dir <- fs::path(path, "data/tot/")
  check_dir_exists(tot_dir)

  # Check if the TOT file already exists
  tot_xlsx_path <- fs::path(tot_dir, "table_of_tables.xlsx")
  check_file_absent(tot_xlsx_path, overwrite)

  # Copy the example TOT file to the project
  fs::file_copy(
    path = tot_example_path,
    new_path = tot_dir,
    overwrite = overwrite
  )

  # Inform the user
  cli::cli_alert_success(
    "Template TOT Excel file created at {.file {tot_xlsx_path}}"
  )
}


#' Import the Table of Tables (TOT)
#'
#' Reads the TOT Excel file from `data/tot/table_of_tables.xlsx`, validates its structure,
#' and saves it as an RDS file in `data/tot/tot.rds`.
#'
#' @return Invisibly returns the TOT data as a tibble.
#' @export
import_tot <- function(quiet = FALSE) {
  # Read the TOT Excel file
  tot_xlsx_path <- fs::path("data/tot/table_of_tables.xlsx")
  if (!fs::file_exists(tot_xlsx_path)) {
    cli::cli_abort(
      "The TOT file does not exist. Please create it using {.fn create_tot}."
    )
  }
  tot_data <- readxl::read_excel(tot_xlsx_path) |>
    tibble::as_tibble()
  # Remove the `comments` column if it exists
  tot_data <- tot_data |>
    dplyr::select(-dplyr::any_of("comment"))

  # TODO: Add validation of the TOT data structures

  # Save the TOT data as an RDS file in the project
  tot_path <- fs::path("data/tot/tot.rds")
  check_file_absent(tot_path, overwrite = TRUE) # Always overwrite the existing TOT RDS file
  saveRDS(tot_data, file = tot_path)

  # Inform the user
  if (!quiet) {
    cli::cli_alert_success(
      "Table of tables (TOT) imported and saved to {.file {fs::path_rel(tot_path)}}"
    )
  }

  # Return the TOT data invisibly
  invisible(tot_data)
}

#' Load the Table of Tables (TOT)
#'
#' Simple wrapper function to load the TOT RDS file.
#'
#' @param refresh Logical; if `TRUE`, re-imports the TOT from the Excel file using `import_tot()`. Default is `TRUE` because the TOT may be updated frequently.
#'
#' @examples
#' \dontrun{
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
  tot_path <- fs::path("data/tot/tot.rds")
  if (!fs::file_exists(tot_path)) {
    cli::cli_abort(
      "The TOT {.val rds} file does not exist. Please import it using {.fn import_tot}."
    )
  }
  # If refresh is TRUE, re-import the TOT from the Excel file
  if (refresh) {
    tot <- import_tot(quiet = TRUE) # Invisible return of the TOT
  } else {
    tot <- readRDS(tot_path)
  }
  return(tot)
}
