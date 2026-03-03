# Save a processed dataset to the project

This function saves a `data.frame` as an `.rds` file in the
`data/processed/` folder of the project. If the folder does not exists,
it will be created. The file name is validated to ensure that it only
contains letters, numbers, and hyphens.

## Usage

``` r
save_data(
  data,
  name,
  overwrite = TRUE,
  quiet = getOption("lbstproj.quiet", FALSE)
)
```

## Arguments

- data:

  *A `data.frame` object*. The data to be saved.

- name:

  *Character*. File name (without extension). Must only contain letters,
  numbers, and hyphens

- overwrite:

  *Logical*. If `TRUE`, overwrite existing file with the same name. If
  `FALSE`, an error is thrown if a file with the same name already
  exists.

  *Default*: `TRUE`

- quiet:

  *Logical*. If `TRUE`, suppress informational message for file saving.

  *Default*: `TRUE` unless the global option `lbstproj.quiet` is set
  otherwise.
