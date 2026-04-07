# Table engine helpers

`get_table_engine()` reads the `TableEngine` field from the active
project's `DESCRIPTION` file and returns its value. If the field is
absent (e.g. in legacy projects), it returns `"gt"` silently for
backwards compatibility.

`is_gt_project()` returns `TRUE` if the project's `TableEngine` is
`"gt"`.

`is_flextable_project()` returns `TRUE` if the project's `TableEngine`
is `"flextable"`.

## Usage

``` r
get_table_engine()

is_gt_project()

is_flextable_project()
```

## Value

`get_table_engine()` returns a single character string: `"gt"` or
`"flextable"`.

`is_gt_project()` and `is_flextable_project()` return a single logical.

## See also

`is_gt_project()`, `is_flextable_project()`

## Examples

``` r
if (FALSE) {
  get_table_engine()
  is_gt_project()
  is_flextable_project()
}
```
