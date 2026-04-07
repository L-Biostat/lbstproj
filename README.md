# lbstproj <a href="https://l-biostat.github.io/lbstproj/"><img src="man/figures/logo.png" alt="lbstproj website" align="right" height="138"/></a>

<!-- badges: start -->
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![pkgdown](https://img.shields.io/badge/docs-pkgdown-blue)](https://l-biostat.github.io/lbstproj/)
<!-- badges: end -->

`lbstproj` provides a lightweight set of tools for the L-Biostat group to
create, maintain, and use standardized statistical analysis projects in R.
It enforces a consistent folder structure, keeps every figure and table
registered in a central **Table of Tables** (TOT), and makes it easy to
generate reproducible Quarto reports.

## Installation

Currently the package is not available on CRAN, so it needs to be installed from github.

``` r
# install.packages("remotes")
remotes::install_github("L-Biostat/lbstproj")
```

## Overview

| Step | What you do | Key function(s) |
|------|-------------|-----------------|
| **1. Create** | Set up a new project | `create_project()` |
| **2. Register** | Fill in the table of tables (TOT), then import | `import_tot()` |
| **3. Generate scripts** | Create template R scripts from the TOT | `create_from_tot()` |
| **4. Analyse** | Write your code, then run all scripts | `run_all_figures()`, `run_all_tables()` |
| **5. Report** | Assemble and render a Quarto report | `create_report()`, `run_report()` |
| **6. Archive** | Move the rendered report to `results/reports/` | `archive_report()` |

## Quick start

``` r
library(lbstproj)

# 1 - Scaffold a new project
create_project(path = ".", title = "My project", author = "Jane Doe")

# 2 - Fill in data/tot/table_of_tables.xlsx, then import it
import_tot()

# 3 - Generate R script stubs for every TOT entry
create_from_tot(dry_run = FALSE)

# 4 - Fill in the scripts, then run them all
run_all_files("data")
run_all_figures()
run_all_tables()

# 5 - Assemble and render the report
create_report(output_type = "html")
run_report()
archive_report()
```

## Project structure

`create_project()` produces the following layout:

```
my-project/
|-- data/
   |-- raw/          # Raw input files (never modified)
   |-- processed/    # Cleaned datasets (.rds)
   |-- tables/       # Saved gt tables (.rds)
   |-- figures/      # Saved ggplot objects (.rds)
   \-- tot/          # table_of_tables.xlsx + cached tot.rds
|-- R/
   |-- data/         # Data preparation scripts
   |-- figures/      # Figure scripts
   |-- tables/       # Table scripts
   \-- functions/    # Shared helper functions
|-- results/
   |-- figures/      # Final PNG / PDF figures
   |-- tables/       # Word tables (.docx)
   \-- reports/      # Archived reports
|-- report/           # Quarto report
\-- docs/             # Meeting notes, costing documents
```

## Learn more

See the **[Get Started](https://l-biostat.github.io/lbstproj/articles/lbstproj.html)**
vignette for a full walkthrough using a simulated oncology trial dataset.

