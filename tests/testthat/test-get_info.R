test_that("get_info() errors when both id and name are NULL", {
  expect_error(
    get_info(),
    "Please provide either"
  )
})

test_that("get_info() errors when both id and name are provided", {
  expect_error(
    get_info(id = "T001", name = "baseline"),
    "Please provide either"
  )
})

test_that("get_info() returns correct entry by id", {
  fake_tot <- data.frame(
    id = c("T001", "T002"),
    name = c("baseline", "followup"),
    caption = c("Baseline table", "Follow-up table"),
    stringsAsFactors = FALSE
  )

  with_mocked_bindings(
    load_tot = function() fake_tot,
    {
      res <- get_info(id = "T001")

      expect_type(res, "list")
      expect_equal(res$id, "T001")
      expect_equal(res$name, "baseline")
      expect_equal(res$caption, "Baseline table")
    }
  )
})

test_that("get_info() returns correct entry by name", {
  fake_tot <- data.frame(
    id = c("T001", "T002"),
    name = c("baseline", "followup"),
    caption = c("Baseline table", "Follow-up table"),
    stringsAsFactors = FALSE
  )

  with_mocked_bindings(
    load_tot = function() fake_tot,
    {
      res <- get_info(name = "followup")

      expect_equal(res$id, "T002")
      expect_equal(res$caption, "Follow-up table")
    }
  )
})

test_that("get_info() errors when entry does not exist", {
  fake_tot <- data.frame(
    id = "T001",
    name = "baseline",
    stringsAsFactors = FALSE
  )

  with_mocked_bindings(
    load_tot = function() fake_tot,
    {
      expect_error(
        get_info(id = "T999"),
        "No entry found"
      )
    }
  )
})
