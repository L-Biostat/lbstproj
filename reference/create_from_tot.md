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
if(FALSE) {
# Hypothetical project structure:
# R/
# |-- figures/
#    \-- fig_01_flowchart.R
# \-- tables/
#     \-- tab_01_baseline.R

# TOT contains:
#   - fig_01_flowchart
#   - fig_02_primary
#   - tab_01_baseline
#   - tab_02_primary

# Dry run (no files created)
create_from_tot()

# Example CLI output:
#
# Figures
# i Figures: 2 in TOT, 1 on disk, 1 matched.
# i Figures: would generate 1 missing program (keeping 1 existing).
# i Figures: would create 1 program in R/figures.
# * R/figures/fig_02_primary.R
#
# Tables
# i Tables: 2 in TOT, 1 on disk, 1 matched.
# i Tables: would generate 1 missing program (keeping 1 existing).
# i Tables: would create 1 program in R/tables.
# * R/tables/tab_02_primary.R

# Actual creation
create_from_tot(dry_run = FALSE)
}
```
