# -------------------------------------------------------------------------
# ┌------------┐
#   lbstproj
# \------------┘
#
# checks.R:
# Quick checks for types or values
# -------------------------------------------------------------------------

check_string <- function(x) {
  arg <- deparse(substitute(x))
  if (!rlang::is_string(x)) {
    cli::cli_abort("{.arg {arg}} must be a single character string.")
  }
}

# Validate that a table_engine value is one of the supported engines.
#
# @param table_engine Character. The engine to validate.
# @return Invisibly returns `table_engine` when valid.
# @keywords internal
check_table_engine <- function(table_engine) {
  valid <- c("gt", "flextable")
  if (!rlang::is_string(table_engine) || !table_engine %in% valid) {
    cli::cli_abort(
      c(
        "{.arg table_engine} must be one of {.val {valid}}.",
        "x" = "Got {.val {table_engine}}."
      )
    )
  }
  invisible(table_engine)
}

#' Check that a table object matches the project's table engine
#'
#' Validates that `table` has the class expected by the current project engine:
#' `gt_tbl` for `"gt"` projects and `flextable` for `"flextable"` projects.
#' Throws a clear `cli_abort()` error when the class does not match.
#'
#' @param table The table object to check.
#'
#' @return Invisibly returns `table` when the check passes.
#'
#' @keywords internal
check_table_object <- function(table) {
  engine <- get_table_engine()
  expected_class <- switch(engine, gt = "gt_tbl", flextable = "flextable")
  if (!inherits(table, expected_class)) {
    cli::cli_abort(c(
      "{.arg table} must have class {.cls {expected_class}} for a {.val {engine}} project,",
      "x" = "but has class {.cls {class(table)}}."
    ))
  }
  invisible(table)
}
