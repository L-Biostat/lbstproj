#' Create all R scripts listed in the table of tables (TOT)
#'
#' This functions loads the TOT and creates all the R scripts for figures and tables
#' listed there in their respective directories in the `R` folder.
#' Any existing scripts with the same names will NOT be overwritten.
#'
#' @export
create_programs <- function() {
  # Load the table of tables
  tot <- load_tot()
  # List the figure-generating R scripts
  fig_scripts <- tot$name[tot$type == "figure"]
  # Create figure scripts
  purrr::walk(
    .x = fig_scripts,
    .f = ~ withr::with_options(
      list(use.print = FALSE),
      use_figure(.x, overwrite = FALSE, open = FALSE)
    )
  )
  # List the table-generating R scripts
  tab_scripts <- tot$name[tot$type == "table"]
  # Create table scripts
  purrr::walk(
    .x = tab_scripts,
    .f = ~ withr::with_options(
      list(use.print = FALSE),
      use_table(.x, overwrite = FALSE, open = FALSE)
    )
  )
  # Inform the user
  cli::cli_bullets(
    c(
      "i" = "Creating {length(fig_scripts)} figure script{?s} in {.path R/figures/}",
      "i" = "Creating {length(tab_scripts)} table script{?s} in {.path R/tables/}"
    )
  )
}
