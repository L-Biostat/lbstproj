#' Create a new project with standard structure
#'
#' Sets up a new project at the specified path, including a predefined
#' directory structure and a `DESCRIPTION` file containing metadata such
#' as title, client, department, author, and version.
#'
#' @details
#' The following directory structure is created inside the project:
#'
#' ```
#' ├── data
#' │   ├── processed
#' │   ├── raw
#' │   └── tables
#' ├── inst
#' ├── docs
#' ├── output
#' │   ├── figures
#' │   └── tables
#' ├── R
#' │   ├── data
#' │   ├── figures
#' │   └── tables
#' └── report
#' ```
#'
#' @param title Title of the project.
#' @param client Name of the client.
#' @param department Department code or name.
#' @param author Author name (first and last).
#' @param version Project version (default is `1.0`).
#' @param path Path where the project should be created (default is current directory).
#'
#' @return Invisibly returns the active project path.
#' @md
#' @export
#'
#' @examples
#' \dontrun{
#' create_project(
#'   title = "Example Project",
#'   client = "Client Name",
#'   department = "DEP",
#'   author = "Jane Doe",
#'   version = 0.1,
#'   path = "." # uses current directory
#' )
#' }
create_project <- function(
  title,
  client,
  department,
  author,
  version = 1.0,
  path = "."
) {
  # Check if the path exists
  full_path <- fs::path_abs(path)
  if (!fs::dir_exists(path)) {
    cli::cli_abort("The specified path {.path {full_path}} does not exist.")
  }
  # Create project at specified path
  usethis::ui_silence()
  usethis::create_project(
    path = path,
    rstudio = TRUE,
    open = FALSE
  )
  cli::cli_alert_info("Setting active project to {.path {full_path}}")
  rproj_file <- fs::dir_ls(path, type = "file", glob = "*.Rproj")
  cli::cli_alert_info("Writing {.file {rproj_file}} ")
  cli::cli_alert_info("Creating project structure ")

  # Define the directories to be created
  dirs <- c(
    "data/processed",
    "data/raw",
    "data/tables",
    "docs",
    "inst",
    "output/figures",
    "output/tables",
    "R/data",
    "R/figures",
    "report"
  )
  fs::dir_create(dirs)

  # Prepare DESCRIPTION fields
  author_names <- stringr::str_split_1(author, "\\s+")
  # Fallbacks in case only one name is supplied
  given <- author_names[1]
  family <- if (length(author_names) >= 1) author_names[-1] else author_names[1]

  fields_list <- list(
    Title = title,
    Client = client,
    Department = department,
    Version = version,
    "Authors@R" = utils::person(
      given,
      family,
      role = c("aut", "cre")
    )
  )

  cli::cli_alert_info("Writing {.file DESCRIPTION}")

  # Write DESCRIPTION quietly
  usethis::ui_silence(
    usethis::use_description(
      fields = fields_list,
      check_name = FALSE,
      roxygen = FALSE
    )
  )
  desc::desc_del("Description")
  desc::desc_del("License")
  cli::cli_alert_success("Project setup complete! Start working!")
  invisible(usethis::proj_get())
}
