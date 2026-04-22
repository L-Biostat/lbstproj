# Get the table engine for the active project

Reads the `TableEngine` field from the project `DESCRIPTION` file and
returns it as a string. When the field is absent (e.g. legacy projects),
it defaults to `"gt"` for backward compatibility.

## Usage

``` r
get_table_engine()
```

## Value

*Character*. `"gt"` or `"flextable"`.
