test_that("Figure files are created", {
  tmp <- withr::local_tempdir()
  create_project(
    path = tmp,
    author = "Test Author",
    title = "Test Project",
    client = "Test Client",
    department = "TEST",
    version = "1.0",
    open = FALSE,
    force = TRUE,
    quiet = TRUE
  )
  create_figure(name = "example_figure", open = FALSE, quiet = TRUE)
  fig_path <- file.path(tmp, "R", "figures", "example_figure.R")
  expect_true(file.exists(fig_path), info = "Figure R file exists")
})

test_that("Data files are created", {
  tmp <- withr::local_tempdir()
  create_project(
    path = tmp,
    author = "Test Author",
    title = "Test Project",
    client = "Test Client",
    department = "TEST",
    version = "1.0",
    open = FALSE,
    force = TRUE,
    quiet = TRUE
  )
  create_data(name = "example_data", open = FALSE, quiet = TRUE)
  data_path <- file.path(tmp, "R", "data", "example_data.R")
  expect_true(file.exists(data_path), info = "Data R file exists")
})
