# Create a quarto report based on the table of tables (TOT)

Creates a quarto report by using a html-report template and including
all elements found in the TOT in the order they appear. All captions and
labels are taken from the TOT, so any changes to those will be reflected
in the report when it is rendered.

## Usage

``` r
create_report()
```

## Details

The report is created in `report/report.qmd`. If a report already
exists, it will be overwritten.
