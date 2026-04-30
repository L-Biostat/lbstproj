test_that("load_function() errors on missing file", {
  local_lbstproj_project(with_tot = FALSE)
  expect_error(load_function("nonexistent"), "does not exist")
})

test_that("load_function() sources a file from R/functions/", {
  local_lbstproj_project(with_tot = FALSE)
  fs::dir_create("R/functions")
  writeLines("lbst_test_fn <- function() 42L", "R/functions/helpers.R")

  path <- load_function("helpers", quiet = TRUE)

  expect_equal(path, usethis::proj_path("R/functions/helpers.R"))
  expect_equal(lbst_test_fn(), 42L)
  rm(lbst_test_fn, envir = .GlobalEnv)
})

test_that("load_function() accepts name with .R extension", {
  local_lbstproj_project(with_tot = FALSE)
  fs::dir_create("R/functions")
  writeLines("lbst_test_fn2 <- function() 99L", "R/functions/helpers.R")

  expect_no_error(load_function("helpers.R", quiet = TRUE))
  rm(lbst_test_fn2, envir = .GlobalEnv)
})

test_that("load_all_functions() errors when R/functions/ is missing", {
  local_lbstproj_project(with_tot = FALSE, empty_dirs = FALSE)
  expect_error(load_all_functions(), "does not exist")
})

test_that("load_all_functions() sources all R files", {
  local_lbstproj_project(with_tot = FALSE)
  fs::dir_create("R/functions")
  writeLines("lbst_fn_a <- function() 'a'", "R/functions/a.R")
  writeLines("lbst_fn_b <- function() 'b'", "R/functions/b.R")

  paths <- load_all_functions(quiet = TRUE)

  expect_length(paths, 2L)
  expect_equal(lbst_fn_a(), "a")
  expect_equal(lbst_fn_b(), "b")
  rm(lbst_fn_a, lbst_fn_b, envir = .GlobalEnv)
})

test_that("load_all_functions() handles empty R/functions/ gracefully", {
  local_lbstproj_project(with_tot = FALSE)
  fs::dir_create("R/functions")

  result <- load_all_functions(quiet = TRUE)
  expect_equal(result, character())
})
