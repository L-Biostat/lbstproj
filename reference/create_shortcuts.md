# Create shortcut R files

Shortcut wrappers around
[`create_file()`](https://l-biostat.github.io/lbstproj/reference/create_file.md)
for the standard `figure`, `table`, `data`, and `function` file types.

## Usage

``` r
create_figure(
  name,
  open = TRUE,
  quiet = getOption("lbstproj.quiet", FALSE),
  ...
)

create_table(
  name,
  open = TRUE,
  quiet = getOption("lbstproj.quiet", FALSE),
  ...
)

create_data(name, open = TRUE, quiet = getOption("lbstproj.quiet", FALSE), ...)

create_function(
  name,
  open = TRUE,
  quiet = getOption("lbstproj.quiet", FALSE),
  ...
)
```

## Arguments

- name:

  *Character*. File name (with or without `.R`).

- open:

  *Logical*. Open the file after creation.

- quiet:

  *Logical*. If `TRUE`, suppress informational messages.

  *Default*: `TRUE` unless the global option `lbstproj.quiet` is set
  otherwise.

- ...:

  Additional fields passed as data to the file template.

## Value

Invisibly returns the path of the file created.

## Functions

- `create_figure()`: Create a figure R file in `R/figures/` using the
  figure template. File names may contain only letters, numbers, and
  hyphens.

- `create_table()`: Create a table R file in `R/tables/` using the table
  template. File names may contain only letters, numbers, and hyphens.

- `create_data()`: Create a data R file in `R/data/` using the data
  template. File names may contain letters, numbers, hyphens, and
  underscores.

- `create_function()`: Create a function R file in `R/functions/` using
  the generic file template. File names may contain letters, numbers,
  hyphens, and underscores. A matching `data/functions/` directory is
  also created automatically.

## Examples

``` r
with_example_project({
  # Before
  fs::dir_tree("R")

  # Files are automatically created in the right directory
  create_figure("hr-by-age", open = FALSE, quiet = TRUE)
  create_table("baseline", open = FALSE, quiet = TRUE)
  create_data("import-adsl", open = FALSE, quiet = TRUE)
  create_function("helpers", open = FALSE, quiet = TRUE)

  # After
  fs::dir_tree("R")
})
#> R
#> ├── data
#> ├── figures
#> ├── functions
#> └── tables
#> R
#> ├── data
#> │   └── import-adsl.R
#> ├── figures
#> │   └── hr-by-age.R
#> ├── functions
#> │   └── helpers.R
#> └── tables
#>     └── baseline.R
```
