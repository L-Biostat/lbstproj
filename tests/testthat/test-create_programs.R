test_that("Missing scripts are created", {
  local_lbstproj_project(with_tot = TRUE)

  import_tot(quiet = TRUE)
  create_programs(dry_run = FALSE, print = FALSE)

  expect_true(fs::file_exists("R/figures/fig1.R"))
  expect_true(fs::file_exists("R/tables/tab1.R"))
})

test_that("Nothing is created in a dry run", {
  local_lbstproj_project(with_tot = TRUE)

  import_tot(quiet = TRUE)
  create_programs(dry_run = TRUE, print = FALSE)

  expect_false(fs::file_exists("R/figures/fig1.R"))
  expect_false(fs::file_exists("R/tables/tab1.R"))
})
