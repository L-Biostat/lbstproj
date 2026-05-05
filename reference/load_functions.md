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
with_example_project({
  # Create a simple helper script
  writeLines("add <- function(x, y) x + y", "R/functions/helpers.R")

  # Load it into the session
  load_function("helpers", quiet = TRUE)
  add(1, 2)
})

with_example_project({
  writeLines("greet <- function() cat('hello\n')", "R/functions/greet.R")
  load_all_functions()
})
#> ✔ Sourced R/functions/greet.R
```
