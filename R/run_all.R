run_all_programs <- function(type, skip = NULL) {
  # Check that type is valid
  type <- rlang::arg_match(type, c("figure", "table"))
  # Check that skip is a vector of non-negative integers if non-NULL
  if (!is.null(skip)) {
    if (!is.numeric(skip) || any(skip < 0) || any(skip != as.integer(skip))) {
      cli::cli_abort("{.arg skip} must be a vector of non-negative integers.")
    }
  }
  # Printed message
  cli::cli_h1("Generating all {type}s\n")
  # Load the ToT
  tot <- load_tot()
  # Isolate corresponding scripts in the ToT
  script_names <- tot$name[tot$type == type]
  if (!is.null(skip)) {
    script_names <- tot$name[tot$type == type & !(tot$id %in% (skip))]
  }
  n_scripts <- length(script_names)
  cli::cli_alert_info(
    "Found {cli::no(n_scripts)} {type}{cli::qty(n_scripts)}{?s} in ToT"
  )

  # Source each figure
  seq <- seq_len(n_scripts)
  if (!is.null(skip)) {
    seq <- seq[skip + 1:n]
  }
  for (i in seq) {
    row <- df[i, ]
    cli::cli_progress_step(
      msg = "Generating {type} {.strong {i}/{n}}: {.emph {row$name}} ...",
      msg_done = "Generated {type} {.strong {i}/{n}}: {.emph {row$name}}",
      spinner = TRUE
    )
    withr::with_options(
      list(print_info = FALSE),
      source(here::here(glue::glue("R/{type}s/{row$name}.R")))
    )
    cli::cli_process_done()
  }
}
