# Run R Scripts in a Project Subdirectory

`run_all_files()` sources all R scripts matching a glob pattern inside a
subdirectory of the project's `R/` folder. The target subdirectory is
derived from the `type` argument using the same convention as
[`create_file()`](https://l-biostat.github.io/lbstproj/reference/create_file.md):
`"figure"` maps to `R/figures/`, `"table"` maps to `R/tables/`, `"data"`
maps to `R/data/`, `"analysis"` maps to `R/analysis/`, and any other
value maps to `R/<type>s/`.

For `type` values `"figure"` or `"table"`, the function additionally
checks for discrepancies between the files in the directory and the
table of tables (ToT) before sourcing, and issues a warning if any are
found.

`run_all_figures()` and `run_all_tables()` are convenient wrappers
around `run_all_files()`.

## Usage

``` r
run_all_files(type, glob = "*.R", quiet = getOption("lbstproj.quiet", FALSE))

run_all_figures(glob = "*.R", quiet = getOption("lbstproj.quiet", FALSE))

run_all_tables(glob = "*.R", quiet = getOption("lbstproj.quiet", FALSE))
```

## Arguments

- type:

  *Character*. The type of scripts to run. Controls the subdirectory of
  `R/` that is searched:

  - `"figure"` -\> `R/figures/`

  - `"table"` -\> `R/tables/`

  - `"data"` -\> `R/data/`

  - `"analysis"` -\> `R/analysis/`

  - any other value -\> `R/<type>s/`

- glob:

  *Character*. A glob pattern passed to
  [`fs::dir_ls()`](https://fs.r-lib.org/reference/dir_ls.html) to
  include or exclude files.

  *Default*: `"*.R"` – matches all R scripts (case-sensitive).

- quiet:

  *Logical*. If `TRUE`, suppress informational messages.

  *Default*: `FALSE` unless the global option `lbstproj.quiet` is set
  otherwise. The default can be changed via
  `options(lbstproj.quiet = TRUE)`.

## Value

Invisibly returns the character vector of sourced file paths.

## Functions

- `run_all_figures()`: Run all R scripts in `R/figures`

- `run_all_tables()`: Run all R scripts in `R/tables`

## Examples

``` r
with_example_project({
  # Create a minimal data script
  writeLines('# code for data', "R/data/load-data.R")

  # Source all scripts in R/data/
  run_all_files("data")
})
#> 
#> ── Running all data files in R/data ────────────────────────────────────────────
#> ℹ Found 1 file.
#> ℹ Sourcing file 1/1: load-data
#> ✔ Sourced file 1/1: load-data [13ms]
#> 

with_example_project({
  writeLines('# code for Figure 1', "R/figures/fig01.R")
  run_all_figures()
}, with_tot = TRUE)
#> ! Found 1 file in R/figures but not in the ToT: fig01.R
#> 
#> ── Running all figure files in R/figures ───────────────────────────────────────
#> ℹ Found 1 file.
#> ℹ Sourcing file 1/1: fig01
#> ✔ Sourced file 1/1: fig01 [14ms]
#> 
with_example_project({
  writeLines('# code for Table 1', "R/tables/tab01.R")
  writeLines('# code for Table 2', "R/tables/tab02.R")
  run_all_tables()
}, with_tot = TRUE)
#> ! Found 2 files in R/tables but not in the ToT: tab01.R and tab02.R
#> 
#> ── Running all table files in R/tables ─────────────────────────────────────────
#> ℹ Found 2 files.
#> ℹ Sourcing file 1/2: tab01
#> ✔ Sourced file 1/2: tab01 [11ms]
#> 
#> ℹ Sourcing file 2/2: tab02
#> ✔ Sourced file 2/2: tab02 [11ms]
#> 
```
