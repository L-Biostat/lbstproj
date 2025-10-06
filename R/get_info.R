#' Get Information About an Item by ID
#'
#' Retrieves detailed information about an item from a table of tables (TOT) based on its ID.
#'
#' @param id A positive integer representing the unique identifier of the item.
#'
#' @return A list containing all columns from the TOT for the specified ID. The columns are (in order): id, type, name, caption
#'
#' @examples
#' \dontrun{
#'  inf <- get_info(1)
#'  print(inf$caption) # Access the caption of the item
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
        "x" = "ID {.val {id}} not found in the Table of Tables (TOT).",
        "i" = "Update the TOT and import it again using {.fn import_tot}."
      )
    )
  }

  # Return the row corresponding to the ID as a list
  tot_row <- tot[tot$id == id, ]
  as.list(tot_row)
}
