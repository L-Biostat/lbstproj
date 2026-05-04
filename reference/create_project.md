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
  email = NULL,
  version = "1.0.0",
  table_engine = NULL,
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

- email:

  Author email.

- version:

  Project version (default is `1.0.0`).

- table_engine:

  Table engine to use in the project. Must be `"gt"` or `"flextable"`.
  Determines which package is loaded in generated table scripts and
  reports.

  *Default*: `"gt"`.

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

## Examples

``` r
# Create a temporary folder to store the new project
tmp_dir <- tempfile("lbstproj-")
dir.create(tmp_dir)

# Create a new project
create_project(
  path = tmp_dir,
  title = "COVID-19 Vaccine Effectiveness Study",
  client = "Acme Corp",
  department = "Epidemiology",
  author = "Jane Doe",
  email = "jane.doe@example.com",
  table_engine = "gt",
  open = FALSE,
  force = TRUE # Avoids interactive confirmation prompt in example
)
#> ✔ Setting active project to "/tmp/RtmpE2gKqw/lbstproj-57606f281f08".
#> ✔ Writing lbstproj-57606f281f08.Rproj.
#> ✔ Adding ".Rproj.user" to .gitignore.
#> ✔ Creating project structure
#> ✔ Writing DESCRIPTION
#> ✔ Writing table_of_tables.xlsx to data/tot
#> ✔ Project setup complete! Start working!

# Show resulting project structure
fs::dir_tree(tmp_dir)
#> /tmp/RtmpE2gKqw/lbstproj-57606f281f08
#> ├── DESCRIPTION
#> ├── R
#> │   ├── data
#> │   ├── figures
#> │   ├── functions
#> │   └── tables
#> ├── data
#> │   ├── figures
#> │   ├── processed
#> │   ├── raw
#> │   ├── tables
#> │   └── tot
#> │       └── table_of_tables.xlsx
#> ├── docs
#> │   ├── costing.docx
#> │   └── meeting_notes.docx
#> ├── lbstproj-57606f281f08.Rproj
#> ├── report
#> │   └── utils
#> └── results
#>     ├── figures
#>     ├── reports
#>     └── tables

# Peek at the generated DESCRIPTION file
desc_path <- file.path(tmp_dir, "DESCRIPTION")
cat(readLines(desc_path)[1:8], sep = "\n")
#> Package: lbstproj-57606f281f08
#> Title: COVID-19 Vaccine Effectiveness Study
#> Client: Acme Corp
#> Department: Epidemiology
#> Version: 1.0.0
#> TableEngine: gt
#> Authors@R: 
#>     person("Jane", "Doe", , "jane.doe@example.com", role = c("aut", "cre"))
```
