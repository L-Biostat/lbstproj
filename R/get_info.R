#' Get Information About an Item by ID
#'
#' Retrieve information about an item from a table of tables (TOT) based on its
#' ID.
#'
#' @param id A positive integer representing the unique identifier of the item.
#'   Must be supplied, else the function will throw an error.
#'
#' @return A list containing all columns from the TOT for the specified ID. The
#'   columns are (in order): id, type, name, caption
#'
#' @examples
#' \dontrun{
#'  info <- get_info(1)
#'  print(info$caption) # Access the caption of the item
#' }
#' @export
get_info <- function(id) {
  # Check that ID is a positive integer
  rlang::check_required(id)
  if (!is.numeric(id) || id <= 0 || id != as.integer(id)) {
    cli::cli_abort("{.arg id} must be a positive integer.")
  }

  # Load the table of tables (TOT)
  tot <- load_tot()
  # Check that the ID exists in the TOT
  if (!id %in% tot$id) {
    cli::cli_abort(
      c(
        "x" = "No entry with id {.val {id}} found in the TOT.",
        "i" = "Update the TOT and import it again using {.fn import_tot}."
      )
    )
  }

  # Return the row corresponding to the ID as a list
  tot_row <- tot[tot$id == id, ]
  as.list(tot_row)
}
