# DATA ---------------------------------------------------------------------------

test_that("save_data() errors if data is not a data.frame", {
  local_lbstproj_project(with_tot = FALSE)

  expect_error(
    save_data(1:10, "test"),
    "data.frame"
  )
})

test_that("save_data() saves data to data/processed", {
  local_lbstproj_project(with_tot = FALSE)

  df <- data.frame(x = 1:3)

  path <- save_data(df, "my-data", quiet = TRUE)

  expect_true(fs::file_exists("data/processed/my-data.rds"))
  expect_equal(readRDS(path), df)
})

test_that("save_data() allows underscores in file names", {
  local_lbstproj_project(with_tot = FALSE)

  df <- data.frame(x = 1:3)

  path <- save_data(df, "my_data", quiet = TRUE)

  expect_true(fs::file_exists("data/processed/my_data.rds"))
  expect_equal(readRDS(path), df)
})

test_that("save_data() errors if file exists and overwrite = FALSE", {
  local_lbstproj_project(with_tot = FALSE)

  df <- data.frame(x = 1)

  save_data(df, "test", quiet = TRUE, overwrite = FALSE)

  expect_error(
    save_data(df, "test", overwrite = FALSE, quiet = TRUE),
    "already exists"
  )
})

test_that("save_data() overwrites file when overwrite = TRUE", {
  local_lbstproj_project(with_tot = FALSE)

  save_data(data.frame(x = 1), "test", quiet = TRUE)
  save_data(data.frame(x = 2), "test", overwrite = TRUE, quiet = TRUE)

  expect_equal(readRDS("data/processed/test.rds")$x, 2)
})

# TABLE --------------------------------------------------------------------------

test_that("save_table() errors for non-gt object in gt project", {
  local_lbstproj_project(with_tot = FALSE, engine = "gt")

  expect_error(
    save_table(data.frame(x = 1), "test"),
    "gt_tbl"
  )
})

test_that("save_table() errors for non-flextable object in flextable project", {
  local_lbstproj_project(with_tot = FALSE, engine = "flextable")

  expect_error(
    save_table(data.frame(x = 1), "test"),
    "flextable"
  )
})

test_that("save_table() errors when gt object used in flextable project", {
  local_lbstproj_project(with_tot = FALSE, engine = "flextable")

  tab <- gt::gt(data.frame(x = 1))

  expect_error(save_table(tab, "test"), "flextable")
})

test_that("save_table() errors when flextable object used in gt project", {
  local_lbstproj_project(with_tot = FALSE, engine = "gt")

  tab <- flextable::flextable(data.frame(x = 1))

  expect_error(save_table(tab, "test"), "gt_tbl")
})

test_that("save_table() saves rds file for gt project", {
  local_lbstproj_project(with_tot = FALSE, engine = "gt")

  tab <- gt::gt(data.frame(x = 1))

  save_table(tab, "tab", quiet = TRUE, export = FALSE)

  expect_true(fs::file_exists("data/tables/tab.rds"))
})

test_that("save_table() rejects underscores in file names", {
  local_lbstproj_project(with_tot = FALSE, engine = "gt")

  tab <- gt::gt(data.frame(x = 1))

  expect_error(
    save_table(tab, "tab_name", quiet = TRUE, export = FALSE),
    "Only letters, numbers, and hyphens are allowed."
  )
})

test_that("save_table() saves rds file for flextable project", {
  local_lbstproj_project(with_tot = FALSE, engine = "flextable")

  tab <- flextable::flextable(data.frame(x = 1))

  save_table(tab, "tab", quiet = TRUE, export = FALSE)

  expect_true(fs::file_exists("data/tables/tab.rds"))
})

test_that("save_table() errors if file exists and overwrite = FALSE", {
  local_lbstproj_project(with_tot = FALSE)

  tab <- gt::gt(data.frame(x = 1))

  save_table(tab, "test", quiet = TRUE, overwrite = FALSE, export = FALSE)

  expect_error(
    save_table(tab, "test", overwrite = FALSE, quiet = TRUE, export = FALSE),
    "already exists"
  )
})

test_that("save_table() overwrites file when overwrite = TRUE", {
  local_lbstproj_project(with_tot = FALSE)

  tab1 <- gt::gt(data.frame(x = 1))
  tab2 <- gt::gt(data.frame(x = 2))

  save_table(tab1, "test", quiet = TRUE, export = FALSE)
  save_table(tab2, "test", overwrite = TRUE, quiet = TRUE, export = FALSE)

  expect_true(fs::file_exists("data/tables/test.rds"))
})

