# Standardized way to create a Rmd code chunk to insert a figure or a table

Standardized way to create a Rmd code chunk to insert a figure or a
table

## Usage

``` r
create_chunk(id, type, copy = TRUE, print = TRUE, pad = FALSE)
```

## Arguments

- id:

  The id of the figure as specified in the table of tables (TOT)

- type:

  The type of the entry, either "figure" or "table"

- copy:

  Logical, whether to copy the chunk to the clipboard (default: TRUE if
  in interactive mode)

- print:

  Logical, whether to print the chunk to the console (default: TRUE)

- pad:

  Logical, whether to pad the chunk with blank lines before and after
  and a pagebreak after (default: FALSE)

## Value

The rendered Rmd chunk as a character string, invisibly
