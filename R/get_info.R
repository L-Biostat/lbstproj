#' Get information from the Table of Tables (TOT)
#'
#' Retrieves a single TOT entry identified by either its unique `id` or
#' its unique `name`. The TOT is loaded with [load_tot()].
#'
#' @param id *Character* A single TOT identifier (character or numeric). Provide
#'   *either* `.arg id` or `.arg name`, but not both.
#' @param name *Character*. A single TOT name (character). Provide *either*
#'   `.arg name` or `.arg id`, but not both.
#'
#' @return A named list containing the columns of the matched TOT row.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # By id
#' info <- get_info(id = "T001")
#'
#' # By name
#' info <- get_info(name = "baseline_table")
#'
#' # Access a field
#' info$caption
#' }
get_info <- function(id = NULL, name = NULL) {
  # Ensure either id or name is given, not both
  if (!xor(is.null(id), is.null(name))) {
    cli::cli_abort(
      "Please provide either {.arg id} or {.arg name}, but not both."
    )
  }
  # TODO: validate entries once the TOT structure is decided

  # Load the TOT
  tot <- load_tot()

  # Function to check for no matching entry
  no_entry <- function(x, type) {
    if (nrow(entry) == 0) {
      cli::cli_abort(
        "No entry found for {.arg {type}} = {x}."
      )
    }
  }

  # Find the matching entry
  if (!is.null(id)) {
    entry <- tot[tot$id == id, ]
    no_entry(entry, "id")
  } else {
    entry <- tot[tot$name == name, ]
    no_entry(entry, "name")
  }
  # Check that only one entry was found: not needed, TOT should be checked for
  # duplicates when imported.
  as.list(entry)
}
