# Get information from the Table of Tables (TOT)

Retrieves a single TOT entry identified by either its unique `id` or its
unique `name`. The TOT is loaded with
[`load_tot()`](https://l-biostat.github.io/lbstproj/reference/load_tot.md).

## Usage

``` r
get_info(id = NULL, name = NULL)
```

## Arguments

- id:

  *Character* A single TOT identifier (character or numeric). Provide
  *either* `.arg id` or `.arg name`, but not both.

- name:

  *Character*. A single TOT name (character). Provide *either*
  `.arg name` or `.arg id`, but not both.

## Value

A named list containing the columns of the matched TOT row.

## Examples

``` r
if(FALSE) {
# By id
info <- get_info(id = "T001")

# By name
info <- get_info(name = "baseline_table")

# Access a field
info$caption
}
```
