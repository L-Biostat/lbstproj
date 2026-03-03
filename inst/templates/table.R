#' Name         : {{name}}.R
#' Author       : {{author}}
#' Date         : {{date}}
#' Purpose      : description
#' Files created:
#'  - `data/tables/{{name}}.rds`
#'  - `results/tables/{{name}}.docx/html` (optional)
#' Edits        :
#'  - {{date}}: Created file.

# File info ---------------------------------------------------------------

info <- get_info({{ id }})

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

lbstproj::save_table(tab_lbl, name = "{{name}}")
lbstproj::export_table(tab_lbl, name = "{{name}}", ext = "docx")
