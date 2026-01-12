# Create a DESCRIPTION file for the project

`create_description()` creates a `DESCRIPTION` file in the project,
using the project root directory as "package name" and adding the
fields: Title, Author, Client, and Department. The function does not
check arguments for validity. It assumes that they are checked in the
[`create_project()`](https://l-biostat.github.io/lbstproj/reference/create_project.md)
function.

## Usage

``` r
create_description(title, client, department, author, version, quiet = FALSE)
```
