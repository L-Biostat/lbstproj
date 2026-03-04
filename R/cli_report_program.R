#' CLI report for create_programs() sync step
#'
#' @param type One of "tables" or "figures".
#' @param n_tot Number of programs declared in TOT.
#' @param n_disk Number of .R files found on disk.
#' @param matched Character vector of filenames both in TOT and on disk.
#' @param new Character vector of filenames to create.
#' @param extra Character vector of filenames on disk but not in TOT.
#' @param dry_run Logical.
#' @param max_print Integer. Max number of filenames to print.
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
  # ---- Validation ----

  if (!rlang::is_string(type)) {
    cli::cli_abort("`type` must be a single string.")
  }

  type <- tolower(type)

  if (!type %in% c("tables", "figures")) {
    cli::cli_abort("`type` must be one of {.val tables} or {.val figures}.")
  }

  if (!rlang::is_integerish(n_tot, n = 1) || n_tot < 0) {
    cli::cli_abort("`n_tot` must be a single non-negative integer.")
  }

  if (!rlang::is_integerish(n_disk, n = 1) || n_disk < 0) {
    cli::cli_abort("`n_disk` must be a single non-negative integer.")
  }

  if (!is.character(matched)) {
    cli::cli_abort("`matched` must be a character vector.")
  }

  if (!is.character(new)) {
    cli::cli_abort("`new` must be a character vector.")
  }

  if (!is.character(extra)) {
    cli::cli_abort("`extra` must be a character vector.")
  }

  if (!rlang::is_bool(dry_run)) {
    cli::cli_abort("`dry_run` must be TRUE or FALSE.")
  }

  # ---- Coerce ----

  n_tot <- as.integer(n_tot)
  n_disk <- as.integer(n_disk)

  matched <- sort(as.character(matched))
  new <- sort(as.character(new))
  extra <- sort(as.character(extra))

  n_match <- length(matched)
  n_new <- length(new)
  n_extra <- length(extra)

  # Check that n_match is lower or equal to both n_tot and n_disk
  if (n_match > n_tot | n_match > n_disk) {
    cli::cli_abort("`n_match` cannot be greater than `n_tot` or `n_disk`.")
  }

  # Same with n_new
  if (n_new > n_tot) {
    cli::cli_abort("`n_new` cannot be greater than `n_tot`.")
  }

  label <- if (type == "tables") "Tables" else "Figures"
  dir_ <- if (type == "tables") "R/tables" else "R/figures"

  # ---- Header ----

  cli::cli_h2(label)
  cli::cli_alert_info(
    "{label}: {n_tot} in TOT, {n_disk} on disk, {n_match} matched."
  )

  inform_extras <- function() {
    # If there are no extras, we can skip the rest of this function
    if (n_extra == 0) return(invisible(NULL))

    extra_vec <- cli::ansi_collapse(
      # fs::path(dir_, extra),
      extra,
      trunc = 2,
      style = "head"
    )
    cli::cli_alert_warning(
      "{label}: {n_extra} extra program{?s} on disk (not in TOT): {extra_vec}"
    )

    invisible(NULL)
  }

  print_new <- function() {
    # If there are no new files, we can skip the rest of this function
    if (length(new) == 0) return(invisible(NULL))

    bullets <- setNames(
      paste0("{.file ", fs::path(dir_, new), "}"), # File paths
      rep("*", length(new)) # Bullet style (asterisk for each new file)
    )

    cli::cli_bullets(bullets)

    invisible(NULL)
  }

  # ---- Conditional logic ----

  if (n_new == 0) {
    if (n_tot == 0) {
      cli::cli_alert_info("{label}: none declared in TOT - nothing to do.")
    } else {
      cli::cli_alert_success(
        "{label}: all programs already exist - nothing to generate."
      )
    }

    inform_extras()
  } else if (n_match > 0) {
    cli::cli_alert_info(
      "{label}: {if (dry_run) 'would generate' else 'generating'} {n_new} missing program{?s} (keeping {n_match} existing)."
    )

    if (dry_run) {
      cli::cli_alert_info(
        "{label}: would create {n_new} program{?s} in {.path {dir_}}."
      )
    } else {
      cli::cli_alert_success(
        "{label}: created {n_new} program{?s} in {.path {dir_}}."
      )
    }

    print_new()
    inform_extras()
  } else {
    cli::cli_alert_info(
      "{label}: no existing programs matched TOT - {if (dry_run) 'would generate' else 'generating'} all {n_new}."
    )

    if (n_disk > 0) {
      cli::cli_alert_warning(
        "{label}: found {n_disk} program{?s} on disk but none match TOT names."
      )
    }

    if (dry_run) {
      cli::cli_alert_info(
        "{label}: would create {n_new} program{?s} in {.path {dir_}}."
      )
    } else {
      cli::cli_alert_success(
        "{label}: created {n_new} program{?s} in {.path {dir_}}."
      )
    }

    print_new()
    inform_extras()
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
