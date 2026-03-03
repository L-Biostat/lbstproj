# Ensure a file does not exist

Verify if the path to a file exists and throws an error if it the case.
This is used purely for validation purposes.

## Usage

``` r
ensure_file_does_not_exist(file)
```

## Arguments

- file:

  *Character*. File path. Must be relative to active project and not
  absolute.

## Value

Invisibly returns the normalized path to the file, relative to the
active project.
