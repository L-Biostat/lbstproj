# Create a quarto code chunk from the TOT

Generate the quarto code chunk to include a figure or table in a report
based on the information in the table of tables (TOT). The TOT-element
is identified from its ID. The chunk includes the correct path to the
element as well as the caption and a quarto-safe chunk label (starting
with `tbl` for tables and `fig` for figures to allow for
cross-referencing).

## Usage

``` r
create_chunk(id, copy = TRUE, print = TRUE, pad = FALSE)
```

## Arguments

- id:

  The id of the element as specified in the table of tables (TOT)

- copy:

  Logical, whether to copy the chunk to the clipboard (default: TRUE if
  in interactive mode, FALSE otherwise)

- print:

  Logical, whether to print the chunk to the console (default: TRUE)

- pad:

  Logical, whether to pad the chunk with blank lines before and after
  and add a page break after (default: FALSE)

## Value

The rendered quarto chunk as a character string, invisibly