test_that("save_table() exports docx via gt::gtsave() for gt project", {
  local_lbstproj_project(with_tot = FALSE, engine = "gt")

  tab <- gt::gt(data.frame(x = 1))

  save_table(tab, "tab", quiet = TRUE, export = TRUE)

  expect_true(fs::file_exists("results/tables/tab.docx"))
})

test_that("save_table() exports docx via flextable::save_as_docx() for flextable project", {
  local_lbstproj_project(with_tot = FALSE, engine = "flextable")

  tab <- flextable::flextable(data.frame(x = 1))

  save_table(tab, "tab", quiet = TRUE, export = TRUE)

  expect_true(fs::file_exists("results/tables/tab.docx"))
})

test_that("save_table() defaults to gt for legacy projects without TableEngine", {
  local_lbstproj_project(with_tot = FALSE, engine = NULL)

  tab <- gt::gt(data.frame(x = 1))

  # Should not error – legacy project falls back to gt
  expect_no_error(save_table(tab, "tab", quiet = TRUE, export = FALSE))
  expect_true(fs::file_exists("data/tables/tab.rds"))
})

# FIGURE -------------------------------------------------------------------------

test_that("save_figure() errors for non-ggplot object", {
  local_lbstproj_project(with_tot = FALSE)

  expect_error(
    save_figure(1:10, "fig"),
    "ggplot"
  )
})

test_that("save_figure() only accepts png or pdf extensions", {
  local_lbstproj_project(with_tot = FALSE)

  expect_error(
    save_figure(ggplot2::ggplot(), "fig", extension = "mp3"),
    "pdf"
  )
})

test_that("save_figure() saves png figure", {
  local_lbstproj_project(with_tot = FALSE)

  p <- ggplot2::ggplot(mtcars, ggplot2::aes(mpg, wt)) +
    ggplot2::geom_point()

  save_figure(p, "fig", dpi = 72, quiet = TRUE)

  expect_true(fs::file_exists("results/figures/fig.png"))
})

test_that("save_figure() rejects underscores in file names", {
  local_lbstproj_project(with_tot = FALSE)

  p <- ggplot2::ggplot(mtcars, ggplot2::aes(mpg, wt)) +
    ggplot2::geom_point()

  expect_error(
    save_figure(p, "fig_name", dpi = 72, quiet = TRUE),
    "Only letters, numbers, and hyphens are allowed."
  )
})

test_that("save_figure() errors if file exists and overwrite = FALSE", {
  local_lbstproj_project(with_tot = FALSE)

  p <- ggplot2::ggplot(mtcars, ggplot2::aes(mpg, wt)) +
    ggplot2::geom_point()

  save_figure(p, "test", quiet = TRUE, overwrite = FALSE, dpi = 72)

  expect_error(
    save_figure(p, "test", overwrite = FALSE, quiet = TRUE, dpi = 72),
    "already exists"
  )
})

test_that("save_figure() overwrites file when overwrite = TRUE", {
  local_lbstproj_project(with_tot = FALSE)

  p1 <- ggplot2::ggplot(mtcars, ggplot2::aes(mpg, wt)) +
    ggplot2::geom_point()

  p2 <- ggplot2::ggplot(mtcars, ggplot2::aes(hp, wt)) +
    ggplot2::geom_point()

  save_figure(p1, "test", quiet = TRUE, dpi = 72)
  save_figure(p2, "test", overwrite = TRUE, quiet = TRUE, dpi = 72)

  expect_true(fs::file_exists("results/figures/test.png"))
})


# INFORM SAVE --------------------------------------------------------------------

test_that("inform_saved() prints message when quiet = FALSE", {
  local_lbstproj_project(with_tot = FALSE)

  expect_message(
    inform_saved(
      object_name = "df",
      path = "data/processed/data.rds",
      what = "Data",
      quiet = FALSE
    ),
    "saved to"
  )
})

test_that("inform_saved() prints no message when quiet = TRUE", {
  local_lbstproj_project(with_tot = FALSE)

  expect_no_message(
    inform_saved(
      object_name = "df",
      path = "data/processed/data.rds",
      what = "Data",
      quiet = TRUE
    )
  )
})


test_that("inform_saved() prints exporting message when export = TRUE", {
  local_lbstproj_project(with_tot = FALSE)

  expect_message(
    inform_saved(
      object_name = "df",
      path = "data/processed/data.rds",
      what = "Data",
      quiet = FALSE,
      export = TRUE
    ),
    "exported to"
  )
})
