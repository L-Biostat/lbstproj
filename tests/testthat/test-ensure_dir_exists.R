test_that("ensure_dir_exists creates dir in non-interactive session", {
  local_lbstproj_project()

  dir <- fs::path("output", "newdir")
  expect_false(fs::dir_exists(dir))

  out <- ensure_dir_exists(dir, confirm = TRUE, print = FALSE)

  expect_true(fs::dir_exists(dir))
  expect_identical(out, proj_rel_path(dir))
})

test_that("ensure_dir_exists creates dir in non-interactive session when confirm = FALSE", {
  local_lbstproj_project()

  dir <- fs::path("output", "silent")
  out <- ensure_dir_exists(dir, confirm = FALSE, print = FALSE)

  expect_true(fs::dir_exists(dir))
  expect_identical(out, proj_rel_path(dir))
})
