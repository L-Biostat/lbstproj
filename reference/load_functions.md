# Source a file from `R/functions/`

`load_function()` sources a single R script from `R/functions/`. Use
this to bring helper functions defined in a
[`create_function()`](https://l-biostat.github.io/lbstproj/reference/create_shortcuts.md)
script into the current session.

`load_all_functions()` sources every `.R` file found in `R/functions/`.

## Usage

``` r
load_function(name, quiet = getOption("lbstproj.quiet", FALSE))

load_all_functions(quiet = getOption("lbstproj.quiet", FALSE))
```

## Arguments

- name:

  *Character*. File name (with or without `.R`) of the script to load
  from `R/functions/`.

- quiet:

  *Logical*. If `TRUE`, suppress informational messages.

  *Default*: `FALSE` unless the global option `lbstproj.quiet` is set
  otherwise.

## Value

Invisibly returns the path of the sourced file.

Invisibly returns the character vector of sourced file paths.

## Functions

- `load_all_functions()`: Source all R scripts in `R/functions/`

## Examples

``` r
if (FALSE) {
load_function("helpers")
# > v Sourced 'R/functions/helpers.R'
}

if (FALSE) {
load_all_functions()
# > v Sourced 'R/functions/helpers.R'
# > v Sourced 'R/functions/utils.R'
}
```
