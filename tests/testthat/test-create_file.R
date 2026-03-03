test_that("File type is validated", {
  error_msg <- "`type` must be a single character string."
  expect_error(create_file(1, "name"), error_msg)
  expect_error(create_file(c("figure", "table"), "name"), error_msg)
  expect_error(create_file(NA_character_, "name"), error_msg)
})

test_that("File name is validated", {
  local_lbstproj_project(with_tot = FALSE)
  expect_error(create_file("figure", "name with space"))
  expect_equal(
    create_file("table", "abc.R", open = FALSE, quiet = TRUE),
    fs::path("R/tables/abc.R")
  )
  expect_equal(
    create_file("table", "abcd", open = FALSE, quiet = TRUE),
    fs::path("R/tables/abcd.R")
  )
})


test_that("Files are created", {
  local_lbstproj_project(with_tot = FALSE)
  create_file("figure", "example_figure", open = FALSE, quiet = TRUE)
  fig_path <- fs::path("R/figures/example_figure.R")
  expect_true(fs::file_exists(fig_path), info = "Figure R file exists")
})

test_that("Tables are created", {
  local_lbstproj_project(with_tot = FALSE)

  create_file("table", "example_table", open = FALSE, quiet = TRUE, id = 2)
  tab_path <- fs::path("R", "tables", "example_table.R")
  expect_true(fs::file_exists(tab_path), info = "Table R file exists")
})

test_that("Data files are created", {
  local_lbstproj_project(with_tot = FALSE)

  create_file("data", "example_data", open = FALSE, quiet = TRUE)
  data_path <- fs::path("R", "data", "example_data.R")
  expect_true(fs::file_exists(data_path), info = "Data R file exists")
})

test_that("Analysis files are created", {
  local_lbstproj_project(with_tot = FALSE)
  create_file("analysis", "example_model.R", open = FALSE, quiet = TRUE)
  data_path <- fs::path("R", "analysis", "example_model.R")
  expect_true(fs::file_exists(data_path), info = "Analysis R file exists")
})
