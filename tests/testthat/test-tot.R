# tests/testthat/test-tot.R

# ---- validate_tot() ----------------------------------------------------------

test_that("validate_tot() passes with a valid TOT", {
  valid_tot <- data.frame(
    id = c("1", "2"),
    type = c("figure", "table"),
    name = c("fig1", "tab1"),
    caption = c("Figure 1", "Table 1"),
    stringsAsFactors = FALSE
  )
  result <- expect_invisible(lbstproj:::validate_tot(valid_tot))
  # Required columns unchanged
  expect_equal(result[names(valid_tot)], valid_tot)
  # Optional section columns are added as empty strings
  expect_equal(result$section,       rep("", 2))
  expect_equal(result$subsection,    rep("", 2))
  expect_equal(result$subsubsection, rep("", 2))
})

test_that("validate_tot() adds missing optional section columns as empty strings", {
  tot <- data.frame(
    id = "1", type = "figure", name = "fig1", caption = "Figure 1",
    stringsAsFactors = FALSE
  )
  result <- lbstproj:::validate_tot(tot)
  expect_true(all(c("section", "subsection", "subsubsection") %in% names(result)))
  expect_equal(result$section,       "")
  expect_equal(result$subsection,    "")
  expect_equal(result$subsubsection, "")
})

test_that("validate_tot() preserves existing section columns unchanged", {
  tot <- data.frame(
    id = "1", type = "figure", name = "fig1", caption = "Figure 1",
    section = "Results", subsection = "Primary", subsubsection = "",
    stringsAsFactors = FALSE
  )
  result <- lbstproj:::validate_tot(tot)
  expect_equal(result$section,       "Results")
  expect_equal(result$subsection,    "Primary")
  expect_equal(result$subsubsection, "")
})

test_that("validate_tot() coerces NA in existing section columns to ''", {
  tot <- data.frame(
    id      = c("1", "2", "3"),
    type    = c("figure", "figure", "table"),
    name    = c("fig1", "fig2", "tab1"),
    caption = c("Fig 1", "Fig 2", "Tab 1"),
    section       = c("Results", NA, "Safety"),
    subsection    = c(NA, "Primary", NA),
    subsubsection = c(NA, NA, NA),
    stringsAsFactors = FALSE
  )
  result <- lbstproj:::validate_tot(tot)
  expect_equal(result$section,       c("Results", "", "Safety"))
  expect_equal(result$subsection,    c("", "Primary", ""))
  expect_equal(result$subsubsection, c("", "", ""))
})

test_that("validate_tot() errors on missing required columns", {
  bad_tot <- data.frame(
    id = "1",
    name = "fig1",
    caption = "Figure 1",
    stringsAsFactors = FALSE
  ) # 'type' column missing
  expect_error(lbstproj:::validate_tot(bad_tot), "missing required column")
})

test_that("validate_tot() errors on all missing required columns", {
  bad_tot <- data.frame(x = 1)
  expect_error(lbstproj:::validate_tot(bad_tot), "missing required column")
})

test_that("validate_tot() errors on NA values in required columns", {
  na_tot <- data.frame(
    id = c("1", NA),
    type = c("figure", "table"),
    name = c("fig1", "tab1"),
    caption = c("Figure 1", "Table 1"),
    stringsAsFactors = FALSE
  )
  expect_error(lbstproj:::validate_tot(na_tot), "contains missing values")
})

test_that("validate_tot() errors on invalid type values", {
  bad_type_tot <- data.frame(
    id = c("1", "2"),
    type = c("figure", "chart"),
    name = c("fig1", "chart1"),
    caption = c("Figure 1", "Chart 1"),
    stringsAsFactors = FALSE
  )
  expect_error(lbstproj:::validate_tot(bad_type_tot), "invalid value")
})

test_that("validate_tot() errors on duplicate id values", {
  dup_id_tot <- data.frame(
    id = c("1", "1"),
    type = c("figure", "table"),
    name = c("fig1", "tab1"),
    caption = c("Figure 1", "Table 1"),
    stringsAsFactors = FALSE
  )
  expect_error(lbstproj:::validate_tot(dup_id_tot), "duplicate value")
})

test_that("validate_tot() errors on duplicate name values", {
  dup_name_tot <- data.frame(
    id = c("1", "2"),
    type = c("figure", "table"),
    name = c("fig1", "fig1"),
    caption = c("Figure 1", "Figure 1 again"),
    stringsAsFactors = FALSE
  )
  expect_error(lbstproj:::validate_tot(dup_name_tot), "duplicate value")
})

# ---- import_tot() ------------------------------------------------------------

test_that("import_tot() succeeds with a valid TOT Excel file", {
  local_lbstproj_project(with_tot = TRUE)
  expect_no_error(import_tot(quiet = TRUE))
})

test_that("import_tot() errors when Excel file is missing", {
  local_lbstproj_project(with_tot = FALSE)
  expect_error(import_tot(), "does not exist")
})

test_that("import_tot() errors when TOT is missing required columns", {
  bad_data <- data.frame(
    id = "1",
    name = "fig1",
    caption = "Figure 1",
    stringsAsFactors = FALSE
  )
  local_lbstproj_project(with_tot = TRUE, tot_data = bad_data)
  expect_error(import_tot(quiet = TRUE), "missing required column")
})

test_that("import_tot() errors when TOT has invalid type values", {
  bad_data <- data.frame(
    id = "1",
    type = "chart",
    name = "chart1",
    caption = "A chart",
    stringsAsFactors = FALSE
  )
  local_lbstproj_project(with_tot = TRUE, tot_data = bad_data)
  expect_error(import_tot(quiet = TRUE), "invalid value")
})

test_that("import_tot() errors when TOT has duplicate id values", {
  bad_data <- data.frame(
    id = c("1", "1"),
    type = c("figure", "table"),
    name = c("fig1", "tab1"),
    caption = c("Figure 1", "Table 1"),
    stringsAsFactors = FALSE
  )
  local_lbstproj_project(with_tot = TRUE, tot_data = bad_data)
  expect_error(import_tot(quiet = TRUE), "duplicate value")
})

test_that("import_tot() errors when TOT has duplicate name values", {
  bad_data <- data.frame(
    id = c("1", "2"),
    type = c("figure", "table"),
    name = c("fig1", "fig1"),
    caption = c("Figure 1", "Figure 1b"),
    stringsAsFactors = FALSE
  )
  local_lbstproj_project(with_tot = TRUE, tot_data = bad_data)
  expect_error(import_tot(quiet = TRUE), "duplicate value")
})


# ---- load_tot() ----------------------------------------------------------------

test_that("load_tot() errors when there is no TOT rds file", {
  local_lbstproj_project(with_tot = FALSE)
  expect_error(
    load_tot(),
    "does not exist"
  )
})

test_that("load_tot() actually returns the TOT", {
  tmp <- local_lbstproj_project(with_tot = TRUE)
  import_tot(quiet = TRUE)
  tot_file <- readRDS(fs::path(tmp, "data/tot", "tot", ext = "rds"))
  tot_fn <- load_tot()
  expect_identical(tot_file, tot_fn)
})
