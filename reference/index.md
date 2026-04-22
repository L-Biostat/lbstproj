# Package index

## Project setup

Initialize a new project with a standard folder structure.

- [`create_project()`](https://l-biostat.github.io/lbstproj/reference/create_project.md)
  : Create a New Project

## Creating scripts

Generate R script from templates.

- [`create_file()`](https://l-biostat.github.io/lbstproj/reference/create_file.md)
  : Create an R file from a template
- [`create_from_tot()`](https://l-biostat.github.io/lbstproj/reference/create_from_tot.md)
  : Create all R scripts listed in the table of tables (TOT)

## Saving outputs

Save figures, tables, and datasets to standardized locations.

- [`save_data()`](https://l-biostat.github.io/lbstproj/reference/save_outputs.md)
  [`save_table()`](https://l-biostat.github.io/lbstproj/reference/save_outputs.md)
  [`save_figure()`](https://l-biostat.github.io/lbstproj/reference/save_outputs.md)
  : Save outputs in the project

## Table of Tables

Import and load the Table of Tables (TOT) metadata registry.

- [`import_tot()`](https://l-biostat.github.io/lbstproj/reference/import_tot.md)
  : Import the Table of Tables (TOT)
- [`load_tot()`](https://l-biostat.github.io/lbstproj/reference/load_tot.md)
  : Load the Table of Tables (TOT)
- [`get_info()`](https://l-biostat.github.io/lbstproj/reference/get_info.md)
  : Get information from the Table of Tables (TOT)

## Running scripts

Source all scripts of a given type in batch.

- [`run_all_files()`](https://l-biostat.github.io/lbstproj/reference/run_all_files.md)
  [`run_all_figures()`](https://l-biostat.github.io/lbstproj/reference/run_all_files.md)
  [`run_all_tables()`](https://l-biostat.github.io/lbstproj/reference/run_all_files.md)
  : Run R Scripts in a Project Subdirectory

## Reporting

Generate, render, and archive Quarto reports.

- [`create_report()`](https://l-biostat.github.io/lbstproj/reference/create_report.md)
  : Create a report from the TOT
- [`create_chunk()`](https://l-biostat.github.io/lbstproj/reference/create_chunk.md)
  : Create a code chunk from the TOT
- [`run_report()`](https://l-biostat.github.io/lbstproj/reference/run_report.md)
  : Render a report
- [`archive_report()`](https://l-biostat.github.io/lbstproj/reference/archive_report.md)
  : Archive a rendered report

## Table engine

Query and check the table rendering engine configured for the project.

- [`get_table_engine()`](https://l-biostat.github.io/lbstproj/reference/get_table_engine.md)
  : Get the table engine for the active project
- [`is_gt_project()`](https://l-biostat.github.io/lbstproj/reference/is_gt_project.md)
  [`is_flextable_project()`](https://l-biostat.github.io/lbstproj/reference/is_gt_project.md)
  : Test whether the active project uses a given table engine

## Options

Package-level global options.

- [`lbstproj-options`](https://l-biostat.github.io/lbstproj/reference/lbstproj-options.md)
  : Package-wide options for lbstproj
