# Save analysis objects as `.rds`

A family of helpers that save figures, tables, and data sets as
**`.rds`** files via
[`base::saveRDS()`](https://rdrr.io/r/base/readRDS.html). Each function
writes to its designated output directory.

## Usage

``` r
save_data(
  data,
  name,
  overwrite = TRUE,
  quiet = getOption("lbstproj.quiet", FALSE)
)

save_figure(object, name, overwrite = TRUE, print = NULL, ...)

save_table(object, name, overwrite = TRUE, print = NULL, ...)
```

## Arguments

- name:

  Name used to save the object (without file extension).

- object:

  The object to save (figure/table/data). Any R object supported by
  [`base::saveRDS()`](https://rdrr.io/r/base/readRDS.html).

- print:

  Whether to print (default: `TRUE`) a success message to the console.
  You can set a default print behavior for all functions in this family
  by setting the global option `save.print` to `TRUE` or `FALSE`.

- ...:

  Additional arguments passed to
  [`base::saveRDS()`](https://rdrr.io/r/base/readRDS.html) (e.g.,
  `compress`, `version`).

## Details

These helpers are called for their side effects and do not return a
value.

## Functions

- [`save_data()`](https://l-biostat.github.io/lbstproj/reference/save_data.html):
  Save a data object to `data/processed/`.

- `save_figure()`: Save a figure to `data/figures/`.

- `save_table()`: Save a table to `data/tables/`.

## See also

[`base::saveRDS()`](https://rdrr.io/r/base/readRDS.html)

## Examples

``` r
if (FALSE) { # \dontrun{
# Figures
save_figure(plot, "main_effect", compress = "xz")

# Tables
save_table(tbl, "baseline_summary")

# Data (saved to data/processed/)
save_data(df, "patients_clean", version = 3)
} # }
```
