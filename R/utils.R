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

#' Get the table engine for the active project
#'
#' Reads the `TableEngine` field from the project `DESCRIPTION` file and
#' returns it as a string. When the field is absent (e.g. legacy projects),
#' it defaults to `"gt"` for backward compatibility.
#'
#' @return *Character*. `"gt"` or `"flextable"`.
#'
#' @keywords internal
get_table_engine <- function() {
  engine <- desc::desc_get("TableEngine")[[1]]
  if (is.na(engine)) {
    return("gt")
  }
  engine
}

#' Test whether the active project uses a given table engine
#'
#' @return *Logical*. `TRUE` when the project's table engine matches.
#'
#' @keywords internal
is_gt_project <- function() {
  identical(get_table_engine(), "gt")
}

#' @rdname is_gt_project
#' @keywords internal
is_flextable_project <- function() {
  identical(get_table_engine(), "flextable")
}
