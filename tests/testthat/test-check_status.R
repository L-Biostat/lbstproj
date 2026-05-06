# EMPTY PROJECT ------------------------------------------------------------------

test_that("informs and returns NULL invisibly when TOT has no figures", {
  local_lbstproj_project(
    with_tot = TRUE,
    tot_data = data.frame(
      id = "1",
      type = "table",
      name = "tab1",
      caption = "Table 1",
      stringsAsFactors = FALSE
    )
  )
  import_tot(quiet = TRUE)
  fs::dir_create(c("R/figures", "results/figures"))
  expect_message(check_status("figure"), "No figures found")
  expect_invisible(check_status("figure"))
})

test_that("informs and returns NULL invisibly when TOT has no tables", {
  local_lbstproj_project(
    with_tot = TRUE,
    tot_data = data.frame(
      id = "1",
      type = "figure",
      name = "fig1",
      caption = "Figure 1",
      stringsAsFactors = FALSE
    )
  )
  import_tot(quiet = TRUE)
  fs::dir_create(c("R/tables", "results/tables", "data/tables"))
  expect_message(check_status("table"), "No tables found")
  expect_invisible(check_status("table"))
})

test_that("does not inform when TOT has entries but no files exist on disk", {
  local_lbstproj_project(with_tot = TRUE)
  import_tot(quiet = TRUE)
  fs::dir_create(c("results/figures", "results/tables", "data/tables"))
  expect_no_message(check_status("figure"))
  expect_no_message(check_status("table"))
})

# OUTPUT -------------------------------------------------------------------------

test_that("check_status('figure') output matches snapshot", {
  local_lbstproj_project(with_tot = TRUE)
  import_tot(quiet = TRUE)
  fs::dir_create("results/figures")
  file.create("R/figures/fig1.R")
  file.create("results/figures/fig1.png")
  expect_snapshot(check_status("figure"))
})

test_that("check_status('table') output matches snapshot", {
  local_lbstproj_project(with_tot = TRUE)
  import_tot(quiet = TRUE)
  fs::dir_create(c("results/tables", "data/tables"))
  file.create("R/tables/tab1.R")
  file.create("results/tables/tab1.docx")
  saveRDS(list(), "data/tables/tab1.rds")
  expect_snapshot(check_status("table"))
})

test_that("items on disk but absent from TOT appear with missing ID", {
  local_lbstproj_project(with_tot = TRUE)
  import_tot(quiet = TRUE)
  fs::dir_create("results/figures")
  file.create("R/figures/fig-extra.R")
  expect_snapshot(check_status("figure"))
})

# RETURN VALUE -------------------------------------------------------------------

test_that("returns NULL invisibly", {
  local_lbstproj_project(with_tot = TRUE)
  import_tot(quiet = TRUE)
  fs::dir_create(c("results/figures"))
  expect_invisible(check_status("figure"))
  expect_null(check_status("figure"))
})
