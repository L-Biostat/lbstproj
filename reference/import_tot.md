# Import the Table of Tables (TOT)

Reads the TOT Excel file from `data/tot/table_of_tables.xlsx`, validates
its structure, and saves it as an RDS file in `data/tot/tot.rds`.

## Usage

``` r
import_tot(quiet = FALSE)
```

## Value

Invisibly returns the TOT data as a tibble.
