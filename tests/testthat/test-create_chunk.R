test_that("create_chunk() renders a figure chunk", {
  local_lbstproj_project(with_tot = TRUE)
  import_tot(quiet = TRUE)

  local_mocked_bindings(
    is_interactive = function() FALSE,
    .package = "rlang"
  )

  out <- create_chunk(
    name = "fig1",
    print = FALSE,
    pad = FALSE
  )
  out <- strsplit(out, "\n", fixed = TRUE)[[1]]
  expect_equal(
    out,
    c(
      "```{r fig-fig1 }",
      "#| fig-cap: !expr 'caption_list[[\"fig1\"]]'",
      "",
      "knitr::include_graphics(here(\"results/figures/fig1.png\"))",
      "```"
    )
  )
})


test_that("create_chunk() renders a table chunk with tbl prefix by default", {
  local_lbstproj_project(with_tot = TRUE)
  import_tot(quiet = TRUE)

  local_mocked_bindings(
    is_interactive = function() FALSE,
    .package = "rlang"
  )

  out <- create_chunk(
    name = "tab1",
    print = FALSE,
    pad = FALSE
  )
  out <- strsplit(out, "\n", fixed = TRUE)[[1]]
  expect_equal(
    out,
    c(
      "```{r tbl-tab1 }",
      "tab <- readRDS(here(\"data/tables/tab1.rds\"))",
      "tab |>",
      "  add_caption(caption_list[[\"tab1\"]])",
      "```"
    )
  )
})


test_that("create_chunk() uses tab prefix for word output", {
  local_lbstproj_project(with_tot = TRUE)
  import_tot(quiet = TRUE)

  local_mocked_bindings(
    is_interactive = function() FALSE,
    .package = "rlang"
  )

  out <- create_chunk(
    output_type = "docx",
    name = "tab1",
    print = FALSE,
    pad = FALSE
  )
  out <- strsplit(out, "\n", fixed = TRUE)[[1]]
  expect_equal(
    out,
    c(
      "```{r tab-tab1 }",
      "tab <- readRDS(here(\"data/tables/tab1.rds\"))",
      "tab |>",
      "  add_caption(caption_list[[\"tab1\"]])",
      "```"
    )
  )
})


test_that("create_chunk() pads the chunk when pad = TRUE", {
  local_lbstproj_project(with_tot = TRUE)
  import_tot(quiet = TRUE)

  local_mocked_bindings(
    is_interactive = function() FALSE,
    .package = "rlang"
  )
  out <- create_chunk(
    name = "fig1",
    print = FALSE,
    pad = TRUE
  )
  out <- strsplit(out, "\n", fixed = TRUE)[[1]]
  expect_equal(out[[6]], "")
  expect_equal(out[[length(out)]], "")
  expect_true("{{< pagebreak >}}" %in% out)
})


test_that("create_chunk() prints the chunk when print = TRUE", {
  local_lbstproj_project(with_tot = TRUE)
  import_tot(quiet = TRUE)

  local_mocked_bindings(
    is_interactive = function() FALSE,
    .package = "rlang"
  )

  expect_snapshot(
    create_chunk(
      id = 1,
      print = TRUE,
      pad = FALSE
    )
  )
})


test_that("create_chunk() does not print when print = FALSE", {
  local_lbstproj_project(with_tot = TRUE)
  import_tot(quiet = TRUE)

  local_mocked_bindings(
    is_interactive = function() FALSE,
    .package = "rlang"
  )

  expect_no_message(
    create_chunk(
      id = 1,
      print = FALSE,
      pad = FALSE
    )
  )
})


test_that("create_chunk() copies the chunk to the clipboard in interactive mode", {
  clipboard <- NULL

  local_lbstproj_project(with_tot = TRUE)
  import_tot(quiet = TRUE)

  local_mocked_bindings(
    is_interactive = function() TRUE,
    .package = "rlang"
  )

  local_mocked_bindings(
    writeClipboard = function(x) {
      clipboard <<- x
      invisible(x)
    },
    .package = "utils"
  )

  expect_message(
    create_chunk(
      name = "fig1",
      print = FALSE,
      pad = FALSE
    ),
    "copied to the clipboard"
  )
  clipboard <- strsplit(clipboard, "\n", fixed = TRUE)[[1]]
  expect_equal(
    clipboard,
    c(
      "```{r fig-fig1 }",
      "#| fig-cap: !expr 'caption_list[[\"fig1\"]]'",
      "",
      "knitr::include_graphics(here(\"results/figures/fig1.png\"))",
      "```"
    )
  )
})


test_that("create_chunk() forwards errors from get_info()", {
  local_lbstproj_project(with_tot = TRUE)
  import_tot(quiet = TRUE)

  expect_error(
    create_chunk(id = 1, name = "y", print = FALSE),
    "Please provide either"
  )
})
