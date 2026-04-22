# Check that a table object matches the project's table engine

Validates that `table` has the class expected by the current project
engine: `gt_tbl` for `"gt"` projects and `flextable` for `"flextable"`
projects. Throws a clear `cli_abort()` error when the class does not
match.

## Usage

``` r
check_table_object(table)
```

## Arguments

- table:

  The table object to check.

## Value

Invisibly returns `table` when the check passes.
