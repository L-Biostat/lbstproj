# Create a quarto code chunk from the TOT

Generate the quarto code chunk to include a figure or table in a report
based on the information stored in the table of tables (TOT). The
element can be identified by its `id` or `name`. The chunk includes the
correct path to the element as well as the caption and a quarto-safe
chunk label (starting with `tbl` for tables and `fig` for figures to
allow for cross-referencing).

If the function is called from Rstudio or the console, the code chunk is
always copied to the clipboard to easily paste it in the report file if
needed.

## Usage

``` r
create_chunk(
  output_type = "html",
  id = NULL,
  name = NULL,
  print = TRUE,
  pad = TRUE,
  quiet = getOption("lbstproj.quiet", FALSE)
)
```

## Arguments

- output_type:

  *Character*. Output format to use when building the code chunk. Should
  match the output type of the report. Only `"docx"` or `"html"` are
  supported.

  *Default*: `"html"`

- id:

  *Character*. Identifier of the element in the TOT. Either this or the
  `name` must be provided but not both.

- name:

  *Character*. Name of the element in the TOT. Either this or the `id`
  must be provided but not both.

- print:

  *Logical*. If `TRUE`, print the generated chunk to the console.

  *Default*: `TRUE` to allow for quick visual check.

- pad:

  *Logical*. If `TRUE`, add blank lines before and after the chunk and
  insert a page break after it.

  *Default*: `TRUE`

- quiet:

  *Logical*. If `TRUE`, suppress informational messages. Important
  messages (e.g. directory creation or errors) are still shown.

  *Default*: `FALSE` unless the global option `lbstproj.quiet` is set
  otherwise.

## Value

The rendered quarto chunk as a character string, invisibly
