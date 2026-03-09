#' Package-wide options for lbstproj
#'
#' `lbstproj` exposes one global option that controls whether informational
#' messages are printed by package functions.
#'
#' @section Options:
#'
#' * **`lbstproj.quiet`** (`logical`, default `FALSE`) — When `TRUE`,
#'   suppresses all informational messages (e.g. "Saved to …", "Importing
#'   TOT …") across every function in the package.
#'
#'   Individual functions also accept a `quiet` argument that overrides this
#'   option for a single call.
#'
#' @section Usage:
#'
#' Silence messages for an entire session:
#' ```r
#' options(lbstproj.quiet = TRUE)
#' ```
#'
#' Restore the default (verbose) behaviour:
#' ```r
#' options(lbstproj.quiet = FALSE)
#' ```
#'
#' Override the option for a single call:
#' ```r
#' save_figure(fig, name = "my-fig", quiet = TRUE)   # silent
#' save_figure(fig, name = "my-fig", quiet = FALSE)  # verbose
#' ```
#'
#' @name lbstproj-options
NULL
