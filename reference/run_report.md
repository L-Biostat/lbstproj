# Render a Rmd/qmd report

Renders a report file located in the `report/` directory. The report can
be either an R Markdown (`.Rmd`) or Quarto (`.qmd`) file. The rendered
output is saved in the same `report/` directory under the same name
(with a different extension).

## Usage

``` r
run_report(file = "report.qmd", ...)
```

## Arguments

- file:

  The name of the report file to render. Default is `"report.qmd"`. If
  this file isn't found, the function looks for a file with the same
  name but with a `.Rmd` extension before throwing an error.

- ...:

  Additional arguments passed to the rendering function. For R Markdown
  files, these are passed to
  [`rmarkdown::render()`](https://pkgs.rstudio.com/rmarkdown/reference/render.html).
  For Quarto files, these are passed to `quarto::quarto_render()`.

## Details

All report files are render to a file with the same name. If such a file
already exists, it will be overwritten without warning. If you want to
keep a copy of the rendered report, use the
[`archive_report()`](https://l-biostat.github.io/lbstproj/reference/archive_report.md)
function after rendering to move it to the `results/reports/` directory
with a unique name.

## Examples

``` r
if (FALSE) { # \dontrun{
# Default usage
run_report()
# Rendering a specific R Markdown file to pdf
run_report(file = "pdf_report.Rmd", output_format = "pdf_document")
} # }
```
