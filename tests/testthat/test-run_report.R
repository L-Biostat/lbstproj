# ┌────────────┐
# │  lbstproj  │
# └────────────┘
# test-run_report.R: Tests for run_report()

# FILE VALIDATION ----------------------------------------------------------------

test_that("run_report() errors when the report file does not exist", {
  local_lbstproj_project()

  expect_error(
    run_report(file = "report.qmd", quiet = TRUE),
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

  writeLines("---\ntitle: test\n---\n", "report/report.qmd")

  rendered_inputs <- character(0)
  local_mocked_bindings(
    quarto_render = function(input, ...) { rendered_inputs <<- c(rendered_inputs, input) },
    .package = "quarto"
  )

  run_report(file = "report.qmd", quiet = TRUE)

  expect_equal(rendered_inputs, "report/report.qmd")
})

test_that("run_report() passes ... arguments through to quarto_render()", {
  local_lbstproj_project()

  writeLines("---\ntitle: test\n---\n", "report/report.qmd")

  captured_args <- list()
  local_mocked_bindings(
    quarto_render = function(...) { captured_args <<- list(...) },
    .package = "quarto"
  )

  run_report(file = "report.qmd", output_file = "custom.html", quiet = TRUE)

  expect_equal(captured_args$output_file, "custom.html")
})

# QUIET --------------------------------------------------------------------------

test_that("run_report() is quiet when quiet = TRUE", {
  local_lbstproj_project()

  writeLines("---\ntitle: test\n---\n", "report/report.qmd")
  local_mocked_bindings(
    quarto_render = function(...) invisible(NULL),
    .package = "quarto"
  )

  expect_no_message(run_report(file = "report.qmd", quiet = TRUE))
})

test_that("run_report() informs when quiet = FALSE", {
  local_lbstproj_project()

  writeLines("---\ntitle: test\n---\n", "report/report.qmd")
  local_mocked_bindings(
    quarto_render = function(...) invisible(NULL),
    .package = "quarto"
  )

  expect_snapshot(run_report(file = "report.qmd", quiet = FALSE))
})

test_that("lbstproj.quiet option is respected by run_report()", {
  local_lbstproj_project()

  writeLines("---\ntitle: test\n---\n", "report/report.qmd")
  local_mocked_bindings(
    quarto_render = function(...) invisible(NULL),
    .package = "quarto"
  )

  withr::with_options(
    list(lbstproj.quiet = TRUE),
    expect_no_message(run_report(file = "report.qmd"))
  )
})
