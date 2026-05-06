# Build a data frame summarising whether each figure/table exists in the TOT, as an R script, and as a saved output.

Build a data frame summarising whether each figure/table exists in the
TOT, as an R script, and as a saved output.

## Usage

``` r
build_status(type = c("figure", "table"), refresh_tot = FALSE)
```

## Arguments

- type:

  *Character*. Either `"figure"` or `"table"`.

- refresh_tot:

  *Logical*. If `TRUE`, reload the TOT from the source Excel file before
  building the status. *Default*: `FALSE`.

## Value

A data frame with one row per item and logical columns indicating
presence in each location (`in_tot`, `in_r`, `in_res`, and, for tables
only, `in_data`).
