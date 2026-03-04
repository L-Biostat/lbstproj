#' Create and enter a temporary project via create_project()
#'
#' @param ... Arguments passed to create_project()
#'
#' @return Path to the created project (invisibly).
#' @keywords internal
local_created_project <- function(...) {
  parent <- fs::dir_create(fs::file_temp(pattern = "lbstproj-create-"))
  withr::defer(fs::dir_delete(parent), envir = parent.frame())

  proj_path <- fs::path(parent, "test-project")
  fs::dir_create(proj_path)

  create_project(
    path = proj_path,
    open = FALSE,
    force = TRUE,
    ...
  )

  withr::local_dir(proj_path, .local_envir = parent.frame())
  usethis::local_project(proj_path, .local_envir = parent.frame())

  invisible(proj_path)
}
