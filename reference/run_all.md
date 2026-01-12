# Run All R Scripts

Run all R scripts in a directory in the `R` folder.

The functions `run_all_figures()` and `run_all_tables()` are wrappers
around the more general `run_all()` function to run all R scripts in the
`R/figures` or `R/tables` directories, respectively.

For these two cases, the function checks for discrepancies between the
files in the directory and the table of tables (ToT) before running the
scripts and throws a warning if any are found.

## Usage

``` r
run_all(dir, skip = NULL)

run_all_figures(skip = NULL)

run_all_tables(skip = NULL)
```

## Arguments

- dir:

  Character. The directory to run the scripts from. Must be an existing
  directory in the `R` folder of the project. For example, `"figures"`
  will run all scripts in `R/figures`.

- skip:

  Optional integer. Number of scripts to skip from the start. Default is
  `NULL` meaning all scripts are run.

## Details

All R scripts are found by matching `*.R` in the respective directory.
Therefore, any file ending in `.r` (techically valid but not
recommended) will be ignored.

## Functions

- `run_all_figures()`: run all R scripts in `R/figures`

- `run_all_tables()`: run all R scripts in `R/tables`

## Examples

``` r
if (FALSE) { # \dontrun{
run_all("figures")
run_all_figures() # equivalent to previous
run_all("data")
run_all("directory-that-does-not-exist") # throws an error
run_all_tables(skip = 3) # starts from the 4th script
} # }
```
