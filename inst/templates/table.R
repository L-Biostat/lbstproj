#' Name         : {{name}}.R
#' Author       : {{author}}
#' Date         : {{date}}
#' Purpose      :
#' Files created:
#'  - `data/tables/{{name}}.rds`
#'  - `results/tables/{{name}}.docx/html` (optional)
#' Edits        :
#'  - {{date}}: Created file.

# File info ---------------------------------------------------------------

info <- get_info(name = "{{name}}")

# Packages ----------------------------------------------------------------

library(dplyr)
library(gt)

# Load data ---------------------------------------------------------------

data <- NULL # Load processed data here

# Generate table ----------------------------------------------------------

tab <- NULL # Replace NULL with your table code

# Add caption to table ----------------------------------------------------

tab_lbl <- tab |>
  gt::tab_header(title = info$caption)

# Save and export table ---------------------------------------------------

save_table(tab_lbl, name = info$name, export = TRUE)
