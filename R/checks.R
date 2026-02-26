# -------------------------------------------------------------------------
# ┌────────────┐
# │  lbstproj  │
# └────────────┘
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
