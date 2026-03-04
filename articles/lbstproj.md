# lbstproj

``` r
library(lbstproj)

create_project(
  # path = ".",
  path = tmp_proj_dir,
  title = "FAKE trial",
  client = "John Doe",
  department = "DPT",
  author = "Jane Doe",
  open = FALSE,
  force = TRUE
)
#> Enter project information:
#> ℹ Default values are shown in [brackets]. Press [Enter] to accept the default.
#> Author's email address:
#> ✔ Setting active project to "/tmp/Rtmpenb9JU/mock-lbstproj".
#> ✔ Writing mock-lbstproj.Rproj.
#> ✔ Adding ".Rproj.user" to .gitignore.
#> ✔ Creating project structure
#> ✔ Writing DESCRIPTION
#> ✔ Writing table_of_tables.xlsx to data/tot
#> ✔ Project setup complete! Start working!
```

``` r
fs::dir_tree(fs::path("data"))
#> data
#> ├── figures
#> ├── processed
#> ├── raw
#> ├── tables
#> └── tot
#>     └── table_of_tables.xlsx
```
