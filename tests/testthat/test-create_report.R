test_that("create_report() creates report/report.qmd and returns its path invisibly", {
  local_lbstproj_project(with_tot = TRUE)

  out <- create_report(
    output_type = "html",
    quiet = TRUE
  )

  expect_equal(out, invisible(fs::path("report", "report.qmd")))
  expect_true(fs::file_exists(fs::path("report", "report.qmd")))
})


test_that("create_report() writes report metadata from DESCRIPTION", {
  local_lbstproj_project(with_tot = TRUE)

  create_report(
    output_type = "html",
    quiet = TRUE
  )

  report <- readLines(fs::path("report", "report.qmd"))

  expect_true(any(grepl(desc::desc_get("Title"), report, fixed = TRUE)))
  expect_true(any(grepl(desc::desc_get("Client"), report, fixed = TRUE)))
  expect_true(any(grepl(desc::desc_get("Department"), report, fixed = TRUE)))
})


test_that("create_report() includes all TOT entries in the order they appear", {
  local_lbstproj_project(with_tot = TRUE)

  tot <- load_tot()

  create_report(
    output_type = "html",
    quiet = TRUE
  )

  report <- paste(
    readLines(fs::path("report", "report.qmd")),
    collapse = "\n"
  )

  expected_labels <- ifelse(
    tot$type == "figure",
    paste0("fig-", tot$name),
    paste0("tbl-", tot$name)
  )

  label_positions <- vapply(
    expected_labels,
    function(x) regexpr(x, report, fixed = TRUE)[1],
    integer(1)
  )

  expect_true(all(label_positions > 0))
  expect_true(is.unsorted(label_positions, strictly = FALSE) == FALSE)
})


test_that("create_report() uses tbl- prefix for tables in html output", {
  local_lbstproj_project(with_tot = TRUE)

  tot <- load_tot()
  table_names <- tot$name[tot$type == "table"]

  testthat::skip_if(length(table_names) == 0, "Fake TOT contains no tables.")

  create_report(
    output_type = "html",
    quiet = TRUE
  )

  report <- paste(
    readLines(fs::path("report", "report.qmd")),
    collapse = "\n"
  )

  expect_true(all(grepl(
    paste0("tbl-", table_names),
    report,
    fixed = TRUE
  )))
})


test_that("create_report() uses tab- prefix for tables in word output", {
  local_lbstproj_project(with_tot = TRUE)

  tot <- load_tot()
  table_names <- tot$name[tot$type == "table"]

  testthat::skip_if(length(table_names) == 0, "Fake TOT contains no tables.")

  create_report(
    output_type = "docx",
    quiet = TRUE
  )

  report <- paste(
    readLines(fs::path("report", "report.qmd")),
    collapse = "\n"
  )

  expect_true(all(grepl(
    paste0("tab-", table_names),
    report,
    fixed = TRUE
  )))
})


test_that("create_report() includes the expected paths for figures and tables", {
  local_lbstproj_project(with_tot = TRUE)

  tot <- load_tot()

  create_report(
    output_type = "html",
    quiet = TRUE
  )

  report <- paste(
    readLines(fs::path("report", "report.qmd")),
    collapse = "\n"
  )

  figure_names <- tot$name[tot$type == "figure"]
  table_names <- tot$name[tot$type == "table"]

  if (length(figure_names) > 0) {
    expect_true(all(grepl(
      paste0("results/figures/", figure_names, ".png"),
      report,
      fixed = TRUE
    )))
  }

  if (length(table_names) > 0) {
    expect_true(all(grepl(
      paste0("data/tables/", table_names, ".rds"),
      report,
      fixed = TRUE
    )))
  }
})


test_that("create_report() is quiet when quiet = TRUE", {
  local_lbstproj_project(with_tot = TRUE)
  fs::dir_create("report")
  expect_no_message(
    create_report(
      output_type = "html",
      quiet = TRUE
    )
  )
})


test_that("create_report() informs when quiet = FALSE", {
  local_lbstproj_project(with_tot = TRUE)

  expect_snapshot(
    create_report(
      output_type = "html",
      quiet = FALSE
    )
  )
})


test_that("create_report() overwrites an existing report", {
  local_lbstproj_project(with_tot = TRUE)

  fs::dir_create("report")
  writeLines("old report", "report/report.qmd")

  create_report(
    output_type = "html",
    quiet = TRUE
  )

  report <- readLines("report/report.qmd")

  expect_false(identical(report, "old report"))
})


test_that("create_report() errors for unsupported output_type", {
  local_lbstproj_project(with_tot = TRUE)

  expect_error(
    create_report(
      output_type = "pdf",
      quiet = TRUE
    )
  )
})
