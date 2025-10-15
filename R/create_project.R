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

  # Create project-specific files (.Rproj) at specified path
  usethis::ui_silence(
    usethis::create_project(
      path = path,
      rstudio = TRUE,
      open = FALSE
    )
  )
  cli::cli_alert_info("Setting active project to {.path {full_path}}")

  # Create the project structure
  create_structure(full_path, quiet = FALSE)

  # Define author as a person object
  author_obj <- utils::person(
    given = stringr::str_split_1(author, "\\s+")[1],
    family = paste(stringr::str_split_1(author, "\\s+")[-1], collapse = " "),
    role = c("aut", "cre")
  )

  # Add the DESCRIPTION file
  create_description(
    path = full_path,
    title = title,
    client = client,
    department = department,
    author = author_obj,
    version = version,
    quiet = FALSE
  )

  # Create an example table of tables (TOT)
  create_tot(path = full_path, overwrite = FALSE)

  # Open the new project if requested
  if (open) {
    cli::cli_alert_info("Opening project in RStudio...")
    rstudioapi::openProject(full_path, newSession = FALSE)
  }
  cli::cli_alert_success("Project setup complete! Start working!")
  invisible(usethis::proj_get())
}

#' Create a DESCRIPTION file for the project
#'
#' @details This functions does not check arguments for validity. It assumes
#' that they are checked in the `create_project()` function.
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
    cli::cli_alert_success("Writing {.file DESCRIPTION} file")
  }
}

#' Create the standard project structure
#'
#' `create_structure()` creates the standard folder structure for the project.
#' Any folders that already exist will be skipped.
#'
#' @details This functions does not check arguments for validity. It assumes
#' that they are checked in the `create_project()` function.
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
    cli::cli_alert_success("Creating project structure")
  }
}

#' Create a README.md file for the project
#'
#' Create a basic README.md file in the root of the project directory. It
#' contains the project title, author, and a brief overview of the directory
#' structure.
#' If the file already exists, it will not be overwritten.
#'
#' @details This functions does not check arguments for validity. It assumes
#' that they are checked in the `create_project()` function.
create_readme <- function(path, title, author, quiet = FALSE) {
  readme_path <- fs::path(path, "README.md")
  if (fs::file_exists(readme_path)) {
    if (!quiet) {
      cli::cli_alert_info(
        "{.file README.md} already exists, skipping creation."
      )
    }
    return(invisible(NULL))
  } else {
    fs::file_create(readme_path)
    readme_content <- c(
      paste0("# ", title),
      "",
      paste0("**Author:** ", author),
      "",
      "## Project Overview",
      "",
      "A brief description of the project goes here.",
      "",
      "## Directory Structure",
      "",
      "```\n",
      "├── data\n",
      "│   ├── figures\n",
      "│   ├── processed\n",
      "│   ├── raw\n",
      "│   └── tables\n",
      "├── docs\n",
      "│   └── meetings\n",
      "├── results\n",
      "│   ├── figures\n",
      "│   └── tables\n",
      "├── R\n",
      "│   ├── data\n",
      "│   ├── figures\n",
      "│   └── tables\n",
      "└── report\n",
      "    └── utils\n",
      "```"
    )
    writeLines(readme_content, con = readme_path)
    if (!quiet) {
      cli::cli_alert_success("Creating {.file README.md}")
    }
  }
  invisible(NULL)
}
