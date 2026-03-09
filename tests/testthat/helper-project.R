# tests/testthat/helper-project.R

#' Create a minimal fake lbstproj project for testing
#'
#' @param with_tot Logical. Should a minimal TOT file be created?
#' @param tot_data Optional data.frame to use as TOT content.
#' @param empty_dirs Logical. Create empty R/figures and R/tables folders?
#' @param rproj_name Name of the .Rproj file to create (default: "fakeproject.Rproj").
#'
#' @return Path to the temporary project root (invisibly).
#'
#' @details
#' Creates an isolated temporary project that mimics the lbstproj structure.
#' Uses withr::local_dir() for robust working-directory restoration.
#' Optionally writes a tot.xlsx in data/metadata/.
#'
#' @keywords internal
local_lbstproj_project <- function(
  with_tot = FALSE,
  tot_data = NULL,
  empty_dirs = TRUE
) {
  root <- fs::dir_create(fs::file_temp(pattern = "lbstproj-test-"))
  # random project name
  rproj_name <- paste0("fakeproject", round(runif(1) * 100), ".Rproj")

  # Always restore wd + cleanup even if the test fails
  withr::local_dir(root, .local_envir = parent.frame())

  # ---- Minimal project structure ----
  fs::dir_create("data")
  fs::dir_create("data/raw")
  fs::dir_create("data/processed")
  fs::dir_create("data/tot")
  fs::dir_create("R")
  fs::dir_create("report")

  if (empty_dirs) {
    fs::dir_create("R/figures")
    fs::dir_create("R/tables")
    fs::dir_create("R/data")
  }

  fs::dir_create("output")
  fs::dir_create("output/figures")
  fs::dir_create("output/tables")

  # ---- Minimal DESCRIPTION (useful if root detection checks for it) ----
  writeLines(
    c(
      "Package: fakeproject",
      "Version: 0.0.0",
      "Description: Temporary test project",
      "License: MIT",
      "Title: Parkinson",
      "Client: Jane Doe",
      "Department: DEP"
    ),
    "DESCRIPTION"
  )

  # ---- Minimal RStudio project marker ----
  # Some root-finders use the presence of an *.Rproj file
  writeLines(
    c(
      "Version: 1.0",
      "",
      "RestoreWorkspace: No",
      "SaveWorkspace: No",
      "AlwaysSaveHistory: Default",
      "",
      "EnableCodeIndexing: Yes",
      "UseSpacesForTab: Yes",
      "NumSpacesForTab: 2",
      "Encoding: UTF-8",
      "",
      "RnwWeave: Sweave",
      "LaTeX: pdfLaTeX"
    ),
    rproj_name
  )

  # ---- Optional TOT as Excel ----
  if (with_tot) {
    if (is.null(tot_data)) {
      tot_data <- data.frame(
        id = c("1", "2"),
        type = c("figure", "table"),
        name = c("fig1", "tab1"),
        caption = c("Figure 1 caption", "Table 1 caption"),
        stringsAsFactors = FALSE
      )
    }

    # Prefer writexl for lightweight writing
    # Put in Suggests: writexl
    tot_path <- fs::path("data/tot/table_of_tables.xlsx")

    writexl::write_xlsx(
      x = list(tot = tot_data),
      path = tot_path
    )
  }

  usethis::local_project(root, .local_envir = parent.frame(), quiet = TRUE)

  invisible(root)
}
