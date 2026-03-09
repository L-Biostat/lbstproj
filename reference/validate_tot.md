# Validate the structure of a TOT data frame

Checks that a TOT data frame has the required columns, that the `type`
column contains only `"table"` or `"figure"`, that `id` and `name`
values are unique, and that no required column contains missing values.

## Usage

``` r
validate_tot(tot_data)
```

## Arguments

- tot_data:

  A data frame (or tibble) to validate.

## Value

Invisibly returns `tot_data` if valid; otherwise aborts with an
informative error message.
