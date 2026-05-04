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
#' with_example_project({
#'   tot <- load_tot()
#'
#'   # Look up the first entry by id
#'   info <- get_info(id = tot$id[[1]])
#'   cat("Name:", info$name[[1]], "\n")
#'   cat("Caption:", info$caption[[1]], "\n")
#' }, with_tot = TRUE)
get_info <- function(id = NULL, name = NULL) {
  # Ensure either id or name is given, not both
  if (!xor(is.null(id), is.null(name))) {
    cli::cli_abort(
      "Please provide either {.arg id} or {.arg name}, but not both."
    )
  }
  # Load the TOT
  tot <- load_tot()
  # Function to check for no matching entry
  no_entry <- function(x, type, given) {
    if (nrow(x) == 0) {
      cli::cli_abort(
        "No entry found for {.arg {type}} = {given}."
      )
    }
  }
  # Find the matching entry
  if (!is.null(id)) {
    entry <- tot[tot$id == id, ]
    no_entry(entry, "id", id)
  } else {
    entry <- tot[tot$name == name, ]
    no_entry(entry, "name", name)
  }
  # Check that only one entry was found: not needed, TOT should be checked for
  # duplicates when imported.
  as.list(entry)
}
