# Create an R file from a template

Create a R file from a template. Dedicated templates are used when
`type` is `"data"`, `"figure"`, or `"table"`. Any other `type` uses the
default template.

Files are created under `R/<type>(s)/` (e.g. `R/figures/` for
`type = "figure"`), except `type = "data"` which goes to `R/data/`, or
`type = "analysis"` which goes to `R/analysis/`.

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

  *Character*. File name (with or without `.R`).

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
if(FALSE) {
# Hypothetical project layout:
# .
# └─ R/
#    ├─ figures/
#    └─ tables/

# 1) Create a figure file in `R/figures/`
create_file(type = "figure", name = "hr_by_age")
# > ✓ Figure file created at 'R/figures/hr_by_age.R'

# 2) Create a table file in `R/tables/`
create_file(type = "table", name = "baseline_characteristics.R")
# > ✓ Table file created at 'R/tables/baseline_characteristics.R'

# 3) Create an analysis file (uses default template) in R/analysis/
# > ℹ Created directory 'R/analysis'.
# > ✓ Analysis file created at 'R/analysis/primary_model.R'.

# 4) Calling again does not overwrite
create_file(type = "analysis", name = "primary_model")
# > ! File 'R/analysis/primary_model.R' already exists and will not be overwritten.
}
```
