# Load the Table of Tables (TOT)

Simple wrapper function to load the TOT RDS file.

## Usage

``` r
load_tot(refresh = TRUE)
```

## Arguments

- refresh:

  Logical; if `TRUE`, re-imports the TOT from the Excel file using
  [`import_tot()`](https://l-biostat.github.io/lbstproj/reference/import_tot.md).
  Default is `TRUE` because the TOT may be updated frequently.

## Value

A tibble containing the TOT data with the following columns:

- `id`: Unique identifier for each item.

- `type`: Type of the item (either "table" or "figure").

- `name`: Name of the item.

- `caption`: Caption of the item.

## Examples

``` r
if (FALSE) { # \dontrun{
 tot <- load_tot()
} # }
```
