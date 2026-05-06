# Check the status of figures or tables

Prints a formatted status table showing whether each figure or table is
registered in the TOT, has a corresponding R script, and has been saved
as an output file. For tables, presence in the data directory is also
checked.

## Usage

``` r
check_status(type = c("figure", "table"), refresh_tot = FALSE)
```

## Arguments

- type:

  *Character*. Either `"figure"` or `"table"`.

- refresh_tot:

  *Logical*. If `TRUE`, reload the TOT from the source Excel file before
  building the status.

  *Default*: `FALSE`.

## Value

Called for its side effect of printing the status table. Returns `NULL`
invisibly.

## Examples

``` r
with_example_project({
  # Add a fake R script for a table without a corresponding TOT entry
  fs::file_create("R/tables/table_001.R")

  # Check status for figures and tables
  check_status("figure")
  check_status("table")
}, with_tot = TRUE)
#> # Figures
#> 
#> ID | Name | In TOT | In R | In Results
#> --------------------------------------
#> 1  | fig  |   ✔    |  ─   |     ─     
#> # Tables
#> 
#> ID | Name      | In TOT | In R | In Results | In Data
#> -----------------------------------------------------
#> ?  | table_001 |   ─    |  ✔   |     ─      |    ─   
```
