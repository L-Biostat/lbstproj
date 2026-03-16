# INPUT VALIDATION ---------------------------------------------------------------

test_that("type must be a single string", {
  expect_error(run_all_files(1), "`type` must be a single character string")
  expect_error(run_all_files(c("figure", "table")), "`type` must be a single character string")
  expect_error(run_all_files(NA_character_), "`type` must be a single character string")
})

test_that("glob must be a single string", {
  local_lbstproj_project(with_tot = TRUE)
  import_tot(quiet = TRUE)
  expect_error(run_all_files("figure", glob = 1), "`glob` must be a single character string")
  expect_error(run_all_files("figure", glob = c("*.R", "*.r")), "`glob` must be a single character string")
})

# DIRECTORY ----------------------------------------------------------------------

test_that("errors when the type's directory does not exist", {
  local_lbstproj_project(empty_dirs = FALSE)
  expect_error(run_all_files("figure"), "R/figures")
  expect_error(run_all_files("table"), "R/tables")
})

test_that("errors when a custom type's directory does not exist", {
  local_lbstproj_project()
  expect_error(run_all_files("model"), "R/models")
})

# SOURCING -----------------------------------------------------------------------

test_that("sources all R scripts in the directory", {
  local_lbstproj_project(with_tot = TRUE)
  import_tot(quiet = TRUE)
  writeLines('writeLines("done", "sentinel.txt")', "R/figures/fig1.R")
  run_all_files("figure", quiet = TRUE)
  expect_true(fs::file_exists("sentinel.txt"))
})

test_that("sources multiple scripts in sorted order", {
  local_lbstproj_project(with_tot = TRUE)
  import_tot(quiet = TRUE)
  writeLines('cat("a\n", file = "order.txt", append = TRUE)', "R/figures/fig-a.R")
  writeLines('cat("b\n", file = "order.txt", append = TRUE)', "R/figures/fig-b.R")
  run_all_files("figure", quiet = TRUE)
  expect_equal(readLines("order.txt"), c("a", "b"))
})

test_that("returns sourced file paths invisibly", {
  local_lbstproj_project(with_tot = TRUE)
  import_tot(quiet = TRUE)
  writeLines("1 + 1", "R/figures/fig1.R")
  result <- run_all_files("figure", quiet = TRUE)
  expect_equal(length(result), 1L)
  expect_equal(fs::path_file(result), "fig1.R")
})

test_that("returns empty vector when directory has no matching files", {
  local_lbstproj_project(with_tot = TRUE)
  import_tot(quiet = TRUE)
  result <- run_all_files("figure", quiet = TRUE)
  expect_equal(length(result), 0L)
})

# TYPE TO SUBDIRECTORY MAPPING ---------------------------------------------------

test_that("type='figure' targets R/figures/", {
  local_lbstproj_project(with_tot = TRUE)
  import_tot(quiet = TRUE)
  writeLines('writeLines("fig", "type-fig.txt")', "R/figures/fig1.R")
  run_all_files("figure", quiet = TRUE)
  expect_true(fs::file_exists("type-fig.txt"))
})

test_that("type='table' targets R/tables/", {
  local_lbstproj_project(with_tot = TRUE)
  import_tot(quiet = TRUE)
  writeLines('writeLines("tab", "type-tab.txt")', "R/tables/tab1.R")
  run_all_files("table", quiet = TRUE)
  expect_true(fs::file_exists("type-tab.txt"))
})

test_that("type='data' targets R/data/", {
  local_lbstproj_project()
  writeLines('writeLines("dat", "type-dat.txt")', "R/data/dat1.R")
  run_all_files("data", quiet = TRUE)
  expect_true(fs::file_exists("type-dat.txt"))
})

test_that("custom type targets R/<type>s/", {
  local_lbstproj_project()
  fs::dir_create("R/models")
  writeLines('writeLines("mdl", "type-mdl.txt")', "R/models/mdl1.R")
  run_all_files("model", quiet = TRUE)
  expect_true(fs::file_exists("type-mdl.txt"))
})

# GLOB FILTERING -----------------------------------------------------------------

test_that("glob filters which files are sourced", {
  local_lbstproj_project()
  writeLines('writeLines("a", "glob-a.txt")', "R/data/dat-a.R")
  writeLines('writeLines("b", "glob-b.txt")', "R/data/dat-b.R")
  writeLines('writeLines("x", "glob-x.txt")', "R/data/other.R")
  run_all_files("data", glob = "dat-*.R", quiet = TRUE)
  expect_true(fs::file_exists("glob-a.txt"))
  expect_true(fs::file_exists("glob-b.txt"))
  expect_false(fs::file_exists("glob-x.txt"))
})

test_that("returns only files matching the glob", {
  local_lbstproj_project()
  writeLines("1 + 1", "R/data/dat1.R")
  writeLines("1 + 1", "R/data/dat2.R")
  result <- run_all_files("data", glob = "dat1.R", quiet = TRUE)
  expect_equal(length(result), 1L)
  expect_equal(fs::path_file(result), "dat1.R")
})

test_that("returns empty vector when no files match the glob", {
  local_lbstproj_project()
  writeLines("1 + 1", "R/data/dat1.R")
  result <- run_all_files("data", glob = "tab-*.R", quiet = TRUE)
  expect_equal(length(result), 0L)
})

# QUIET ARGUMENT -----------------------------------------------------------------

test_that("quiet=FALSE produces messages with project-relative paths", {
  local_lbstproj_project()
  writeLines("1 + 1", "R/data/dat1.R")
  expect_message(run_all_files("data", quiet = FALSE), "R/data")
})

