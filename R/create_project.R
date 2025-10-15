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
#' │   ├── figures
#' │   ├── processed
#' │   ├── raw
#' │   └── tables
#' ├── docs
#' │   └── meetings
#' ├── results
#' │   ├── figures
#' │   └── tables
#' ├── R
#' │   ├── data
#' │   ├── figures
#' │   └── tables
#' └── report
#'     └── utils
#' ```
#'
#' @param path Path where the project should be created (default is current directory).
#' @param title Title of the project.
#' @param client Name of the client.
#' @param department Department code or name.
#' @param author Author name (first and last).
#' @param version Project version (default is `1.0.0`).
#' @param open If `TRUE`, opens the new project in RStudio (default is `TRUE` if in interactive session).
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
#'   version = "0.1.0",
#'   path = "." # uses current directory
#' )
#' }
create_project <- function(
  path = ".",
  title = NULL,
  client = NULL,
  department = NULL,
  author = NULL,
  version = "1.0.0",
  open = rlang::is_interactive()
) {
  # Check if the path exists
  full_path <- fs::path_abs(path)
  if (!fs::dir_exists(path)) {
    cli::cli_abort("The specified path {.path {full_path}} does not exist.")
  }
  # Ensure that user does want to create project there
  ok <- usethis::ui_yeah(
    paste0("Create project at `", full_path, "`?"),
    n_no = 1,
    n_yes = 1
  )
  if (!ok) {
    cli::cli_abort("Project creation aborted by user.")
  }

  # Prompt user for project information, if not provided
  title <- title %||% readline(prompt = "Enter the project name: ")
  author <- author %||% readline(prompt = "Enter the author's name: ")
  client <- client %||%
    readline(prompt = "Enter the client's name (if applicable): ")
  department <- department %||%
    readline(prompt = "Enter the client's department (if applicable): ")

  # Create project at specified path
  usethis::ui_silence(
    usethis::create_project(
      path = path,
      rstudio = TRUE,
      open = FALSE
    )
  )
  cli::cli_alert_info("Setting active project to {.path {full_path}}")
  rproj_file <- fs::dir_ls(path, type = "file", glob = "*.Rproj")
  cli::cli_alert_info("Creating project structure ")

  # Define the directories to be created
  dirs <- c(
    "data/processed",
    "data/raw",
    "data/tables",
    "data/figures",
    "docs/meetings",
    "results/figures",
    "results/tables",
    "R/data",
    "R/figures",
    "report/utils"
  )
  fs::dir_create(fs::path(full_path, dirs))

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
  # Remove unnecessary fields added by default
  desc::desc_del("Description")
  desc::desc_del("License")

  # Create an example table of tables (TOT)
  create_tot()

  cli::cli_alert_success("Project setup complete! Start working!")
  # usethis::proj_activate(full_path)
  invisible(usethis::proj_get())
}

#' Create a DESCRIPTION file for the project
create_description <- function(
  path,
  title,
  client,
  department,
  author,
  version,
  quiet = FALSE
) {
  # Check that author is of class person
  if (!inherits(author, "person")) {
    cli::cli_abort("{.arg author} must be of class {.cls person}.")
  }
  # Create an empty DESCRIPTION file
  desc_path <- fs::path(path, "DESCRIPTION")
  fs::file_create(desc_path)
  # Read it as a description object and populate fields
  d <- desc::description$new(desc_path)
  d$set("Package", fs::path_file(path)) # Use folder name as package name
  d$set("Title", title)
  d$set("Client", client)
  d$set("Department", department)
  d$set("Version", version)
  d$set_authors(author)
  # Print the description to file
  d$write(file = desc_path)
  if (!quiet) {
    cli::cli_alert_success("Created {.file DESCRIPTION} at {.path {desc_path}}")
  }
}

create_structure <- function(path, quiet = FALSE) {
  # Define the directories to be created
  dirs <- c(
    # `data` folders
    "data/processed",
    "data/raw",
    "data/tables",
    "data/figures",
    "docs/meetings",
    "results/figures",
    "results/tables",
    "results/reports",
    "R/data",
    "R/figures",
    "report/utils"
  )
  fs::dir_create(fs::path(path, dirs))
  if (!quiet) {
    cli::cli_alert_success("Created project structure at {.path {path}}")
  }
}
