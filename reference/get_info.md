# Get Information About an Item by ID

Retrieve information about an item from a table of tables (TOT) based on
its ID.

## Usage

``` r
get_info(id)
```

## Arguments

- id:

  A positive integer representing the unique identifier of the item.
  Must be supplied, else the function will throw an error.

## Value

A list containing all columns from the TOT for the specified ID. The
columns are (in order): id, type, name, caption

## Examples

``` r
if (FALSE) { # \dontrun{
 info <- get_info(1)
 print(info$caption) # Access the caption of the item
} # }
```