test_that("quiet=TRUE suppresses messages", {
  local_lbstproj_project()
  writeLines("1 + 1", "R/data/dat1.R")
  expect_no_message(run_all_files("data", quiet = TRUE))
})

test_that("lbstproj.quiet option is respected", {
  local_lbstproj_project()
  withr::with_options(
    list(lbstproj.quiet = TRUE),
    expect_no_message(run_all_files("data"))
  )
})

# TOT COMPARISON -----------------------------------------------------------------

test_that("warns when a file in the directory is not in the ToT and shows a stable path", {
  local_lbstproj_project(with_tot = TRUE)
  import_tot(quiet = TRUE)
  # fig1 is in the ToT; fig-extra is not
  writeLines("1 + 1", "R/figures/fig1.R")
  writeLines("1 + 1", "R/figures/fig-extra.R")
  expect_message(
    run_all_files("figure", quiet = TRUE),
    "R/figures"
  )
})

test_that("no warning when all directory files are present in the ToT", {
  local_lbstproj_project(with_tot = TRUE)
  import_tot(quiet = TRUE)
  writeLines("1 + 1", "R/figures/fig1.R")
  expect_no_message(run_all_files("figure", quiet = TRUE))
})

test_that("no warning when the ToT has entries absent from the directory", {
  local_lbstproj_project(with_tot = TRUE)
  import_tot(quiet = TRUE)
  # fig1 is in the ToT but R/figures/ is empty -> no warning expected
  expect_no_message(run_all_files("figure", quiet = TRUE))
})

test_that("non-figure/table types skip the ToT comparison", {
  local_lbstproj_project()
  # Any file name in R/data/ should produce no ToT-related message
  writeLines("1 + 1", "R/data/no-tot-check.R")
  expect_no_message(run_all_files("data", quiet = TRUE))
})

# ERROR HANDLING -----------------------------------------------------------------

test_that("continues sourcing after a script error", {
  local_lbstproj_project()
  writeLines("stop('oops')", "R/data/dat1.R")
  writeLines('writeLines("ran", "after-error.txt")', "R/data/dat2.R")
  suppressMessages(run_all_files("data", quiet = TRUE))
  expect_true(fs::file_exists("after-error.txt"))
})

test_that("emits a message for each failed script, even when quiet=TRUE", {
  local_lbstproj_project()
  writeLines("stop('something went wrong')", "R/data/dat1.R")
  expect_message(
    run_all_files("data", quiet = TRUE),
    "dat1"
  )
})

test_that("error message includes the original error condition message", {
  local_lbstproj_project()
  writeLines("stop('my custom error')", "R/data/dat1.R")
  expect_message(
    run_all_files("data", quiet = TRUE),
    "my custom error"
  )
})

test_that("successful scripts still run when another script errors", {
  local_lbstproj_project()
  writeLines('writeLines("before", "before.txt")', "R/data/dat1.R")
  writeLines("stop('boom')", "R/data/dat2.R")
  writeLines('writeLines("after", "after.txt")', "R/data/dat3.R")
  suppressMessages(run_all_files("data", quiet = TRUE))
  expect_true(fs::file_exists("before.txt"))
  expect_true(fs::file_exists("after.txt"))
})

test_that("returns all file paths even when some scripts error", {
  local_lbstproj_project()
  writeLines("stop('err')", "R/data/dat1.R")
  writeLines("1 + 1", "R/data/dat2.R")
  result <- suppressMessages(run_all_files("data", quiet = TRUE))
  expect_equal(length(result), 2L)
})

test_that("no error message when all scripts succeed", {
  local_lbstproj_project()
  writeLines("1 + 1", "R/data/dat1.R")
  expect_no_message(run_all_files("data", quiet = TRUE))
})

# WRAPPERS -----------------------------------------------------------------------

test_that("run_all_figures() sources files in R/figures/", {
  local_lbstproj_project(with_tot = TRUE)
  import_tot(quiet = TRUE)
  writeLines('writeLines("fig", "wrapper-fig.txt")', "R/figures/fig1.R")
  run_all_figures(quiet = TRUE)
  expect_true(fs::file_exists("wrapper-fig.txt"))
})

test_that("run_all_figures() glob argument is passed through", {
  local_lbstproj_project(with_tot = TRUE)
  import_tot(quiet = TRUE)
  writeLines('writeLines("a", "wrapper-a.txt")', "R/figures/fig1.R")
  writeLines('writeLines("x", "wrapper-x.txt")', "R/figures/other.R")
  run_all_figures(glob = "fig*.R", quiet = TRUE)
  expect_true(fs::file_exists("wrapper-a.txt"))
  expect_false(fs::file_exists("wrapper-x.txt"))
})

test_that("run_all_tables() sources files in R/tables/", {
  local_lbstproj_project(with_tot = TRUE)
  import_tot(quiet = TRUE)
  writeLines('writeLines("tab", "wrapper-tab.txt")', "R/tables/tab1.R")
  run_all_tables(quiet = TRUE)
  expect_true(fs::file_exists("wrapper-tab.txt"))
})

test_that("run_all_tables() glob argument is passed through", {
  local_lbstproj_project(with_tot = TRUE)
  import_tot(quiet = TRUE)
  writeLines('writeLines("a", "wrapper-tab-a.txt")', "R/tables/tab1.R")
  writeLines('writeLines("x", "wrapper-tab-x.txt")', "R/tables/other.R")
  run_all_tables(glob = "tab*.R", quiet = TRUE)
  expect_true(fs::file_exists("wrapper-tab-a.txt"))
  expect_false(fs::file_exists("wrapper-tab-x.txt"))
})
