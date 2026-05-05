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
with_example_project({
  tot <- load_tot()

  # Look up by id
  info_id <- get_info(id = tot$id[[1]])
  str(info_id)

  # Look up by name (the information is the same)
  info_name <- get_info(name = tot$name[[1]])
  str(info_name)
}, with_tot = TRUE)
#> List of 7
#>  $ id           : num 1
#>  $ type         : chr "figure"
#>  $ name         : chr "fig"
#>  $ caption      : chr "This is a figure"
#>  $ section      : chr ""
#>  $ subsection   : chr ""
#>  $ subsubsection: chr ""
#> List of 7
#>  $ id           : num 1
#>  $ type         : chr "figure"
#>  $ name         : chr "fig"
#>  $ caption      : chr "This is a figure"
#>  $ section      : chr ""
#>  $ subsection   : chr ""
#>  $ subsubsection: chr ""
```
