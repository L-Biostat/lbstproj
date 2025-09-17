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

check_dir_exists <- function(dir) {
  # If dir does not exist, create it and warn user
  if (!fs::dir_exists(dir)) {
    fs::dir_create(dir)
    cli::cli_alert_warning("Directory created at {.file {fs::path_rel(dir)}}")
  }
}

check_file_absent <- function(file_path, overwrite) {
  if (overwrite) {
    return()
  } else if (fs::file_exists(file_path)) {
    cli::cli_abort(
      c(
        "x" = "File {.file {file_path}} already exists.",
        "i" = "To overwrite the file, set {.code overwrite = TRUE}."
      )
    )
  }
}

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
