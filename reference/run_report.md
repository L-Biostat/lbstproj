# Render a quarto report

Renders a quarto (`.qmd`) report file located in the `report/`
directory. The rendered output is saved in the same `report/` directory
under the same name (with a different extension).

All report files are render to a file with the same name. If such a file
already exists, it will be overwritten without warning. If you want to
keep a copy of the rendered report, use the
[`archive_report()`](https://l-biostat.github.io/lbstproj/reference/archive_report.md)
function after rendering to move it to the `results/reports/` directory
with a unique name.

## Usage

``` r
run_report(
  file = "report.qmd",
  quiet = getOption("lbstproj.quiet", FALSE),
  ...
)
```

## Arguments

- file:

  *Character*. The name of the report file to render. If this file isn't
  found, the function throws an error.

  *Default*: `"report.qmd"`, the default name produced by
  [`create_report()`](https://l-biostat.github.io/lbstproj/reference/create_report.md)

- quiet:

  *Logical*. If `TRUE`, suppress informational messages. Important
  messages (e.g. directory creation or errors) are still shown.

  *Default*: `FALSE` unless the global option `lbstproj.quiet` is set
  otherwise.

- ...:

  Additional arguments passed to the rendering function, in this case,
  [`quarto::quarto_render()`](https://quarto-dev.github.io/quarto-r/reference/quarto_render.html).

## Examples

``` r
if (FALSE) { # \dontrun{
# Default usage
run_report()
# Rendering a specific file to a specific name
run_report(file = "new_report.qmd", output_file = "final_report_FINAL_v3.0")
} # }
```
