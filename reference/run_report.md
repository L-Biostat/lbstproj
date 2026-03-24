# Render a quarto report

Renders a quarto (`.qmd`) report file located in the `report/`
directory. The rendered output is saved in the same `report/` directory
under the same name (with a different extension).

If `file` is not supplied, the most recently modified report file in
`report/` is rendered. Rendered outputs keep the same date-stamped stem
as the input `.qmd` file.

## Usage

``` r
run_report(file = NULL, quiet = getOption("lbstproj.quiet", FALSE), ...)
```

## Arguments

- file:

  *Character* or `NULL`. The name of the report file to render. If
  `NULL`, the most recently modified `.qmd` report in `report/` is used.

- quiet:

  *Logical*. If `TRUE`, suppress informational messages. Important
  messages (e.g. directory creation or errors) are still shown.

  *Default*: `FALSE` unless the global option `lbstproj.quiet` is set
  otherwise.

- ...:

  Additional arguments passed to the rendering function, in this case,
  [`quarto::quarto_render()`](https://quarto-dev.github.io/quarto-r/reference/quarto_render.html).

## Value

Invisibly returns the path to the report file.

## Examples

``` r
if(FALSE) {
  run_report()
  run_report(file = "html_report_2026_03_16.qmd")
  run_report(file = "new_report.qmd", output_file = "final_report_FINAL_v3.0")
}
```
