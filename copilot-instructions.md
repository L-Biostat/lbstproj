# Copilot Instructions for lbstproj

## What this package does

`lbstproj` is an R package for the L-Biostat group that initializes and
manages standardized statistical analysis projects. It creates project
scaffolding, manages a “Table of Tables” (TOT) metadata tracking system,
provides save/load helpers for outputs, and renders reports.

## Build, test, and lint commands

``` r
# Install dependencies
devtools::install_deps()

# Run all tests
devtools::test()

# Run a single test file
testthat::test_file("tests/testthat/test-save.R")

# Run a single named test
testthat::test_file("tests/testthat/test-save.R", filter = "save_figure")

# Check the package (includes tests, examples, vignettes)
devtools::check()

# Rebuild documentation from roxygen2
devtools::document()

# Build pkgdown site locally
pkgdown::build_site()
```

## Architecture

The package is organized around a **project lifecycle**:

1.  **Initialize** -
    [`create_project()`](https://l-biostat.github.io/lbstproj/reference/create_project.md)
    scaffolds a new project directory with a fixed folder structure, a
    `DESCRIPTION` file, and a `table_of_tables.xlsx` (the TOT).
2.  **Create scripts** -
    [`create_file()`](https://l-biostat.github.io/lbstproj/reference/create_file.md)
    generates R scripts from Mustache templates in `inst/templates/`.
    [`create_from_tot()`](https://l-biostat.github.io/lbstproj/reference/create_from_tot.md)
    auto-generates scripts for all entries in the TOT.
3.  **Save outputs** -
    [`save_figure()`](https://l-biostat.github.io/lbstproj/reference/save_outputs.md),
    [`save_table()`](https://l-biostat.github.io/lbstproj/reference/save_outputs.md),
    [`save_data()`](https://l-biostat.github.io/lbstproj/reference/save_outputs.md)
    write outputs to standardized paths (`output/figures/`,
    `output/tables/`, `data/processed/`).
4.  **Run scripts** - `run_all()`,
    [`run_all_figures()`](https://l-biostat.github.io/lbstproj/reference/run_all_files.md),
    [`run_all_tables()`](https://l-biostat.github.io/lbstproj/reference/run_all_files.md)
    execute all scripts in the relevant `R/` subdirectory.
5.  **Report** -
    [`create_report()`](https://l-biostat.github.io/lbstproj/reference/create_report.md)
    generates a Quarto report from a template;
    [`create_chunk()`](https://l-biostat.github.io/lbstproj/reference/create_chunk.md)
    inserts TOT-linked code chunks;
    [`run_report()`](https://l-biostat.github.io/lbstproj/reference/run_report.md)
    renders it.

**Table of Tables (TOT)**: An Excel file
(`data/tot/table_of_tables.xlsx`) is the central metadata registry. It
tracks every figure and table by `id`, `type`, `name`, and `caption`.
The TOT is loaded/validated via `tot.R` and queried via `get_info.R`.
Test helpers in `helper-project.R` create minimal in-memory TOT
fixtures.

**Template rendering**: `inst/templates/` contains Mustache templates
(`.R` and `.qmd`). They are rendered using the `whisker` package with
variables like `{{name}}`, `{{author}}`, `{{date}}`, `{{caption}}`,
`{{path}}`.

**Project root detection**: Functions rely on `usethis`/`rprojroot`
conventions - an `.Rproj` file or `DESCRIPTION` at the project root
signals the project boundary.

## Key conventions

### File headers

Every R source file begins with an ASCII art header block:

``` r
# |------------┐
#   lbstproj  
# \------------┘
# filename.R: Short description of what this file contains
```

### Documentation

- Roxygen2 with `Roxygen: list(markdown = TRUE)` - all docs use
  markdown.
- Inline formatting uses cli-style markup: `.arg` for arguments, `.val`
  for values, `.file` for paths, `.fn` for function names, `.strong` for
  emphasis.
- Every exported function has `@param`, `@return`, and `@examples`.

### Error handling and messaging

- Use
  [`cli::cli_abort()`](https://cli.r-lib.org/reference/cli_abort.html)
  for errors with context-rich messages.
- Use
  [`cli::cli_alert_success()`](https://cli.r-lib.org/reference/cli_alert.html),
  [`cli::cli_alert_info()`](https://cli.r-lib.org/reference/cli_alert.html),
  [`cli::cli_alert_warning()`](https://cli.r-lib.org/reference/cli_alert.html)
  for user feedback.
- Respect a `quiet` parameter (package option `lbstproj.quiet`) to
  suppress output.

### Testing patterns

- Tests use `testthat` edition 3.
- Test helpers (`tests/testthat/helper-*.R`) define `local_*()`
  functions that create isolated temporary projects and clean up via
  [`withr::local_dir()`](https://withr.r-lib.org/reference/with_dir.html)
  and
  [`usethis::local_project()`](https://usethis.r-lib.org/reference/proj_utils.html).
- Use `local_lbstproj_project(with_tot = TRUE)` to get a full temp
  project with a TOT fixture.
- Tests create temporary file system state in
  [`tempdir()`](https://rdrr.io/r/base/tempfile.html) - never write to
  the package source tree in tests.

### Naming

- All functions: `snake_case`.
- Parameters follow the same conventions as the surrounding codebase
  (`path`, `name`, `id`, `overwrite`, `quiet`, `open`).
- Internal (non-exported) helpers are documented with
  `@keywords internal` and kept in the same file as their primary
  exported function or in `utils.R` / `utils_path.R` / `checks.R`.

### Adding new file types or templates

- Add a new template to `inst/templates/` using Mustache syntax.
- Add the new `type` to the
  [`create_file()`](https://l-biostat.github.io/lbstproj/reference/create_file.md)
  dispatch and document it.
- Add a corresponding `run_all_<type>()` wrapper in `run_all.R` if
  scripts of that type should be bulk-runnable.
