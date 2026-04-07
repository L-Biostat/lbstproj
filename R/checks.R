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

check_table_engine <- function(engine) {
  arg <- deparse(substitute(engine))
  valid_engines <- c("gt", "flextable")
  if (!(engine %in% valid_engines)) {
    cli::cli_abort(
      "{.arg {arg}} must be one of {.val gt} or {.val flextable}, not {.val {engine}}."
    )
  }
}
