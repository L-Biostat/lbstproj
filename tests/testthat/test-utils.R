test_that("get_table_engine() returns stored engine", {
  local_lbstproj_project(with_tot = FALSE)
  expect_equal(get_table_engine(), "gt")
})

test_that("get_table_engine() returns 'gt' when field is missing (legacy)", {
  local_lbstproj_project(with_tot = FALSE)
  # Remove TableEngine field to simulate a legacy project
  desc::desc_del("TableEngine")
  expect_equal(get_table_engine(), "gt")
})

test_that("is_gt_project() is TRUE when engine is 'gt'", {
  local_lbstproj_project(with_tot = FALSE)
  expect_true(is_gt_project())
})

test_that("is_flextable_project() is FALSE when engine is 'gt'", {
  local_lbstproj_project(with_tot = FALSE)
  expect_false(is_flextable_project())
})

test_that("is_flextable_project() is TRUE when engine is 'flextable'", {
  local_lbstproj_project(with_tot = FALSE)

  desc::desc_set("TableEngine", "flextable")
  expect_true(is_flextable_project())
})

test_that("is_gt_project() is FALSE when engine is 'flextable'", {
  local_lbstproj_project(with_tot = FALSE)
  desc::desc_set("TableEngine", "flextable")
  expect_false(is_gt_project())
})
