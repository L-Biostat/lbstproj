# Create a New Project

`create_project()` initializes a new project with a standardized
structure at the specified path. It prompts the user for essential
metadata if not provided. The function creates the necessary
directories, a `DESCRIPTION` file, and an table of tables (TOT) Excel
file. If the project is successfully created, it opens the new project
in RStudio.

## Usage

``` r
create_project(
  path = ".",
  title = NULL,
  client = NULL,
  department = NULL,
  author = NULL,
  version = "1.0.0",
  open = rlang::is_interactive(),
  force = FALSE,
  quiet = FALSE
)
```

## Arguments

- path:

  Path where the project should be created (default is current
  directory).

- title:

  Title of the project.

- client:

  Name of the client.

- department:

  Department code or name.

- author:

  Author name (first and last).

- version:

  Project version (default is `1.0.0`).

- open:

  If `TRUE`, opens the new project in RStudio (default is `TRUE` if in
  interactive session).

- force:

  If `TRUE`, skips the confirmation prompt before creating the project
  (default is `FALSE`).

- quiet:

  If `TRUE`, suppresses informational messages during project creation
  (default is `FALSE`).

## Value

Invisibly returns the active project path.

## Details

The following directory structure is created inside the project:

    ├── data
    │   ├── figures
    │   ├── processed
    │   ├── raw
    │   ├── tables
    │   └── tot
    ├── docs
    │   └── meetings
    ├── results
    │   ├── figures
    │   ├── tables
    │   └── reports
    ├── R
    │   ├── data
    │   ├── figures
    │   ├── functions
    │   └── tables
    └── report
        └── utils

## Examples

``` r
if (FALSE) { # \dontrun{
create_project(
  path = ".", # uses current directory
  title = "Example Project",
  client = "Client Name",
  department = "DEP",
  author = "Jane Doe",
  version = "0.1.0"
)
} # }
```
