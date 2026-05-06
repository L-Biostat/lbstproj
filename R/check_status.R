# -------------------------------------------------------------------------
# ┌------------┐
#   lbstproj
# \------------┘
#
# check_status.R:
# Build and display a status table for figures or tables
# -------------------------------------------------------------------------

#' Build a data frame summarising whether each figure/table exists in the TOT,
#' as an R script, and as a saved output.
#'
#' @param type *Character*. Either `"figure"` or `"table"`.
#' @param refresh_tot *Logical*. If `TRUE`, reload the TOT from the source
#'   Excel file before building the status. *Default*: `FALSE`.
#'
#' @return A data frame with one row per item and logical columns indicating
#'   presence in each location (`in_tot`, `in_r`, `in_res`, and, for tables
#'   only, `in_data`).
#'
#' @keywords internal
build_status <- function(type = c("figure", "table"), refresh_tot = FALSE) {
  type <- match.arg(type)

  tot <- load_tot(refresh = refresh_tot)
  tot_items <- tot[tot$type == type, c("id", "name")]

  if (type == "figure") {
    all_dirs <- list(
      in_r = list(dir = "R/figures", glob = "*.R"),
      in_res = list(dir = "results/figures", glob = "*.png")
    )
  } else {
    all_dirs <- list(
      in_r = list(dir = "R/tables", glob = "*.R"),
      in_res = list(dir = "results/tables", glob = "*.docx"),
      in_data = list(dir = "data/tables", glob = "*.rds")
    )
  }

  scan_dir <- function(dir, glob) {
    fs::dir_ls(dir, glob = glob) |>
      fs::path_file() |>
      fs::path_ext_remove()
  }

  scanned <- lapply(all_dirs, \(x) scan_dir(x$dir, x$glob))

  all_names <- unique(c(tot_items$name, unlist(scanned)))

  df <- data.frame(name = all_names)
  df$id <- tot_items$id[match(all_names, tot_items$name)]
  for (col in names(scanned)) {
    df[[col]] <- all_names %in% scanned[[col]]
  }
  df$in_tot <- all_names %in% tot_items$name

  df[c("id", "name", "in_tot", setdiff(names(df), c("id", "name", "in_tot")))]
}

#' Check the status of figures or tables
#'
#' Prints a formatted status table showing whether each figure or table is
#' registered in the TOT, has a corresponding R script, and has been saved
#' as an output file. For tables, presence in the data directory is also
#' checked.
#'
#' @param type *Character*. Either `"figure"` or `"table"`.
#' @param refresh_tot *Logical*. If `TRUE`, reload the TOT from the source
#'   Excel file before building the status.
#'
#'   *Default*: `FALSE`.
#'
#' @return Called for its side effect of printing the status table. Returns
#'   `NULL` invisibly.
#'
#' @examples
#' with_example_project({
#'   # Add a fake R script for a table without a corresponding TOT entry
#'   fs::file_create("R/tables/table_001.R")
#'
#'   # Check status for figures and tables
#'   check_status("figure")
#'   check_status("table")
#' }, with_tot = TRUE)
#'
#' @export
check_status <- function(type = c("figure", "table"), refresh_tot = FALSE) {
  type <- match.arg(type)

  if (type == "figure") {
    col_names <- c("ID", "Name", "In TOT", "In R", "In Results")
  } else {
    col_names <- c("ID", "Name", "In TOT", "In R", "In Results", "In Data")
  }

  df <- build_status(type, refresh_tot = refresh_tot)

  if (nrow(df) == 0) {
    cli::cli_inform("\nNo {type}s found in the TOT or project directories.")
    return(invisible(NULL))
  }

  df <- df |>
    dplyr::mutate(
      dplyr::across(
        dplyr::where(is.logical),
        \(x) ifelse(x, cli::symbol$tick, cli::symbol$line)
      )
    )

  align <- paste0("cl", strrep("c", ncol(df) - 2))
  title <- paste0("# ", tools::toTitleCase(type), "s")

  insight::export_table(
    df,
    column_names = col_names,
    align = align,
    title = c(title, "blue"),
    missing = "?"
  ) |>
    cat()

  invisible(NULL)
}
