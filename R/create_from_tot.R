# -------------------------------------------------------------------------
# ┌------------┐
#   lbstproj
# \------------┘
#
# create_from_tot.R:
# Create all R scripts listed in the table of tables (TOT)
# -------------------------------------------------------------------------

#' Create all R scripts listed in the table of tables (TOT)
#'
#' This function loads the TOT and creates all the R scripts for figures and
#' tables listed there in their respective directories in the `R` folder. Any
#' existing scripts with the same names will NOT be overwritten.
#'
#' @param dry_run *Logical*. If `TRUE`, no files are created and the function only
#'   reports what would be generated.
#'
#'   *Default*: `TRUE` to avoid generate wrong scripts by mistake.
#'
#' @param quiet Logical. If `TRUE`, suppress informational messages.
#'
#'   *Default*: `FALSE` unless the global option `lbstproj.quiet` is set otherwise. The default option can be changed
#'
#' @return Invisibly returns `NULL`. The function is called for its side effects
#'   (file creation and CLI reporting).
#'
#' @examples
#' with_example_project({
#'   # Dry run (default): reports what would be created without writing files
#'   create_from_tot()
#'
#'   # Actually create the scripts
#'   create_from_tot(dry_run = FALSE, quiet = TRUE)
#'   fs::dir_tree("R")
#' }, with_tot = TRUE)
#'
#' @export
create_from_tot <- function(
  dry_run = TRUE,
  quiet = getOption("lbstproj.quiet", FALSE)
) {
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
    entries <- data.frame(
      id = tot$id[items],
      name = tot$name[items],
      path = fs::path(s$dir, tot$name[items], ext = "R")
    )

    disk <- character()
    if (fs::dir_exists(s$dir)) {
      disk <- fs::dir_ls(s$dir, type = "file", glob = "*.R")
    }

    created <- entries[entries$path %in% disk, ]
    to_create <- entries[!entries$path %in% disk, ]
    extra <- setdiff(disk, entries$path)

    if (isFALSE(quiet)) {
      cli_report_program(
        type = type,
        n_tot = sum(items),
        n_disk = length(disk),
        matched = fs::path_file(created$path),
        new = fs::path_file(to_create$path),
        extra = fs::path_file(extra),
        dry_run = dry_run
      )
      # If this is a dry-run, let the user know
      if (isTRUE(dry_run)) {
        cli::cli_alert_info(
          c(
            "{.strong Dry run only: no files were generated.}\n",
            "To actually generate files, run {.fn create_from_tot} with {.arg dry_run = FALSE}."
          )
        )
      }
    }

    if (isFALSE(dry_run)) {
      # Create scripts (won't overwrite)
      invisible(Map(
        # Always generate files with quiet = TRUE to avoid printing
        # messages from create_figure() and create_table()
        function(x, y) {
          create_file(
            type = s$tot_type,
            name = x,
            open = FALSE,
            quiet = TRUE,
            id = y
          )
        },
        to_create$name,
        to_create$id
      ))
    }
  }

  invisible(NULL)
}


#' CLI report for create_programs() sync step
#'
#' @param type One of "tables" or "figures".
#' @param n_tot Number of programs declared in TOT.
#' @param n_disk Number of .R files found on disk.
#' @param matched Character vector of filenames both in TOT and on disk.
#' @param new Character vector of filenames to create.
#' @param extra Character vector of filenames on disk but not in TOT.
#' @param dry_run Logical.
#'
#' @keywords internal
#'
#' @return Invisibly returns a list with counts.
cli_report_program <- function(
  type,
  n_tot,
  n_disk,
  matched = character(),
  new = character(),
  extra = character(),
  dry_run = FALSE
) {
  type <- match.arg(type, c("tables", "figures"))

  label <- c(tables = "Tables", figures = "Figures")[[type]]
  dir_ <- c(tables = "R/tables", figures = "R/figures")[[type]]

  matched <- sort(as.character(matched))
  new <- sort(as.character(new))
  extra <- sort(as.character(extra))

  n_tot <- as.integer(n_tot)
  n_disk <- as.integer(n_disk)
  n_match <- length(matched)
  n_new <- length(new)
  n_extra <- length(extra)

  cli::cli_h2(label)
  cli::cli_alert_info(
    "{label}: {n_tot} in TOT, {n_disk} on disk, {n_match} matched."
  )

  if (n_new == 0) {
    if (n_tot == 0) {
      cli::cli_alert_info("{label}: none declared in TOT - nothing to do.")
    } else {
      cli::cli_alert_success(
        "{label}: all programs already exist - nothing to generate."
      )
    }
  } else {
    cli::cli_alert_info(
      "{label}: {if (dry_run) 'would generate' else 'generating'} {n_new} missing program{?s}."
    )

    cli::cli_alert(
      "{label}: {if (dry_run) 'would create' else 'created'} {n_new} program{?s} in {.path {dir_}}."
    )

    cli::cli_bullets(
      stats::setNames(
        paste0("{.file ", fs::path(dir_, new), "}"),
        rep("*", n_new)
      )
    )
  }

  if (n_extra > 0) {
    extra_vec <- cli::ansi_collapse(extra, trunc = 2, style = "head")
    cli::cli_alert_warning(
      "{label}: {n_extra} extra program{?s} on disk (not in TOT): {extra_vec}"
    )
  }

  invisible(list(
    type = type,
    n_tot = n_tot,
    n_disk = n_disk,
    n_match = n_match,
    n_new = n_new,
    n_extra = n_extra
  ))
}
