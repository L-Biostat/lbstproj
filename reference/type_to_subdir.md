# Map a file type to its R subdirectory

Converts a `type` string (as used in
[`create_file()`](https://l-biostat.github.io/lbstproj/reference/create_file.md)
and
[`run_all_files()`](https://l-biostat.github.io/lbstproj/reference/run_all_files.md))
to the corresponding subdirectory name inside `R/`.

## Usage

``` r
type_to_subdir(type)
```

## Arguments

- type:

  *Character*. The file type (e.g. `"figure"`, `"table"`, `"data"`,
  `"analysis"`).

## Value

*Character*. The subdirectory name.
