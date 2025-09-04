# Public functions to save data, tables, and figures ----

#' Save an R object
#'
#' These functions save R objects to the appropriate directories within the project
#' structure, ensuring that they exist. All objects are saved as `.rds` files to be easily
#' loaded later.
#'
#' @details
#' Each function saves the object to a specific directory:
#' * `save_data()` to `data/processed/`.
#' * `save_table()` to `data/tables/`.
#' * `save_figure()` to `data/figures/`.
#'
#' @param x The object (data, table, figure) to be saved.
#' @param name A name for the object. Should only contain letters, numbers, and underscores.
#' @param overwrite By default, all the `save_*` functions will not overwrite
#'   existing files. Set to `TRUE` if you really want to do so.
#' @param quiet If `TRUE`, suppresses messages about the saving process. Defaults to `FALSE`.
#'
#' @md
#' @export
#' @examples
#' \dontrun{
#' # Example of saving a data frame
#' df <- data.frame(x = 1:10, y = rnorm(10))
#' save_data(df, "my_dataset")
#' }
save_data <- function(x, name, overwrite = FALSE, quiet = FALSE, ...) {
  save_skeleton(
    x,
    name = name,
    type = "data",
    overwrite = overwrite,
    quiet = quiet,
    ...
  )
}

#' @rdname save_data
#' @export
save_table <- function(x, name, overwrite = FALSE, quiet = FALSE, ...) {
  save_skeleton(
    x,
    name = name,
    type = "table",
    overwrite = overwrite,
    quiet = quiet,
    ...
  )
}

#' @rdname save_data
#' @export
save_figure <- function(x, name, overwrite = FALSE, quiet = FALSE, ...) {
  save_skeleton(
    x,
    name = name,
    type = "figure",
    overwrite = overwrite,
    quiet = quiet,
    ...
  )
}

# Skeleton function to save any object to the appropriate directory ----

save_skeleton <- function(
  x,
  name,
  type,
  overwrite,
  quiet,
  ...
) {
  # Check the type validity
  valid_types <- c("figure", "table", "data")
  if (!type %in% valid_types) {
    cli::cli_abort(
      c(
        "x" = "Unknown type {.val {type}}.",
        "i" = "Supported types are {.val {valid_types}}."
      )
    )
  }
  # Check the name validity
  usethis:::check_name(name)

  # Ensure output directory exists
  new_type <- ifelse(type == "data", "processed", paste0(type, "s"))
  out_dir <- fs::path("data", new_type)
  create_directory(out_dir, quiet = quiet)

  # Create the file path
  file_path <- fs::path(out_dir, .sanitize_name(name), ext = "rds")
  # Check if file already exists
  usethis:::check_files_absent(file_path, overwrite = overwrite)

  # Save the object
  saveRDS(x, file = file_path, ...)
  # Inform the user
  if (!quiet) {
    cli::cli_alert_success("Saving {.val {name}} to {.path {file_path}}.")
  }
}
