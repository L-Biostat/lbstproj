# Create a R script pre-filled with boilerplate code

A family of helpers that write a minimal R script into a project
subfolder under `R/`: figures, tables, functions, and data.

## Usage

``` r
create_figure(name, open = rlang::is_interactive(), ...)

create_table(name, open = rlang::is_interactive(), ...)

create_function(name, open = rlang::is_interactive(), ...)

create_data(name, open = rlang::is_interactive(), ...)

create_model(name, open = rlang::is_interactive(), ...)
```

## Arguments

- name:

  Name of the script (without file extension).

- open:

  Whether to open the new file in the editor. Defaults to `TRUE` if in
  an interactive session (i.e. in RStudio and other IDEs).

- ...:

  Additional arguments passed to the template rendering function. See
  details.

- print:

  Whether to print (default: `TRUE`) a success message to the console.
  You can set a default print behavior for all functions in this family
  by setting the global option `use.print` to `TRUE` or `FALSE`.

## Details

These functions are called for their side effects: they create a new
script, make parent directories if needed, and (optionally) open the
file. They do not return a value.

When creating a new *table* or a new *figure* script, you can pass the
additional argument `id`. It will be used to retrieve caption and label
information from the table of tables of the project. This allow dynamic
changes to captions and labels in a single place (i.e. the table of
tables).

## Functions

- `create_figure()`: Create a figure script in `R/figures/`.

- `create_table()`: Create a table script in `R/tables/`.

- `create_function()`: Create a function script in `R/functions/`.

- `create_data()`: Create a data script in `R/data/`.

- `create_model()`: Create a model script in `R/models/`.

## Examples

``` r
if (FALSE) { # \dontrun{
create_figure("eda_hist01")
create_table("summary_endpoints", open = FALSE)
create_function("strings_utils")
} # }
```
