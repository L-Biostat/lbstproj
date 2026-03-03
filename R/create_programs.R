#' Create all R scripts listed in the table of tables (TOT)
#'
#' This function loads the TOT and creates all the R scripts for figures and
#' tables listed there in their respective directories in the `R` folder. Any
#' existing scripts with the same names will NOT be overwritten.
#'
#' @param dry_run Logical. If `TRUE`, no files are created and the function only
#'   reports what would be generated. Defaults to `TRUE`.
#' @param print Logical. If `TRUE`, prints a report to the CLI about the
#'   synchronization status between TOT and disk, and about the new file
#'   created. Value taken from the global option `use.print` (which defaults to
#'   `TRUE`).
#'
#' @return Invisibly returns `NULL`. The function is called for its side effects
#'   (file creation and CLI reporting).
#'
#' @examples
#' \dontrun{
#' # Hypothetical project structure:
#' # R/
#' # ├── figures/
#' # │   └── fig_01_flowchart.R
#' # └── tables/
#' #     └── tab_01_baseline.R
#'
#' # TOT contains:
#' #   - fig_01_flowchart
#' #   - fig_02_primary
#' #   - tab_01_baseline
#' #   - tab_02_primary
#'
#' # Dry run (no files created)
#' create_programs()
#'
#' # Example CLI output:
#' #
#' # Figures
#' # ℹ Figures: 2 in TOT, 1 on disk, 1 matched.
#' # ℹ Figures: would generate 1 missing program (keeping 1 existing).
#' # ℹ Figures: would create 1 program in R/figures.
#' # • R/figures/fig_02_primary.R
#' #
#' # Tables
#' # ℹ Tables: 2 in TOT, 1 on disk, 1 matched.
#' # ℹ Tables: would generate 1 missing program (keeping 1 existing).
#' # ℹ Tables: would create 1 program in R/tables.
#' # • R/tables/tab_02_primary.R
#'
#' # Actual creation
#' create_programs(dry_run = FALSE)
#' }
#'
#' @export
create_programs <- function(dry_run = TRUE, print = TRUE) {
  tot <- load_tot()

  specs <- list(
    figures = list(
      tot_type = "figure",
      dir = "R/figures"
    ),
    tables = list(
      tot_type = "table",
      dir = "R/tables"
    )
  )

  for (type in names(specs)) {
    s <- specs[[type]]

    items <- tot$type == s$tot_type

    disk <- character()
    if (fs::dir_exists(s$dir)) {
      disk <- fs::dir_ls(s$dir, type = "file", glob = "*.R")
    }

    expected <- fs::path(s$dir, tot$name[items], ext = "R")

    created <- intersect(disk, expected)
    to_create <- setdiff(expected, created)
    extra <- setdiff(disk, expected)

    if (print) {
      cli_report_program(
        type = type,
        n_tot = sum(items),
        n_disk = length(disk),
        matched = fs::path_file(created),
        new = fs::path_file(to_create),
        extra = fs::path_file(extra),
        dry_run = dry_run
      )
    }

    if (!dry_run) {
      # Create scripts (won't overwrite)
      purrr::walk2(
        .x = tot$name[items],
        .y = tot$id[items],
        # Always generate files with `use.print = FALSE` to avoid printing
        # messages from `create_figure()` and `create_table()`
        .f = ~ create_file(
          type = s$tot_type,
          name = .x,
          open = FALSE,
          print = FALSE,
          id = .y
        )
      )
    }
  }

  invisible(NULL)
}
