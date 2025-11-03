tmp <- withr::local_tempdir()
create_project(
  path = tmp,
  author = "Test Author",
  title = "Test Project",
  client = "Test Client",
  department = "TEST",
  version = "1.0",
  open = FALSE,
  force = TRUE,
  quiet = TRUE
)

test_that("Structure is correct", {
  expected_dirs <- c(
    "data/figures",
    "data/processed",
    "data/raw",
    "data/tables",
    "data/tot",
    "docs/meetings",
    "results/figures",
    "results/tables",
    "R/data",
    "R/figures",
    "R/tables",
    "report/utils"
  )
  for (dir in expected_dirs) {
    expect_true(
      dir.exists(file.path(tmp, dir)),
      info = paste("Directory", dir, "exists")
    )
  }
})

test_that("DESCRIPTION file is created correctly", {
  desc_path <- file.path(tmp, "DESCRIPTION")
  expect_true(file.exists(desc_path), info = "DESCRIPTION file exists")

  d <- desc::description$new(desc_path)
  expect_true(
    d$get("Package") == fs::path_file(tmp),
    info = "Package name is correct"
  )
  expect_true(d$get("Title") == "Test Project", info = "Title is correct")
  expect_true(d$get("Client") == "Test Client", info = "Client is correct")
  expect_true(d$get("Department") == "TEST", info = "Department is correct")
  expect_true(d$get("Version") == "1.0", info = "Version is correct")
})

test_that("TOT file is created", {
  tot_path <- file.path(tmp, "data", "tot", "table_of_tables.xlsx")
  expect_true(file.exists(tot_path), info = "TOT README.md file exists")
})
