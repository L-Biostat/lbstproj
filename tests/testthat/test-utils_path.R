# ensure_dir_exists --------------------------------------------------------------

test_that("ensure_dir_exists() validates input type", {
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

# validate_file_name -------------------------------------------------------------

test_that("validate_file_name() validates input type", {
  expect_error(
    validate_file_name(5),
    "`name` must be a single character string."
  )
})

test_that("validate_file_name() removes extensions", {
  name <- "testfile.R"
  expect_equal(
    validate_file_name(name),
    "testfile"
  )
})

test_that("validate_file_name() only accepts alphanumeric, _, and -", {
  expect_no_error(validate_file_name("new-plot-20.png"))
  expect_error(validate_file_name("analysis_01/01/2001.R"))
})

# CHECK OVERWRITE ----------------------------------------------------------------

test_that("check_can_overwrite() does nothing when file does not exist", {
  local_lbstproj_project(with_tot = FALSE)

  path <- fs::path("data", "processed", "test.rds")

  expect_no_error(
    check_can_overwrite(path, overwrite = FALSE)
  )
})

test_that("check_can_overwrite() errors when file exists and overwrite = FALSE", {
  local_lbstproj_project(with_tot = FALSE)

  ensure_dir_exists("data/processed", create = TRUE)
  path <- fs::path("data", "processed", "test.rds")
  saveRDS(data.frame(x = 1), path)

  expect_error(
    check_can_overwrite(path, overwrite = FALSE),
    "already exists"
  )
})

test_that("check_can_overwrite() does not error when file exists and overwrite = TRUE", {
  local_lbstproj_project(with_tot = FALSE)

  ensure_dir_exists("data/processed", create = TRUE)
  path <- fs::path("data", "processed", "test.rds")
  saveRDS(data.frame(x = 1), path)

  expect_no_error(
    check_can_overwrite(path, overwrite = TRUE)
  )
})
