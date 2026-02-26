test_that("ensure_dir_exists() validates input type", {
  local_lbstproj_project()

  expect_error(
    ensure_dir_exists(5),
    "`path` must be a single character string."
  )
})

test_that("ensure_dir_exists rejects absolute paths", {
  local_lbstproj_project()

  expect_error(
    ensure_dir_exists(usethis::proj_path("R")),
    "Path must be relative to the active project, not absolute."
  )
})

test_that("ensure_dir_exists returns invisibly when directory exists", {
  local_lbstproj_project()

  expect_no_error(ensure_dir_exists("R"))

  expect_invisible(
    ensure_dir_exists("R")
  )
})

test_that("ensure_dir_exists errors if create = FALSE and dir missing", {
  local_lbstproj_project()

  expect_error(
    ensure_dir_exists("B", create = FALSE),
    "Directory 'B' does not exist"
  )
})

test_that("ensure_dir_exists creates directory when missing", {
  local_lbstproj_project()

  expect_message(
    ensure_dir_exists("data/figures2"),
    "Created directory 'data/figures2'"
  )

  expect_true(fs::dir_exists("data/figures2"))
})
