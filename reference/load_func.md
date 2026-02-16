# Load functions from the `R/functions` directory

These helper functions load one or all functions from the `R/functions`
directory.

## Usage

``` r
load_all_functions()

load_function(name)
```

## Arguments

- name:

  The name of the specific function file to load. It must be relative to
  the `R/functions` directory and can include or omit the `.R`
  extension.

## Functions

- `load_all_functions()`: Load all function files.

- `load_function()`: Load a single function file.

## Examples

``` r
if (FALSE) { # \dontrun{
load_all_functions()
load_function("data_cleaning") # Works
load_function("data_cleaning.R") # Also works
load_function("R/functions/data_cleaning.R") # Fails
} # }
```
