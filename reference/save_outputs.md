# Save outputs in the project

These functions standardize how outputs are saved in an `lbstproj`
project:

- `save_data()` saves a data frame as `rds` to `data/processed`.

- `save_table()` saves a table as `rds` to `data/tables` and optionally
  exports it as `docx` to `results/tables`. The accepted table class and
  the export method depend on the project's table engine (`"gt"` or
  `"flextable"`), stored in the `TableEngine` field of the project
  `DESCRIPTION` file. Legacy projects without that field default to
  `"gt"`.

- `save_figure()` saves a figure as `png` (or another extension) to
  `results/figures`.

To save another R object (e.g. a model, a `mice` object, ...) to file,
use [base::saveRDS](https://rdrr.io/r/base/readRDS.html). By convention,
save it to `data/<subdir>/` where `<subdir>` matches the subdirectory in
`R/` where the script lives. For example, a model created in `R/models/`
should be saved to `data/models/`. When using
[`create_file()`](https://l-biostat.github.io/lbstproj/reference/create_file.md)
with a custom type, the matching `data/<subdir>/` directory is created
automatically.

Each function saves the object using the given name, after validating
it. Figure and table names can only contain letters, numbers, and
hyphens. Data names may also contain underscores.

## Usage

``` r
save_data(
  data,
  name,
  overwrite = TRUE,
  quiet = getOption("lbstproj.quiet", FALSE)
)

save_table(
  table,
  name,
  export = TRUE,
  overwrite = TRUE,
  quiet = getOption("lbstproj.quiet", FALSE),
  ...
)

save_figure(
  figure,
  name,
  extension = "png",
  width = 6,
  height = 4,
  overwrite = TRUE,
  quiet = getOption("lbstproj.quiet", FALSE),
  ...
)
```

## Arguments

- data:

  A `data.frame` to save.

- name:

  *Character*. File name without extension.

- overwrite:

  *Logical*. If `TRUE`, overwrite an existing file with the same name.
  If `FALSE`, an error is thrown when the target file already exists.

  *Default*: `TRUE`. Outputs are overwritten by default.

- quiet:

  Logical. If `TRUE`, suppress informational messages.

  *Default*: `FALSE` unless the global option `lbstproj.quiet` is set
  otherwise. The default option can be changed using
  `options(lbstproj.quiet = TRUE)`

- table:

  A table object to save. Must be a `gt_tbl` for `gt` projects or a
  `flextable` for `flextable` projects.

- export:

  *Logical*. If `TRUE`, also export the table as a `.docx` file.

  *Default*: `TRUE`. Word tables are always produced unless specified
  otherwise.

- ...:

  Additional arguments passed to the saving function:

  - For `save_table()`: passed to
    [`gt::gtsave()`](https://gt.rstudio.com/reference/gtsave.html) (gt
    projects) or
    [`flextable::save_as_docx()`](https://davidgohel.github.io/flextable/reference/save_as_docx.html)
    (flextable projects)

  - For `save_figure()`: passed to
    [ggplot2::ggsave](https://ggplot2.tidyverse.org/reference/ggsave.html)

- figure:

  A `ggplot` object to save.

- extension:

  *Character*. Output format for figures: `"png"` or `"pdf"`.

  *Default*: `"png"`

- width, height:

  *Numeric*. Width and height of the saved figure in inches.

  *Default*: A width of 6 and a height of 4. This fits nicely on a
  portrait A4 page.

## Value

Invisibly returns the path of the saved file.

## Examples

``` r
with_example_project({
  # Before any data is saved
  fs::dir_tree("data")

  # Save a data frame to `data/processed/`
  save_data(mtcars, name = "analysis-dataset")
  fs::dir_tree("data/processed")

  # Save a ggplot figure to `results/figures`
  fig <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) +
    ggplot2::geom_point()
  save_figure(fig, name = "mpg-vs-weight")
  fs::dir_tree("results/figures")

  # Save a gt table to `data/tables/` and export it to `results/tables`
  tbl <- gt::gt(head(mtcars))
  save_table(tbl, name = "summary", export = TRUE)
  fs::dir_tree("data/tables")
  fs::dir_tree("results/tables")
})
#> data
#> ├── figures
#> ├── processed
#> ├── raw
#> ├── tables
#> └── tot
#> ✔ Data frame "mtcars" saved to data/processed/analysis-dataset.rds.
#> data/processed
#> └── analysis-dataset.rds
#> ✔ Figure "fig" saved to results/figures/mpg-vs-weight.png.
#> results/figures
#> └── mpg-vs-weight.png
#> ✔ Table "tbl" saved to data/tables/summary.rds.
#> ✔ Table "tbl" exported to results/tables/summary.docx.
#> data/tables
#> └── summary.rds
#> results/tables
#> └── summary.docx
```
