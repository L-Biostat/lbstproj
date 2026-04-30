test_that("create_report() creates a dated html report and returns its path invisibly", {
  local_lbstproj_project(with_tot = TRUE)

  expected_path <- fs::path(
    "report",
    glue::glue("report_{format(Sys.Date(), '%Y_%m_%d')}.qmd")
  )

  out <- create_report(
    output_type = "html",
    quiet = TRUE
  )

  expect_equal(out, invisible(expected_path))
  expect_true(fs::file_exists(expected_path))
})


test_that("create_report() writes report metadata from DESCRIPTION", {
  local_lbstproj_project(with_tot = TRUE)

  report_path <- create_report(
    output_type = "html",
    quiet = TRUE
  )

  report <- readLines(report_path)

  expect_true(any(grepl(desc::desc_get("Title"), report, fixed = TRUE)))
  expect_true(any(grepl(desc::desc_get("Client"), report, fixed = TRUE)))
  expect_true(any(grepl(desc::desc_get("Department"), report, fixed = TRUE)))
})


test_that("create_report() includes all TOT entries in the order they appear", {
  local_lbstproj_project(with_tot = TRUE)

  tot <- load_tot()
  report_path <- create_report(
    output_type = "html",
    quiet = TRUE
  )

  report <- paste(
    readLines(report_path),
    collapse = "
"
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

  report_path <- create_report(
    output_type = "html",
    quiet = TRUE
  )

  report <- paste(
    readLines(report_path),
    collapse = "
"
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

  report_path <- create_report(
    output_type = "docx",
    quiet = TRUE
  )

  report <- paste(
    readLines(report_path),
    collapse = "
"
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
  report_path <- create_report(
    output_type = "html",
    quiet = TRUE
  )

  report <- paste(
    readLines(report_path),
    collapse = "
"
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
  expect_no_message(
    create_report(
      output_type = "html",
      quiet = TRUE
    )
  )
})


test_that("create_report() informs when quiet = FALSE", {
  local_lbstproj_project(with_tot = TRUE)

  local_mocked_bindings(
    Sys.Date = function() as.Date("2026-01-01"),
    .package = "base"
  )

  expect_snapshot(
    create_report(
      output_type = "html",
      quiet = FALSE
    )
  )
})


test_that("create_report() errors when a dated report already exists and overwrite = FALSE", {
  local_lbstproj_project(with_tot = TRUE)

  report_path <- fs::path(
    "report",
    glue::glue("report_{format(Sys.Date(), '%Y_%m_%d')}.qmd")
  )
  writeLines("old report", report_path)

  expect_error(
    create_report(
      output_type = "html",
      quiet = TRUE
    ),
    "already exists"
  )
})


test_that("create_report() overwrites an existing dated report when overwrite = TRUE", {
  local_lbstproj_project(with_tot = TRUE)

  report_path <- fs::path(
    "report",
    glue::glue("report_{format(Sys.Date(), '%Y_%m_%d')}.qmd")
  )
  writeLines("old report", report_path)

  create_report(
    output_type = "html",
    overwrite = TRUE,
    quiet = TRUE
  )

  report <- readLines(report_path)

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


# FLEXTABLE ENGINE -------------------------------------------------------

test_that("create_report() creates a dated .Rmd report for flextable projects", {
  local_lbstproj_project(with_tot = TRUE, engine = "flextable")

  expected_path <- fs::path(
    "report",
    glue::glue("report_{format(Sys.Date(), '%Y_%m_%d')}.Rmd")
  )

  out <- create_report(quiet = TRUE)

  expect_equal(out, invisible(expected_path))
  expect_true(fs::file_exists(expected_path))
})


test_that("create_report() flextable report contains officedown output format", {
  local_lbstproj_project(with_tot = TRUE, engine = "flextable")

  report_path <- create_report(quiet = TRUE)
  report <- paste(readLines(report_path), collapse = "\n")

  expect_true(grepl("officedown::rdocx_document", report, fixed = TRUE))
})


test_that("create_report() flextable report contains Rmd-style table chunks", {
  local_lbstproj_project(with_tot = TRUE, engine = "flextable")

  tot <- load_tot()
  table_names <- tot$name[tot$type == "table"]
  testthat::skip_if(length(table_names) == 0, "Fake TOT contains no tables.")

  report_path <- create_report(quiet = TRUE)
  report <- paste(readLines(report_path), collapse = "\n")

  expect_true(all(grepl(paste0("tab-", table_names), report, fixed = TRUE)))
  expect_true(grepl("tab.cap=caption_list", report, fixed = TRUE))
})


test_that("create_report() flextable report contains Rmd-style figure chunks", {
  local_lbstproj_project(with_tot = TRUE, engine = "flextable")

  tot <- load_tot()
  figure_names <- tot$name[tot$type == "figure"]
  testthat::skip_if(length(figure_names) == 0, "Fake TOT contains no figures.")

  report_path <- create_report(quiet = TRUE)
  report <- paste(readLines(report_path), collapse = "\n")

  expect_true(all(grepl(paste0("fig-", figure_names), report, fixed = TRUE)))
  expect_true(grepl("fig.cap=caption_list", report, fixed = TRUE))
})


# ---- Section headers ---------------------------------------------------------

make_section_tot <- function(...) {
  data.frame(
    id      = as.character(seq_along(list(...)[[1]])),
    type    = "figure",
    name    = paste0("fig", seq_along(list(...)[[1]])),
    caption = paste0("Figure ", seq_along(list(...)[[1]])),
    ...,
    stringsAsFactors = FALSE
  )
}

test_that("build_section_headers() returns empty strings when section cols are blank", {
  tot <- make_section_tot(
    section = c("", ""), subsection = c("", ""), subsubsection = c("", "")
  )
  result <- lbstproj:::build_section_headers(tot)
  expect_equal(result, c("", ""))
})

test_that("build_section_headers() emits a # header when section changes", {
  tot <- make_section_tot(
    section = c("Results", "Results", "Safety"),
    subsection = c("", "", ""),
    subsubsection = c("", "", "")
  )
  result <- lbstproj:::build_section_headers(tot)
  expect_equal(result[1], "# Results")
  expect_equal(result[2], "")          # same section — no repeat
  expect_equal(result[3], "# Safety")
})

test_that("build_section_headers() emits ## and ### headers for sub-levels", {
  tot <- make_section_tot(
    section       = c("A", "A"),
    subsection    = c("A1", "A2"),
    subsubsection = c("A1a", "")
  )
  result <- lbstproj:::build_section_headers(tot)
  expect_match(result[1], "# A",   fixed = TRUE)
  expect_match(result[1], "## A1", fixed = TRUE)
  expect_match(result[1], "### A1a", fixed = TRUE)
  expect_equal(result[2], "## A2")     # section unchanged; sub changed; no subsub
})

test_that("build_section_headers() resets child tracking when parent changes", {
  tot <- make_section_tot(
    section       = c("A", "B"),
    subsection    = c("A1", "A1"),   # same subsection text under different sections
    subsubsection = c("", "")
  )
  result <- lbstproj:::build_section_headers(tot)
  # Under section B, subsection A1 should be re-emitted (parent changed)
  expect_match(result[2], "## A1", fixed = TRUE)
})

test_that("create_report() includes section headers from TOT", {
  tot_data <- make_section_tot(
    section       = c("Results", "Results"),
    subsection    = c("Primary", "Secondary"),
    subsubsection = c("", "")
  )
  local_lbstproj_project(with_tot = TRUE, tot_data = tot_data)

  report_path <- create_report(output_type = "html", quiet = TRUE)
  report <- paste(readLines(report_path), collapse = "\n")

  expect_match(report, "# Results",    fixed = TRUE)
  expect_match(report, "## Primary",   fixed = TRUE)
  expect_match(report, "## Secondary", fixed = TRUE)
})

test_that("create_report() does not repeat identical section headers", {
  tot_data <- make_section_tot(
    section       = c("Results", "Results", "Results"),
    subsection    = c("", "", ""),
    subsubsection = c("", "", "")
  )
  local_lbstproj_project(with_tot = TRUE, tot_data = tot_data)

  report_path <- create_report(output_type = "html", quiet = TRUE)
  report <- paste(readLines(report_path), collapse = "\n")

  # "# Results" should appear exactly once
  matches <- gregexpr("# Results", report, fixed = TRUE)[[1]]
  expect_equal(length(matches), 1L)
})

test_that("create_report() produces no headers when section cols are all blank", {
  tot_data <- make_section_tot(
    section       = c("", ""),
    subsection    = c("", ""),
    subsubsection = c("", "")
  )
  local_lbstproj_project(with_tot = TRUE, tot_data = tot_data)

  report_path <- create_report(output_type = "html", quiet = TRUE)
  report <- paste(readLines(report_path), collapse = "\n")

  expect_false(grepl("^#", report))
})
