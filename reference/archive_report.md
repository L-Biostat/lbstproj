# Archive a rendered report

Moves a rendered report from the `report/` directory to the
`results/reports/` directory and renames it to include the current date
and project version. This function is typically used after rendering a
report with
[`run_report()`](https://l-biostat.github.io/lbstproj/reference/run_report.md),
to save a copy of the rendered output.

## Usage

``` r
archive_report(file = "report.html", overwrite = FALSE)
```

## Arguments

- file:

  The name of the report file to archive. Default is `"report.html"`.

- overwrite:

  Logical indicating whether to overwrite an existing archive file.
  Defaults to `FALSE`, so an error is raised if the archive file already
  exists.
