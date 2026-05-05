# Evaluate Code in a Temporary Example Project

`with_example_project()` creates a temporary, minimal project
environment and evaluates the provided code inside it. This is primarily
intended for use in `@examples`, vignettes, and tests to ensure
reproducibility without relying on the user's working directory.

The temporary project replicates the full directory structure created by
[`create_project()`](https://l-biostat.github.io/lbstproj/reference/create_project.md):
`R/figures/`, `R/tables/`, `R/data/`, `R/functions/`, `data/raw/`,
`data/processed/`, `data/tables/`, `data/tot/`, `results/figures/`,
`results/tables/`, `results/reports/`, and `report/`. A minimal
`DESCRIPTION` file and an `.Rproj` file are also written so that
[`usethis::proj_path()`](https://usethis.r-lib.org/reference/proj_utils.html)
and related helpers work correctly throughout the evaluation.

## Usage

``` r
with_example_project(code, with_tot = FALSE)
```

## Arguments

- code:

  Code to evaluate inside the temporary project (use
  [`{}`](https://rdrr.io/r/base/Paren.html)).

- with_tot:

  *Logical*. If `TRUE`, copies the package's example TOT
  (`inst/extdata/table_of_tables.xlsx`) into `data/tot/` and calls
  [`import_tot()`](https://l-biostat.github.io/lbstproj/reference/import_tot.md)
  so that
  [`load_tot()`](https://l-biostat.github.io/lbstproj/reference/load_tot.md),
  [`get_info()`](https://l-biostat.github.io/lbstproj/reference/get_info.md),
  and related functions work immediately.

  *Default*: `FALSE`.

## Value

Invisibly returns the path to the temporary project directory.

## Details

Working directory and the active `usethis` project are both restored
when `with_example_project()` returns, even if `code` signals an error.

## Examples

``` r
with_example_project({
  create_figure("hr-by-age", open = FALSE, quiet = TRUE)
  fs::dir_tree("R/figures")
})
#> R/figures
#> └── hr-by-age.R
```
