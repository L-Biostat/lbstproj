create_project <- function(
  title,
  client,
  department,
  version = 1.0,
  author
) {
  # Create project
  usethis::ui_silence(
    usethis::create_project(
      path = ".",
      rstudio = TRUE,
      open = FALSE
    )
  )

  cli::cli_alert_info(
    "Setting active project to {.path {usethis::proj_get()}}"
  )

  rproj_file <- fs::dir_ls(".", type = "file", glob = "*.Rproj")
  cli::cli_alert_info("Writing {.file {rproj_file}} ")
  cli::cli_alert_info("Creating project structure ")

  # Define the directories to be created
  dirs <- c(
    "data/processed",
    "data/raw",
    "data/tables",
    "inst",
    "output/figures",
    "output/tables",
    "R/data",
    "R/figures",
    "report"
  )
  fs::dir_create(dirs)

  # Prepare DESCRIPTION fields
  author_names <- stringr::str_split_1(author, "\\s+")
  # Fallbacks in case only one name is supplied
  given <- author_names[1]
  family <- if (length(author_names) >= 1) author_names[-1] else author_names[1]

  fields_list <- list(
    Title = title,
    Client = client,
    Department = department,
    Version = version,
    "Authors@R" = utils::person(
      given,
      family,
      role = c("aut", "cre")
    )
  )

  cli::cli_alert_info("Writing {.file DESCRIPTION}")

  # Write DESCRIPTION quietly
  usethis::ui_silence(
    usethis::use_description(
      fields = fields_list,
      check_name = FALSE,
      roxygen = FALSE
    )
  )
  desc::desc_del("Description")
  desc::desc_del("License")
  cli::cli_alert_success("Project setup complete! Start working!")
  invisible(usethis::proj_get())
}
