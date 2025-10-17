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
  fig_items <- tot$type == "figure"
  # Create figure scripts
  purrr::walk2(
    .x = tot$name[fig_items],
    .y = tot$id[fig_items],
    .f = ~ withr::with_options(
      list(use.print = FALSE),
      use_figure(
        name = .x,
        id = .y,
        overwrite = FALSE,
        open = FALSE
      )
    )
  )
  # List the table-generating R scripts
  tab_items <- tot$type == "table"
  # Create table scripts
  purrr::walk2(
    .x = tot$name[tab_items],
    .y = tot$id[tab_items],
    .f = ~ withr::with_options(
      list(use.print = FALSE),
      use_table(
        name = .x,
        id = .y,
        overwrite = FALSE,
        open = FALSE
      )
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
