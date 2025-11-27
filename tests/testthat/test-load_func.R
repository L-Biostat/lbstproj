test_that("All functions are loaded", {
  tmp <- local_create_project()
  # Create two functions
  writeLines("a <- function() {}", fs::path(tmp, "R/functions/a.R"))
  writeLines("b <- function() {}", fs::path(tmp, "R/functions/b.R"))
  # Load all functions
  load_all_functions()
  # Check if they both exist in the environment
  expect_true(exists("a", mode = "function"))
  expect_true(exists("b", mode = "function"))
})

test_that("Only a single function is loaded", {
  tmp <- local_create_project()
  # Create two functions
  writeLines("a <- function() {}", fs::path(tmp, "R/functions/a.R"))
  writeLines("b <- function() {}", fs::path(tmp, "R/functions/b.R"))
  # Load a single function and check existence
  load_function("a")
  expect_true(exists("a", mode = "function"))
  # Load another function with extension and check existence
  load_function("b.R")
  expect_true(exists("b", mode = "function"))
})

test_that("Absolute file paths fail", {
  tmp <- local_create_project()
  # Create one function
  writeLines("a <- function() {}", fs::path(tmp, "R/functions/a.R"))
  # Check if error when loading with absolute path
  expect_error(
    load_function(fs::path(tmp, "R/functions/a.R"))
  )
})

test_that("Wrong file paths fail", {
  tmp <- local_create_project()
  # Create two functions
  writeLines("a <- function() {}", fs::path(tmp, "R/functions/a.R"))
  # Check if error when loading a non-existent file
  expect_error(
    load_function("c.R"),
    "does not exist"
  )
})
