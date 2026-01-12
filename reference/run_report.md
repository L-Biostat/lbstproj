# Render the report

Render the Rmd report located at `report/report.Rmd` to the `report/`
directory. Also move and rename the generated report to the
`results/reports/` directory.

## Usage

``` r
run_report(overwrite = FALSE)
```

## Arguments

- overwrite:

  Logical; if `TRUE`, overwrite existing report files in the
  `results/reports/` directory. If `FALSE`, a unique name will be
  generated to avoid overwriting, by appending a counter to the filename
  (e.g. `_001`, `_002`, etc.). Default is `FALSE`.

## Value

The path to the moved and renamed report file, invisibly.
