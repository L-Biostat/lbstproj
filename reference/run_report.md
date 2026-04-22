# Render a report

Renders a report file located in the `report/` directory. The rendered
output is saved in the same `report/` directory under the same name
(with a different extension).

If `file` is not supplied, the most recently modified report file
(`.qmd` or `.Rmd`) in `report/` is rendered.

- **gt projects** produce a Quarto (`.qmd`) report rendered via
  [`quarto::quarto_render()`](https://quarto-dev.github.io/quarto-r/reference/quarto_render.html).

- **flextable projects** produce an R Markdown (`.Rmd`) report rendered
  via
  [`rmarkdown::render()`](https://pkgs.rstudio.com/rmarkdown/reference/render.html).

## Usage

``` r
run_report(file = NULL, quiet = getOption("lbstproj.quiet", FALSE), ...)
```

## Arguments

- file:

  *Character* or `NULL`. The name of the report file to render. If
  `NULL`, the most recently modified `.qmd` or `.Rmd` report in
  `report/` is used.

- quiet:

  *Logical*. If `TRUE`, suppress informational messages. Important
  messages (e.g. directory creation or errors) are still shown.

  *Default*: `FALSE` unless the global option `lbstproj.quiet` is set
  otherwise.

- ...:

  Additional arguments passed to the rendering function
  ([`quarto::quarto_render()`](https://quarto-dev.github.io/quarto-r/reference/quarto_render.html)
  for `.qmd` files,
  [`rmarkdown::render()`](https://pkgs.rstudio.com/rmarkdown/reference/render.html)
  for `.Rmd` files).

## Value

Invisibly returns the path to the report file.

## Examples

``` r
if(FALSE) {
  run_report()
  run_report(file = "report_2026_03_16.qmd")
  run_report(file = "report_2026_03_16.Rmd")
}
```
