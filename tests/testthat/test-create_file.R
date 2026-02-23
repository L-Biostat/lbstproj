test_that("Files are created", {
  local_lbstproj_project(with_tot = FALSE)

  # Figure
  create_file(
    type = "figure",
    name = "example_figure",
    open = FALSE,
    print = FALSE,
    id = 1
  )

  fig_path <- fs::path("R", "figures", "example_figure.R")
  expect_true(fs::file_exists(fig_path), info = "Figure R file exists")

  # Tables
  create_file(
    type = "table",
    name = "example_table",
    open = FALSE,
    print = FALSE,
    id = 2
  )

  tab_path <- fs::path("R", "tables", "example_table.R")
  expect_true(fs::file_exists(tab_path), info = "Table R file exists")

  # Data file
  create_file(
    type = "data",
    name = "example_data",
    open = FALSE,
    print = FALSE
  )

  data_path <- fs::path("R", "data", "example_data.R")
  expect_true(fs::file_exists(data_path), info = "Data R file exists")

  # Analysis file
  ensure_dir_exists("R/analysis", confirm = FALSE)
  create_file(
    type = "analysis",
    name = "example_model",
    open = FALSE,
    print = FALSE
  )

  data_path <- fs::path("R", "analysis", "example_model.R")
  expect_true(fs::file_exists(data_path), info = "Analysis R file exists")
})
