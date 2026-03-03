# lbstproj `<img src="man/figures/logo.png" align="right" height="120" alt="" />`

`lbstproj` provides tools to create, maintain, and use standardized R
projects for the L-Biostat group.

## Installation

You can install the development version of `lbstproj` from
[GitHub](https://github.com/L-Biostat/lbstproj) with:

``` r
# install.packages("remotes")
remotes::install_github("L-Biostat/lbstproj")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(lbstproj)
## basic example code
```

# Roadmap

Below is a list of all functions that need to be in the package, along
with their status:

`create_project`

`create_file(type, quiet)`

`save_figure(quiet)`

`save_table(quiet, export)`

`create_from_tot`

`import_tot`

`load_tot`

`get_info`

`get_caption_list`

`run_all_files(type, glob)`

`create_report(type = c("Rmd", "qmd"))`

`create_code_chunk`

`render_report`

`archive_report`
