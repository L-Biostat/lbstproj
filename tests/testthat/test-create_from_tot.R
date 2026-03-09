test_that("create_from_tot() does not create files in dry_run mode", {
  local_lbstproj_project()

  tot <- data.frame(
    id = c("F01", "T01"),
    name = c("fig-test", "tab-test"),
    type = c("figure", "table")
  )

  local_mocked_bindings(
    load_tot = function() tot
  )

  create_from_tot(dry_run = TRUE, quiet = TRUE)

  expect_false(fs::file_exists("R/figures/fig-test.R"))
  expect_false(fs::file_exists("R/tables/tab-test.R"))
})

test_that("create_from_tot() creates missing scripts", {
  local_lbstproj_project()

  tot <- data.frame(
    id = c("F01", "T01"),
    name = c("fig-test", "tab-test"),
    type = c("figure", "table")
  )

  local_mocked_bindings(
    load_tot = function() tot
  )

  create_from_tot(dry_run = FALSE, quiet = TRUE)

  expect_true(fs::file_exists("R/figures/fig-test.R"))
  expect_true(fs::file_exists("R/tables/tab-test.R"))
})

test_that("create_from_tot() does not overwrite existing scripts", {
  local_lbstproj_project(with_tot = FALSE)

  fs::dir_create("R/figures")

  writeLines("original", "R/figures/fig-test.R")

  tot <- data.frame(
    id = "1",
    name = "fig-test",
    type = "figure"
  )

  local_mocked_bindings(
    load_tot = function() tot
  )

  create_from_tot(dry_run = FALSE, quiet = TRUE)

  expect_equal(readLines("R/figures/fig-test.R"), "original")
})


# ---- cli_report_program() ------------------------------------------------------

test_that("cli_report_program()", {
  expect_snapshot(
    cli_report_program(
      type = "tables",
      n_tot = 3,
      n_disk = 2,
      matched = c("tab_a.R", "tab_b.R"),
      new = "tab_c.R",
      extra = "tab_old.R",
      dry_run = TRUE
    )
  )

  expect_snapshot(
    cli_report_program(
      type = "tables",
      n_tot = 0,
      n_disk = 0,
      matched = character(),
      new = character(),
      extra = character(),
      dry_run = TRUE
    )
  )

  expect_snapshot(
    cli_report_program(
      type = "figures",
      n_tot = 2,
      n_disk = 1,
      matched = "fig_a.R",
      new = "fig_b.R",
      extra = character(),
      dry_run = FALSE
    )
  )
})
