test_that("create_project creates expected structure", {
  proj <- local_created_project(
    author = "Test Author",
    title = "Test Project",
    client = "Test Client",
    email = "test@email.com",
    department = "TEST",
    version = "1.0",
    quiet = FALSE
  )

  expected_dirs <- c(
    "data/figures",
    "data/processed",
    "data/raw",
    "data/tables",
    "data/tot",
    "docs",
    "results/figures",
    "results/tables",
    "R/data",
    "R/figures",
    "R/tables",
    "report/utils"
  )

  for (dir in expected_dirs) {
    expect_true(fs::dir_exists(fs::path(proj, dir)))
  }
})

test_that("DESCRIPTION file is created correctly", {
  proj <- local_created_project(
    author = "Test Author",
    title = "Test Project",
    client = "Test Client",
    email = "test@email.com",
    department = "TEST",
    version = "1.0",
    quiet = TRUE
  )

  desc_path <- file.path(proj, "DESCRIPTION")
  expect_true(file.exists(desc_path), info = "DESCRIPTION file exists")

  d <- desc::description$new(desc_path)
  expect_true(
    d$get("Package") == fs::path_file(proj),
    info = "Package name is correct"
  )
  expect_true(d$get("Title") == "Test Project", info = "Title is correct")
  expect_true(d$get("Client") == "Test Client", info = "Client is correct")
  expect_true(d$get("Department") == "TEST", info = "Department is correct")
  expect_true(d$get("Version") == "1.0", info = "Version is correct")
})

test_that("TOT file is created", {
  proj <- local_created_project(
    author = "Test Author",
    title = "Test Project",
    client = "Test Client",
    email = "test@email.com",
    department = "TEST",
    version = "1.0",
    quiet = TRUE
  )
  tot_path <- file.path(proj, "data", "tot", "table_of_tables.xlsx")
  expect_true(file.exists(tot_path), info = "TOT README.md file exists")
})

test_that("Rprofile file is created", {
  proj <- local_created_project(
    author = "Test Author",
    title = "Test Project",
    client = "Test Client",
    email = "test@email.com",
    department = "TEST",
    version = "1.0",
    quiet = TRUE
  )
  path <- file.path(proj, ".Rprofile")
  content <- readLines(path)

  expect_true(file.exists(path))
  expect_true(any(grepl("^library\\(lbstproj\\)", content)))
})

test_that("Default author works when supplied", {
  withr::local_envvar(LBSTPROJ_AUTHOR = "Jane Doe")
  author <- prompt_author(NULL)
  expect_identical(author, "Jane Doe")
})

test_that("Default email works when supplied", {
  withr::local_envvar(LBSTPROJ_EMAIL = "jane.doe@email.com")
  author <- prompt_email(NULL)
  expect_identical(author, "jane.doe@email.com")
})
