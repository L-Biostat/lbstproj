# -------------------------------------------------------------------------
# ┌------------┐
#   lbstproj
# \------------┘
#
# utils.R:
# small utility helpers
# -------------------------------------------------------------------------

get_author <- function() {
  author <- desc::desc_get_author(role = "cre")
  # If family name is missing, return the whole name
  if (is.null(author$family)) {
    return(author$given)
  } else {
    return(paste(author$given, author$family))
  }
}

#' Get the table engine configured for the project
#'
#' `get_table_engine()` reads the `TableEngine` field from the active project's
#' `DESCRIPTION` file and returns its value. If the field is absent (e.g. in
#' legacy projects), it returns `"gt"` silently for backwards compatibility.
#'
#' @return A single character string: `"gt"` or `"flextable"`.
#' @seealso [is_gt_project()], [is_flextable_project()]
#' @export
#' @examples
#' if (FALSE) {
#'   get_table_engine()
#' }
get_table_engine <- function() {
  engine <- desc::desc_get_field("TableEngine", default = "gt")
  return(engine)
}

#' Check whether the project uses the gt table engine
#'
#' @return `TRUE` if the project's `TableEngine` is `"gt"`, `FALSE` otherwise.
#' @seealso [get_table_engine()], [is_flextable_project()]
#' @export
#' @examples
#' if (FALSE) {
#'   is_gt_project()
#' }
is_gt_project <- function() {
  get_table_engine() == "gt"
}

#' Check whether the project uses the flextable table engine
#'
#' @return `TRUE` if the project's `TableEngine` is `"flextable"`, `FALSE`
#'   otherwise.
#' @seealso [get_table_engine()], [is_gt_project()]
#' @export
#' @examples
#' if (FALSE) {
#'   is_flextable_project()
#' }
is_flextable_project <- function() {
  get_table_engine() == "flextable"
}
