# Save a report file

Rename a report file located in the `report/` directory to a unique name
including the current date and project version. This function is used
when the current version of a report needs to be preserved before making
further changes (e.g. write methodology, document new analyses, ...),
because
[`create_report()`](https://l-biostat.github.io/lbstproj/reference/create_report.md)
will automatically overwrite existing report file.

## Usage

``` r
save_report(file = "report.qmd", overwrite = FALSE)
```

## Arguments

- file:

  The name of the report file to save. Default is `"report.qmd"`.

- overwrite:

  Logical indicating whether to overwrite an existing file. Defaults to
  `FALSE`, so an error is raised if the target file already exists.

## Examples

``` r
if (FALSE) { # \dontrun{
# Creates a file named like "report_interim_2024_06_15_v1.0.0.qmd" in the
# same folder
save_report("report_interim.qmd")
} # }
```
