# Create all R scripts listed in the table of tables (TOT)

This function loads the TOT and creates all the R scripts for figures
and tables listed there in their respective directories in the `R`
folder. Any existing scripts with the same names will NOT be
overwritten.

## Usage

``` r
create_from_tot(dry_run = TRUE, quiet = getOption("lbstproj.quiet", FALSE))
```

## Arguments

- dry_run:

  *Logical*. If `TRUE`, no files are created and the function only
  reports what would be generated.

  *Default*: `TRUE` to avoid generate wrong scripts by mistake.

- quiet:

  Logical. If `TRUE`, suppress informational messages.

  *Default*: `FALSE` unless the global option `lbstproj.quiet` is set
  otherwise. The default option can be changed

## Value

Invisibly returns `NULL`. The function is called for its side effects
(file creation and CLI reporting).

## Examples

``` r
with_example_project({
  # Dry run by default, no files are generated
  create_from_tot()
  fs::dir_tree("R")

  # Actually generate the files
  create_from_tot(dry_run = FALSE, quiet = TRUE)
  fs::dir_tree("R")

}, with_tot = TRUE)
#> 
#> ── Figures 
#> ℹ 1 in TOT, 0 on disk, 0 matched.
#> ℹ Would generate 1 missing program in R/figures:
#> • R/figures/fig.R
#> ! Dry run only: no files were generated. Run `create_from_tot(dry_run = FALSE)` to generate files.
#> 
#> ── Tables 
#> ℹ 0 in TOT, 0 on disk, 0 matched.
#> ℹ None declared in TOT - nothing to do.
#> R
#> ├── data
#> ├── figures
#> ├── functions
#> └── tables
#> R
#> ├── data
#> ├── figures
#> │   └── fig.R
#> ├── functions
#> └── tables
```
