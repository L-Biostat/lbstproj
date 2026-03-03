# Create all R scripts listed in the table of tables (TOT)

This function loads the TOT and creates all the R scripts for figures
and tables listed there in their respective directories in the `R`
folder. Any existing scripts with the same names will NOT be
overwritten.

## Usage

``` r
create_programs(dry_run = TRUE, print = TRUE)
```

## Arguments

- dry_run:

  Logical. If `TRUE`, no files are created and the function only reports
  what would be generated. Defaults to `TRUE`.

- print:

  Logical. If `TRUE`, prints a report to the CLI about the
  synchronization status between TOT and disk, and about the new file
  created. Value taken from the global option `use.print` (which
  defaults to `TRUE`).

## Value

Invisibly returns `NULL`. The function is called for its side effects
(file creation and CLI reporting).

## Examples

``` r
if (FALSE) { # \dontrun{
# Hypothetical project structure:
# R/
# ├── figures/
# │   └── fig_01_flowchart.R
# └── tables/
#     └── tab_01_baseline.R

# TOT contains:
#   - fig_01_flowchart
#   - fig_02_primary
#   - tab_01_baseline
#   - tab_02_primary

# Dry run (no files created)
create_programs()

# Example CLI output:
#
# Figures
# ℹ Figures: 2 in TOT, 1 on disk, 1 matched.
# ℹ Figures: would generate 1 missing program (keeping 1 existing).
# ℹ Figures: would create 1 program in R/figures.
# • R/figures/fig_02_primary.R
#
# Tables
# ℹ Tables: 2 in TOT, 1 on disk, 1 matched.
# ℹ Tables: would generate 1 missing program (keeping 1 existing).
# ℹ Tables: would create 1 program in R/tables.
# • R/tables/tab_02_primary.R

# Actual creation
create_programs(dry_run = FALSE)
} # }
```
