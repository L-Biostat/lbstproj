# Export a table to `results/tables/`

Save a formatted table to `results/tables/<name>.<ext>`. Supports `gt`
tables via `gt::gtsave()` and `flextable` via the corresponding
`save_as_*()` helpers. The parent directory is created if needed and an
existing file is not overwritten unless `overwrite = TRUE`.

## Usage

``` r
export_table(
  tbl,
  name,
  ext,
  print = NULL,
  overwrite = TRUE,
  landscape = FALSE,
  ...
)
```

## Arguments

- tbl:

  A `gt::gt()` table (`gt_tbl`) or a `flextable::flextable()` object.

- name:

  Name used to save the table (without file extension).

- ext:

  Output format/extension. One of `"docx"`, `"pdf"`, `"html"`, `"rtf"`.

- print:

  Whether to print (default: `TRUE`) a success message to the console.
  You can set a default print behavior for all functions in this family
  by setting the global option `export.print` to `TRUE` or `FALSE`.

- overwrite:

  Whether to overwrite an existing file with the same name. Defaults to
  `FALSE`.

- landscape:

  Logical; for `flextable` exports only, set page orientation to
  landscape. Ignored for `gt` tables.

- ...:

  Additional arguments forwarded to `gt::gtsave()` (for `gt`) or the
  relevant `flextable::save_as_*()` function (for `flextable`).

## Details

The function is called for its side effects and does not return a value.

## See also

`gt::gtsave()`, `flextable::save_as_docx()`,
`flextable::save_as_html()`, `flextable::save_as_rtf()`

## Examples

``` r
if (FALSE) { # \dontrun{
library(gt)
gt_tbl <- head(mtcars) |> gt()
export_table(gt_tbl, name = "mtcars_head", ext = "html")

library(flextable)
ft <- flextable(head(iris))
export_table(ft, name = "iris_doc", ext = "docx", landscape = TRUE)
} # }
```
