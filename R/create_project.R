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
#' |-- data
#'    |-- figures
#'    |-- processed
#'    |-- raw
#'    |-- tables
#'    \-- tot
#' |-- docs
#' |-- results
#'    |-- figures
#'    |-- tables
#'    \-- reports
#' |-- R
#'    |-- data
#'    |-- figures
#'    |-- functions
#'    \-- tables
#' \-- report
#'     \-- utils
#' ```
#'
#' @param path Path where the project should be created (default is current
#'   directory).
#' @param title Title of the project.
#' @param client Name of the client.
#' @param department Department code or name.
#' @param author Author name (first and last).
#' @param email Author email.
#' @param version Project version (default is `1.0.0`).
#' @param table_engine Table engine to use in the project. Must be `"gt"` or
#'   `"flextable"`. Determines which package is loaded in generated table
#'   scripts and reports.
#'
#'   *Default*: `"gt"`.
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
#' if(FALSE) {
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
  email = NULL,
  version = "1.0.0",
  table_engine = NULL,
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
  cli::cli_text("Enter project information:")
  cli::cli_alert_info(
    "Default values are shown in [brackets]. Press {.key Enter} to accept the default."
  )
  title <- title %||% readline(prompt = "Project name: ")
  author <- prompt_author(author)
  email <- prompt_email(email)
  client <- client %||%
    readline(prompt = "Client's name (if applicable): ")
  department <- department %||%
    readline(prompt = "Client's department (if applicable): ")
  table_engine <- prompt_table_engine(table_engine)
  check_table_engine(table_engine)
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

  # Add a .Rprofile file to the project root
  rprofile_path <- usethis::proj_path(".Rprofile")
  if (!fs::file_exists(rprofile_path)) {
    writeLines(
      c(
        "# If you do not have the `lbstproj` package installed, run the following command",
        "# remotes::install_github(\"L-BioStat/lbstproj\", upgrade = \"never\")",
        "library(lbstproj)",
        ". <- usethis::proj_get() # Sets the active project for the current session"
      ),
      con = rprofile_path
    )
  }

  # Define author as a person object
  author_obj <- utils::person(
    given = stringr::str_split_1(author, "\\s+")[1],
    family = paste(stringr::str_split_1(author, "\\s+")[-1], collapse = " "),
    email = email,
    role = c("aut", "cre")
  )

  # Add the DESCRIPTION file
  create_description(
    title = title,
    client = client,
    department = department,
    author = author_obj,
    version = version,
    table_engine = table_engine,
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
    "docs",
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
  # Copy basic docs to the "docs/" folder
  for (filename in c("costing.docx", "meeting_notes.docx")) {
    if (!fs::file_exists(usethis::proj_path("docs", filename))) {
      fs::file_copy(
        path = fs::path_package("lbstproj", "extdata", filename),
        new_path = usethis::proj_path("docs", filename)
      )
    }
  }
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
  table_engine = "gt",
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
  d$set("TableEngine", table_engine, check = FALSE)
  d$set_authors(author)
  d$write(file = desc_path)
  if (!quiet) {
    cli::cli_alert_success("Writing {.file DESCRIPTION}")
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
  tot_dir <- "data/tot"
  fs::dir_create(usethis::proj_path(tot_dir))

  # Copy the example TOT file to the project
  fs::file_copy(
    path = tot_example_path,
    new_path = usethis::proj_path(tot_dir, "table_of_tables.xlsx"),
    overwrite = FALSE
  )

  # Inform the user
  if (!quiet) {
    cli::cli_alert_success(
      paste(
        "Writing {.file table_of_tables.xlsx}",
        "to {.path {tot_dir}}"
      )
    )
  }
}

prompt_author <- function(author) {
  if (!is.null(author)) {
    return(author)
  }
  default_author <- Sys.getenv("LBSTPROJ_AUTHOR", unset = NA)
  prompt <- "Author's name"
  if (!is.na(default_author)) {
    prompt <- paste0(prompt, " [", default_author, "]: ")
    new_author <- readline(prompt = prompt)
    if (nzchar(new_author)) {
      return(new_author)
    } else {
      return(default_author)
    }
  }
  readline(paste0(prompt, ": "))
}

prompt_email <- function(email) {
  if (!is.null(email)) {
    return(email)
  }
  default_email <- Sys.getenv("LBSTPROJ_EMAIL", unset = NA)
  prompt <- "Author's email address"
  if (!is.na(default_email)) {
    prompt <- paste0(prompt, " [", default_email, "]: ")
    new_email <- readline(prompt = prompt)
    if (nzchar(new_email)) {
      return(new_email)
    } else {
      return(default_email)
    }
  }
  readline(paste0(prompt, ": "))
}

prompt_table_engine <- function(table_engine) {
  if (!is.null(table_engine)) {
    return(table_engine)
  }
  default_table_engine <- "gt"
  prompt <- paste0("Table engine [", default_table_engine, "]: ")
  new_table_engine <- readline(prompt = prompt)
  if (nzchar(new_table_engine)) {
    return(new_table_engine)
  } else {
    return(default_table_engine)
  }
}
