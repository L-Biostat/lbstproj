# Archive a rendered report

Moves a rendered report from the `report/` directory to the
`results/reports/` directory and renames it to include the current date
and project version. This function is typically used after rendering a
report with
[`run_report()`](https://l-biostat.github.io/lbstproj/reference/run_report.md),
to save a copy of the rendered output.

## Usage

``` r
archive_report(
  file = NULL,
  overwrite = FALSE,
  quiet = getOption("lbstproj.quiet", FALSE)
)
```

## Arguments

- file:

  *Character* or `NULL`. The name of the report file to archive. If
  `NULL`, the most recently modified rendered report in `report/` is
  used.

- overwrite:

  *Logical*. Indicate whether to overwrite an existing archive file.

  *Default*: `FALSE`, an error is raised if the archive file already
  exists.

- quiet:

  *Logical*. If `TRUE`, suppress informational messages. Important
  messages (e.g. directory creation or errors) are still shown.

  *Default*: `FALSE` unless the global option `lbstproj.quiet` is set
  otherwise.
