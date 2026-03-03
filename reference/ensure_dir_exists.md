# Ensure a directory exists

**\[stable\]**

Create a directory (recursively) if it does not exist already or throw
an error if needed. Paths must be relative to the active project, not
absolute.

## Usage

``` r
ensure_dir_exists(path, create = TRUE)
```

## Arguments

- path:

  *Character*. Directory path. Must be relative to active project and
  not absolute.

- create:

  *Logical*. If `FALSE`, throws an error if the directory does not
  exist. If `TRUE` creates it.

  *Default*: `TRUE`

## Value

Invisibly returns the normalized path to the directory, relative to the
active project.
