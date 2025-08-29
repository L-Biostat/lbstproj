use_data_raw <- function(name = "dataset", open = rlang::is_interactive(), overwrite = FALSE, quiet = FALSE) {
  # Check the name
  usethis:::check_name(name)
  # Create file path
  file_path <- fs::path("data", "raw", sanitize_name(name), ext = "R")
  # Create directory if it doesn't exist
  usethis::use_directory("data/raw", ignore = FALSE)
  # Create the file based on the template
  usethis::use_template(
    template = "data.R",
    package = "lbstproj",
    save_as = file_path,
    data = list(
      name = name,
      date = format(Sys.Date(), "%d %b %Y"),
      author = get_author()
    ),
    ignore = FALSE,
    open = open
  )
}

get_author <- function() {
  sub("\\s*<.*", "", desc::desc_get_author())
}

sanitize_name <- function(name) {
  usethis:::check_character(name)
  gsub("[^a-zA-Z0-9_]+", "_", name)
}
