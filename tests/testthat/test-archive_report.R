# ┌────────────┐
# │  lbstproj  │
# └────────────┘
# test-archive_report.R: Tests for archive_report()

# FILE VALIDATION ----------------------------------------------------------------

test_that("archive_report() errors when the report file does not exist", {
  local_lbstproj_project()
  fs::dir_create("results/reports")

  expect_error(
    archive_report(file = "report.html", quiet = TRUE),
    "does not exist"
  )
})

# ARCHIVING ----------------------------------------------------------------------

test_that("archive_report() moves the file out of report/", {
  local_lbstproj_project()
  fs::dir_create("results/reports")
  writeLines("rendered content", "report/report.html")

  archive_report(file = "report.html", quiet = TRUE)

  expect_false(fs::file_exists("report/report.html"))
})

test_that("archive_report() places the file in results/reports/", {
  local_lbstproj_project()
  fs::dir_create("results/reports")
  writeLines("rendered content", "report/report.html")

  archive_report(file = "report.html", quiet = TRUE)

  expect_equal(length(fs::dir_ls("results/reports")), 1L)
})

test_that("archive_report() uses the correct naming convention", {
  local_lbstproj_project()
  fs::dir_create("results/reports")
  writeLines("rendered content", "report/report.html")

  archive_report(file = "report.html", quiet = TRUE)

  version <- as.character(desc::desc_get("Version"))
  expected_name <- glue::glue(
    "report_{format(Sys.Date(), '%Y_%m_%d')}_v{version}.html"
  )

  expect_true(fs::file_exists(fs::path("results/reports", expected_name)))
})

test_that("archive_report() preserves file content after move", {
  local_lbstproj_project()
  fs::dir_create("results/reports")
  writeLines("rendered content", "report/report.html")

  archive_report(file = "report.html", quiet = TRUE)

  version <- as.character(desc::desc_get("Version"))
  archive_name <- glue::glue(
    "report_{format(Sys.Date(), '%Y_%m_%d')}_v{version}.html"
  )

  expect_equal(
    readLines(fs::path("results/reports", archive_name)),
    "rendered content"
  )
})

test_that("archive_report() works with a non-default file name", {
  local_lbstproj_project()
  fs::dir_create("results/reports")
  writeLines("final content", "report/final_report.html")

  archive_report(file = "final_report.html", quiet = TRUE)

  version <- as.character(desc::desc_get("Version"))
  expected_name <- glue::glue(
    "final_report_{format(Sys.Date(), '%Y_%m_%d')}_v{version}.html"
  )

  expect_true(fs::file_exists(fs::path("results/reports", expected_name)))
})

# OVERWRITE ----------------------------------------------------------------------

test_that("archive_report() errors when archive already exists and overwrite = FALSE", {
  local_lbstproj_project()
  fs::dir_create("results/reports")

  version <- as.character(desc::desc_get("Version"))
  archive_name <- glue::glue(
    "report_{format(Sys.Date(), '%Y_%m_%d')}_v{version}.html"
  )
  writeLines("old content", fs::path("results/reports", archive_name))
  writeLines("new content", "report/report.html")

  expect_error(
    archive_report(file = "report.html", overwrite = FALSE, quiet = TRUE),
    "already exists"
  )
})

test_that("archive_report() overwrites an existing archive when overwrite = TRUE", {
  local_lbstproj_project()
  fs::dir_create("results/reports")

  version <- as.character(desc::desc_get("Version"))
  archive_name <- glue::glue(
    "report_{format(Sys.Date(), '%Y_%m_%d')}_v{version}.html"
  )
  writeLines("old content", fs::path("results/reports", archive_name))
  writeLines("new content", "report/report.html")

  archive_report(file = "report.html", overwrite = TRUE, quiet = TRUE)

  expect_equal(
    readLines(fs::path("results/reports", archive_name)),
    "new content"
  )
})

# QUIET --------------------------------------------------------------------------

test_that("archive_report() is quiet when quiet = TRUE", {
  local_lbstproj_project()
  fs::dir_create("results/reports")
  writeLines("rendered content", "report/report.html")

  expect_no_message(archive_report(file = "report.html", quiet = TRUE))
})

test_that("archive_report() informs when quiet = FALSE", {
  local_lbstproj_project()
  fs::dir_create("results/reports")
  writeLines("rendered content", "report/report.html")

  expect_message(
    archive_report(file = "report.html", quiet = FALSE),
    "Report archived at"
  )
})

test_that("lbstproj.quiet option is respected by archive_report()", {
  local_lbstproj_project()
  fs::dir_create("results/reports")
  writeLines("rendered content", "report/report.html")

  withr::with_options(
    list(lbstproj.quiet = TRUE),
    expect_no_message(archive_report(file = "report.html"))
  )
})
