# Create an R file from a template

Create a R file from a template. Dedicated templates are used when
`type` is `"data"`, `"figure"`, or `"table"`. Any other `type` uses the
default template.

Files are created under `R/<type>(s)/` (e.g. `R/figures/` for
`type = "figure"`), except `type = "data"` which goes to `R/data/`, or
`type = "analysis"` which goes to `R/analysis/`.

For types other than `"figure"`, `"table"`, and `"data"` (which have
dedicated
[save_outputs](https://l-biostat.github.io/lbstproj/reference/save_outputs.md)
functions), a matching `data/<subdir>/` directory is also created. This
is the conventional location to save objects produced by scripts in
`R/<subdir>/` using
[base::saveRDS](https://rdrr.io/r/base/readRDS.html).

If the target directory does not exist, it will be created
automatically.

## Usage

``` r
create_file(
  type,
  name,
  open = TRUE,
  quiet = getOption("lbstproj.quiet", FALSE),
  ...
)
```

## Arguments

- type:

  *Character*. Used to choose both the subdirectory and the template.

- name:

  *Character*. File name (with or without `.R`). Figure and table names
  may only contain letters, numbers, and hyphens. Other file types may
  also contain underscores.

- open:

  *Logical*. Open the file after creation.

- quiet:

  *Logical*. If `TRUE`, suppress informational messages. Important
  messages (e.g. directory creation or errors) are still shown.

  *Default*: `TRUE` unless the global option `lbstproj.quiet` is set
  otherwise.

- ...:

  Additional fields passed as data to the file template.

## Value

Invisibly returns the path of the file created.

## Examples

``` r
with_example_project({
  # Before
  fs::dir_tree("R")

  # Create a figure file in R/figures/ and a table file in R/tables/
  create_file("figure", "hr-by-age", open = FALSE)
  create_file("table", "baseline", open = FALSE, quiet = TRUE) # Doesn't print a message

  # Custom type: also creates matching data/models/ directory
  create_file("model", "primary-model", open = FALSE)

  # After
  fs::dir_tree("R")
})
#> R
#> ├── data
#> ├── figures
#> ├── functions
#> └── tables
#> ✔ Hr-By-Age file created at R/figures/hr-by-age.R.
#> ℹ Created directory R/models.
#> ℹ Created directory data/models.
#> ✔ Primary-Model file created at R/models/primary-model.R.
#> R
#> ├── data
#> ├── figures
#> │   └── hr-by-age.R
#> ├── functions
#> ├── models
#> │   └── primary-model.R
#> └── tables
#>     └── baseline.R
```
