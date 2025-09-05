# Check object classes -----------------------------------------------------------

check_tbl_class <- function(x) {
  allowed_classes <- c("gt_tbl", "flextable")
  if (!inherits(x, allowed_classes)) {
    cli::cli_abort(
      c(
        "x" = "Unsupported table class {.val {class(x)[1]}} for object {.arg x}.",
        "i" = "Supported classes {?is/are} {.val {allowed_classes}}."
      )
    )
  }
}

check_fig_class <- function(x) {
  allowed_classes <- c("ggplot")
  if (!inherits(x, allowed_classes)) {
    cli::cli_abort(
      c(
        "x" = "Unsupported figure class {.val {class(x)[1]}} for object {.arg x}.",
        "i" = "Supported class{?es} {?is/are} {.val {allowed_classes}}."
      )
    )
  }
}


# Check format based on type -----------------------------------------------------

check_format <- function(format, type) {
  usethis:::check_character(format)
  usethis:::check_character(type)
  if (!type %in% c("figure", "table")) {
    cli::cli_abort(
      c(
        "x" = "Unknown type {.val {type}}.",
        "i" = "Supported types are {.val figure} and {.val table}."
      )
    )
  }
  valid_formats <- switch(
    type,
    figure = c("png", "pdf", "jpeg", "tiff", "bmp", "svg"),
    table = c("docx", "html")
  )

  if (!format %in% valid_formats) {
    cli::cli_abort(
      c(
        "x" = "Unsupported format {.val {format}} for type {.val {type}}.",
        "i" = "Supported {.val {type}} formats are {.val {valid_formats}}."
      )
    )
  }
}


# Check directories and files ----------------------------------------------------

check_dir_present <- function(dir, quiet = FALSE) {
  usethis:::check_character(dir)
  # If dir does not exist, create it and warn user
  if (!dir.exists(dir)) {
    if (!quiet) {
      cli::cli_alert_info("Creating directory {.path {dir}}.")
    }
    dir.create(dir, recursive = TRUE)
  }
}

check_files_absent <- usethis:::check_files_absent

# Check object names -------------------------------------------------------------

check_name <- function(name) {
  usethis:::check_character(name)
  usethis:::check_name(name)
  new_name <- gsub("[^a-zA-Z0-9_]+", "_", name)
  if (new_name != name) {
    cli::cli_warn(
      c(
        "!" = "The name {.val {name}} has been sanitized to {.val {new_name}}.",
        "i" = "Only alphanumeric characters and underscores are allowed. Change the name to remove this error."
      )
    )
  }
  return(new_name)
}
