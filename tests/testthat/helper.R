local_create_project <- function(dir = tempdir(), env = parent.frame()) {
  # Store the current active project
  old_project <- usethis::ui_silence(usethis::proj_get())

  # Create a new project at the specified directory
  create_project(
    path = dir,
    author = "Test Author",
    title = "Test Project",
    client = "Test Client",
    department = "TEST",
    version = "1.0",
    open = FALSE,
    force = TRUE,
    quiet = TRUE
  )
  # Defer the deletion of the new project directory at the end of the parent call
  withr::defer(fs::dir_delete(dir), envir = env)

  # Defer the restoration of the old project at the end of the parent call
  withr::defer(
    usethis::ui_silence(usethis::proj_set(old_project, force = TRUE)),
    envir = env
  )

  # Return the path to the new project invisibly
  fs::path(dir)
}
