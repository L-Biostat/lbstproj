# Create a Quarto report from the TOT

Create a Quarto report by combining a report template with all figures
and tables listed in the table of tables (TOT), in the order they
appear.

Captions and labels are taken from the TOT, so updates to the TOT are
reflected automatically in the generated report.

Generated report files are date-stamped, for example
`report/html_report_2026_03_16.qmd`.

## Usage

``` r
create_report(
  output_type = "html",
  overwrite = FALSE,
  quiet = getOption("lbstproj.quiet", FALSE)
)
```

## Arguments

- output_type:

  *Character*. Output format of the report template. Must be one of
  `"html"` or `"docx"`.

  *Default*: `"html"`.

- overwrite:

  *Logical*. If `TRUE`, overwrite an existing report file with the same
  dated name. If `FALSE`, raise an error instead.

  *Default*: `FALSE`.

- quiet:

  *Logical*. If `TRUE`, suppress informational messages. Important
  messages (e.g. directory creation or errors) are still shown.

  *Default*: `FALSE` unless the global option `lbstproj.quiet` is set
  otherwise.

## Value

Invisibly returns the path to the generated report file.

## Examples

``` r
if(FALSE) {
  create_report()
  create_report(output_type = "docx", overwrite = TRUE)
}
```
