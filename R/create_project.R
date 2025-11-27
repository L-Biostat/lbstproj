#' Create a New Project
#'
#' `create_project()` initializes a new project with a standardized structure at
#' the specified path. It prompts the user for essential metadata if not
#' provided. The function creates the necessary directories, a `DESCRIPTION`
#' file, and an table of tables (TOT) Excel file. If the project is successfully
#' created, it opens the new project in RStudio.
#'
#' @details
#' The following directory structure is created inside the project:
#'
#' ```
#' ├── data
#' │   ├── figures
#' │   ├── processed
#' │   ├── raw
#' │   ├── tables
#' │   └── tot
#' ├── docs
#' │   └── meetings
#' ├── results
#' │   ├── figures
#' │   ├── tables
#' │   └── reports
#' ├── R
#' │   ├── data
#' │   ├── figures
#' │   ├── functions
#' │   └── tables
#' └── report
#'     └── utils
#' ```
#'
#' @param path Path where the project should be created (default is current
#'   directory).
#' @param title Title of the project.
#' @param client Name of the client.
#' @param department Department code or name.
#' @param author Author name (first and last).
#' @param version Project version (default is `1.0.0`).
#' @param open If `TRUE`, opens the new project in RStudio (default is `TRUE` if
#'   in interactive session).
#' @param force If `TRUE`, skips the confirmation prompt before creating the
#'  project (default is `FALSE`).
#' @param quiet If `TRUE`, suppresses informational messages during project
#'  creation (default is `FALSE`).
#'
#' @return Invisibly returns the active project path.
#' @md
#' @export
#'
#' @examples
#' \dontrun{
#' create_project(
#'   path = ".", # uses current directory
#'   title = "Example Project",
#'   client = "Client Name",
#'   department = "DEP",
#'   author = "Jane Doe",
#'   version = "0.1.0"
#' )
#' }
create_project <- function(
  path = ".",
  title = NULL,
  client = NULL,
  department = NULL,
  author = NULL,
  version = "1.0.0",
  open = rlang::is_interactive(),
  force = FALSE,
  quiet = FALSE
) {
  # Ensure that user does want to create project at this path
  if (!force) {
    ok <- usethis::ui_yeah(
      paste0("Create project at `", fs::path_abs(path), "`?"),
      n_no = 1,
      n_yes = 1
    )
  } else {
    ok <- TRUE
  }
  if (!ok) {
    cli::cli_abort("Cancelling project creation.")
  }

  # Prompt user for project information, if not provided
  title <- title %||% readline(prompt = "Enter the project name: ")
  author <- author %||%
    readline(prompt = "Enter the author's name (first and last): ")
  client <- client %||%
    readline(prompt = "Enter the client's name (if applicable): ")
  department <- department %||%
    readline(prompt = "Enter the client's department (if applicable): ")

  # Set the given path as the active project, and create RStudio project
  if (!quiet) {
    usethis::proj_set(path, force = TRUE) # Forcing is needed for a new project
    usethis::use_rstudio(line_ending = "windows", reformat = TRUE)
  } else {
    usethis::ui_silence({
      usethis::proj_set(path, force = TRUE) # Forcing is needed for a new project
      usethis::use_rstudio(line_ending = "windows", reformat = TRUE)
    })
  }

  # Create the project structure
  create_structure(quiet = quiet)

  # Define author as a person object
  author_obj <- utils::person(
    given = stringr::str_split_1(author, "\\s+")[1],
    family = paste(stringr::str_split_1(author, "\\s+")[-1], collapse = " "),
    role = c("aut", "cre")
  )

  # Add the DESCRIPTION file
  create_description(
    title = title,
    client = client,
    department = department,
    author = author_obj,
    version = version,
    quiet = quiet
  )

  # Create an example table of tables (TOT)
  create_tot(quiet = quiet)

  # Open the new project if requested
  if (open && rstudioapi::isAvailable()) {
    cli::cli_alert_success("Opening project in RStudio")
    rstudioapi::openProject(usethis::proj_get(), newSession = TRUE)
  }
  if (!quiet) {
    cli::cli_alert_success("{.strong Project setup complete! Start working!}")
  }
  invisible(usethis::proj_get())
}

#' Create the standard project structure
#'
#' `create_structure()` creates the standard folder structure for the project.
#' Any folders that already exist will be skipped.
#'
#' @keywords internal
create_structure <- function(quiet = FALSE) {
  # Define the directories to be created
  dirs <- c(
    "data/processed",
    "data/raw",
    "data/tables",
    "data/figures",
    "data/tot",
    "docs/meetings",
    "results/figures",
    "results/tables",
    "results/reports",
    "R/data",
    "R/figures",
    "R/functions",
    "R/tables",
    "report/utils"
  )
  fs::dir_create(usethis::proj_path(dirs))
  if (!quiet) {
    cli::cli_alert_success("Creating project structure")
  }
}


#' Create a DESCRIPTION file for the project
#'
#' `create_description()` creates a `DESCRIPTION` file in the project, using the
#' project root directory as "package name" and adding the fields: Title,
#' Author, Client, and Department. The function does not check arguments for
#' validity. It assumes that they are checked in the `create_project()`
#' function.
#'
#' @keywords internal
create_description <- function(
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
  # Create an empty DESCRIPTION file (this avoids prefilling the file)
  desc_path <- usethis::proj_path("DESCRIPTION")
  fs::file_create(desc_path)
  # Read it as a description object and populate fields
  d <- desc::description$new(desc_path)
  d$set("Package", fs::path_file(usethis::proj_get()), check = FALSE)
  d$set("Title", title)
  d$set("Client", client)
  d$set("Department", department)
  d$set("Version", version)
  d$set_authors(author)
  d$write(file = desc_path)
  if (!quiet) {
    cli::cli_alert_info("Writing {.file DESCRIPTION} file")
  }
}

#' Create a Empty Table of Tables (TOT) Excel file in the project
#'
#' `create_tot()` copies a template TOT Excel file from the `lbstproj` package
#' to the `data/tot/` directory of your project. The example TOT file contains
#' an example row for guidance. It should be deleted before use.
#'
#' @details
#' If a "data/tot/" directory does not exist, it will be created.
#' If a TOT file already exists in the target directory, it will be overwritten.
#'
#'
#' @keywords internal
create_tot <- function(quiet = FALSE) {
  # Find the path to the TOT excel file example in the `lbstproj` package
  tot_example_path <- fs::path_package(
    package = "lbstproj",
    "extdata/table_of_tables.xlsx"
  )

  # Check that the `data/tot/` directory exists; if not, create it
  tot_dir <- usethis::proj_path("data/tot")
  check_dir_exists(tot_dir)

  # Copy the example TOT file to the project
  fs::file_copy(
    path = tot_example_path,
    new_path = tot_dir,
    overwrite = TRUE
  )

  # Inform the user
  if (!quiet) {
    cli::cli_alert_info(
      paste(
        "Writing {.file {fs::path_file(tot_example_path)}} file",
        "to {.path {fs::path_rel(tot_dir)}}"
      )
    )
  }
}
