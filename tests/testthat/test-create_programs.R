test_that("create_programs creates missing scripts from tot.xlsx", {
  local_lbstproj_project(with_tot = TRUE)

  import_tot()
  create_programs(dry_run = FALSE)

  expect_true(fs::file_exists("R/figures/fig1.R"))
  expect_true(fs::file_exists("R/tables/tab1.R"))
})
