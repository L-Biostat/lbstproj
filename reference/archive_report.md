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

## Value

Invisibly returns the path to the archived report file.

## Examples

``` r
with_example_project({
  # Create two report files; make the first one older
  writeLines("<html><body>Report v1</body></html>", "report/report-v1.html")
  fs::file_touch(
    "report/report-v1.html",
    modification_time = Sys.time() - 60
  )
  writeLines("<html><body>Report v2</body></html>", "report/report-v2.html")

  # Print the modification time
  print(fs::file_info(fs::dir_ls("report"))[c("path", "modification_time")])

  # Before archival the dir is empty
  fs::dir_tree("results/reports")

  # ´archive_report()´ automatically selects the latest report created (v2)
  archive_report()

  # After archival, the report has been moved and renamed with version
  fs::dir_tree("results/reports")
})
#> ✔ Setting active project to "/home/runner/work/lbstproj/lbstproj".
#> # A tibble: 3 × 2
#>   path                  modification_time  
#>   <fs::path>            <dttm>             
#> 1 report/report-v1.html 2026-05-06 11:18:25
#> 2 report/report-v2.html 2026-05-06 11:19:25
#> 3 report/utils          2026-05-06 11:19:25
#> results/reports
#> ✔ Report archived at results/reports/report-v2_v0.1.0.html.
#> results/reports
#> └── report-v2_v0.1.0.html
```
