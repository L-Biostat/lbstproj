#' Create all R scripts listed in the table of tables (TOT)
#'
#' This function loads the TOT and creates all the R scripts for figures and
#' tables listed there in their respective directories in the `R` folder. Any
#' existing scripts with the same names will NOT be overwritten.
#'
#' @export
create_programs <- function() {
  # Load the table of tables
  tot <- load_tot()

  ## FIGURES
  cli::cli_h2("Figures")
  # List the figure-generating R scripts
  fig_items <- tot$type == "figure"
  # Find those already created
  fig_created <- fs::dir_ls("R/figures") |>
    fs::path_file() |>
    fs::path_ext_remove() |>
    intersect(tot$name[fig_items])
  fig_to_create <- setdiff(tot$name[fig_items], fig_created)
  cli::cli_bullets(
    c(
      "i" = "Found {sum(fig_items)} figure{?s} in the TOT",
      "i" = "{length(fig_created)} already exist{?s} in {.path R/figures/}",
      "i" = "Creating {length(fig_to_create)} new figure script{?s} in {.path R/figures/}"
    )
  )
  # Create figure scripts
  purrr::walk2(
    .x = tot$name[fig_items],
    .y = tot$id[fig_items],
    .f = ~ withr::with_options(
      list(use.print = FALSE),
      create_figure(
        name = .x,
        id = .y,
        overwrite = FALSE,
        open = FALSE
      )
    )
  )

  ## TABLES
  cli::cli_h2("Tables")
  # List the table-generating R scripts
  tab_items <- tot$type == "table"
  # Find those already created
  tab_created <- fs::dir_ls("R/tables") |>
    fs::path_file() |>
    fs::path_ext_remove() |>
    intersect(tot$name[tab_items])
  tab_to_create <- setdiff(tot$name[tab_items], tab_created)
  cli::cli_bullets(
    c(
      "i" = "Found {sum(tab_items)} table{?s} in the TOT",
      "i" = "{length(tab_created)} already exist{?s} in {.path R/tables/}",
      "i" = "Creating {length(tab_to_create)} new table script{?s} in {.path R/tables/}"
    )
  )
  # Create table scripts
  purrr::walk2(
    .x = tot$name[tab_items],
    .y = tot$id[tab_items],
    .f = ~ withr::with_options(
      list(use.print = FALSE),
      create_table(
        name = .x,
        id = .y,
        overwrite = FALSE,
        open = FALSE
      )
    )
  )
}
