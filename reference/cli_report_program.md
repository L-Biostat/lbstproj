# CLI report for create_programs() sync step

CLI report for create_programs() sync step

## Usage

``` r
cli_report_program(
  type,
  n_tot,
  n_disk,
  matched = character(),
  new = character(),
  extra = character(),
  dry_run = FALSE
)
```

## Arguments

- type:

  One of "tables" or "figures".

- n_tot:

  Number of programs declared in TOT.

- n_disk:

  Number of .R files found on disk.

- matched:

  Character vector of filenames both in TOT and on disk.

- new:

  Character vector of filenames to create.

- extra:

  Character vector of filenames on disk but not in TOT.

- dry_run:

  Logical.

- max_print:

  Integer. Max number of filenames to print.

## Value

Invisibly returns a list with counts.
