# ┌────────────┐
# │  lbstproj  │
# └────────────┘
# test-run_report.R: Tests for run_report()

# FILE VALIDATION ----------------------------------------------------------------

test_that("run_report() errors when the report file does not exist", {
  local_lbstproj_project()

  expect_error(
    run_report(file = "missing_report.qmd", quiet = TRUE),
    "does not exist"
  )
})

test_that("run_report() errors for an unsupported file extension", {
  local_lbstproj_project()

  writeLines("dummy", "report/report.Rmd")

  expect_error(
    run_report(file = "report.Rmd", quiet = TRUE),
    "Unsupported file extension"
  )
})

# RENDERING ----------------------------------------------------------------------

test_that("run_report() calls quarto_render() with the correct input path", {
  local_lbstproj_project()

  report_file <- glue::glue("html_report_{format(Sys.Date(), '%Y_%m_%d')}.qmd")
  writeLines("---
format:
  html:
---
", fs::path("report", report_file))

  rendered_inputs <- character(0)
  local_mocked_bindings(
    quarto_render = function(input, ...) {
      rendered_inputs <<- c(rendered_inputs, input)
    },
    .package = "quarto"
  )

  run_report(file = report_file, quiet = TRUE)

  expect_equal(rendered_inputs, as.character(fs::path("report", report_file)))
})

test_that("run_report() uses the latest dated qmd report when file is omitted", {
  local_lbstproj_project()

  older <- fs::path("report", "html_report_2026_03_15.qmd")
  newer <- fs::path("report", "docx_report_2026_03_16.qmd")
  writeLines("---
format:
  html:
---
", older)
  writeLines("---
format:
  docx:
---
", newer)
  Sys.setFileTime(older, as.POSIXct("2026-03-15 10:00:00", tz = "UTC"))
  Sys.setFileTime(newer, as.POSIXct("2026-03-16 10:00:00", tz = "UTC"))

  rendered_inputs <- character(0)
  local_mocked_bindings(
    quarto_render = function(input, ...) {
      rendered_inputs <<- c(rendered_inputs, input)
    },
    .package = "quarto"
  )

  run_report(quiet = TRUE)

  expect_equal(rendered_inputs, "report/docx_report_2026_03_16.qmd")
})

test_that("run_report() passes ... arguments through to quarto_render()", {
  local_lbstproj_project()

  report_file <- glue::glue("html_report_{format(Sys.Date(), '%Y_%m_%d')}.qmd")
  writeLines("---
format:
  html:
---
", fs::path("report", report_file))

  captured_args <- list()
  local_mocked_bindings(
    quarto_render = function(...) {
      captured_args <<- list(...)
    },
    .package = "quarto"
  )

  run_report(file = report_file, output_file = "custom", quiet = TRUE)

  expect_equal(captured_args$output_file, "custom")
})

# QUIET --------------------------------------------------------------------------

test_that("run_report() is quiet when quiet = TRUE", {
  local_lbstproj_project()

  report_file <- glue::glue("html_report_{format(Sys.Date(), '%Y_%m_%d')}.qmd")
  writeLines("---
format:
  html:
---
", fs::path("report", report_file))
  local_mocked_bindings(
    quarto_render = function(...) invisible(NULL),
    .package = "quarto"
  )

  expect_no_message(run_report(file = report_file, quiet = TRUE))
})

test_that("run_report() informs when quiet = FALSE", {
  local_lbstproj_project()

  report_file <- glue::glue("html_report_{format(Sys.Date(), '%Y_%m_%d')}.qmd")
  writeLines("---
format:
  html:
---
", fs::path("report", report_file))
  local_mocked_bindings(
    quarto_render = function(...) invisible(NULL),
    .package = "quarto"
  )

  expect_snapshot(run_report(file = report_file, quiet = FALSE))
})

test_that("run_report() reports a docx output path for docx reports", {
  local_lbstproj_project()

  report_file <- glue::glue("docx_report_{format(Sys.Date(), '%Y_%m_%d')}.qmd")
  writeLines("---
format:
  docx:
---
", fs::path("report", report_file))
  local_mocked_bindings(
    quarto_render = function(...) invisible(NULL),
    .package = "quarto"
  )

  expect_message(
    run_report(file = report_file, quiet = FALSE),
    glue::glue("docx_report_{format(Sys.Date(), '%Y_%m_%d')}.docx")
  )
})

test_that("lbstproj.quiet option is respected by run_report()", {
  local_lbstproj_project()

  report_file <- glue::glue("html_report_{format(Sys.Date(), '%Y_%m_%d')}.qmd")
  writeLines("---
format:
  html:
---
", fs::path("report", report_file))
  local_mocked_bindings(
    quarto_render = function(...) invisible(NULL),
    .package = "quarto"
  )

  withr::with_options(
    list(lbstproj.quiet = TRUE),
    expect_no_message(run_report())
  )
})
