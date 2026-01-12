# Export a figure to `results/figures/`

Save a publication-ready figure to `results/figures/<name>.<ext>` using
`ggplot2::ggsave()`. The parent directory is created if needed and an
existing file is not overwritten unless `overwrite = TRUE`.

## Usage

``` r
export_figure(
  fig,
  name,
  ext = "png",
  print = NULL,
  width = 8,
  height = 6,
  overwrite = TRUE,
  ...
)
```

## Arguments

- fig:

  A ggplot2::ggplot object.

- name:

  Name used to save the figure (without file extension).

- ext:

  Output format/extension. One of `"png"`, `"pdf"`, `"jpeg"`, `"tiff"`,
  `"bmp"`, `"svg"`. Defaults to `"png"`. (Raster: png/jpeg/tiff/bmp;
  Vector: pdf/svg.)

- print:

  Whether to print (default: `TRUE`) a success message to the console.
  You can set a default print behavior for all functions in this family
  by setting the global option `export.print` to `TRUE` or `FALSE`.

- width, height:

  Plot dimensions passed to `ggplot2::ggsave()` (in inches by default;
  you can pass `units = "cm"` or `units = "mm"` via `...`).

- overwrite:

  Whether to overwrite an existing file with the same name. Defaults to
  `FALSE`.

- ...:

  Additional arguments forwarded to `ggplot2::ggsave()` (e.g., `dpi`,
  `units`, `bg`, `device`).

## Details

The function is called for its side effects and does not return a value.

## See also

`ggplot2::ggsave()`

## Examples

``` r
if (FALSE) { # \dontrun{
library(ggplot2)
p <- ggplot(mtcars, aes(mpg, wt)) + geom_point()
export_figure(p, name = "scatter_mpg_wt", ext = "pdf", width = 7, height = 5)
export_figure(p, name = "scatter_png", dpi = 300)  # defaults to PNG
} # }
```
