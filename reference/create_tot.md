# Create a Empty Table of Tables (TOT) Excel file in the project

`create_tot()` copies a template TOT Excel file from the `lbstproj`
package to the `data/tot/` directory of your project. The example TOT
file contains an example row for guidance. It should be deleted before
use.

## Usage

``` r
create_tot(quiet = FALSE)
```

## Details

If a "data/tot/" directory does not exist, it will be created. If a TOT
file already exists in the target directory, it will be overwritten.
