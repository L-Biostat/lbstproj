#' Name         : {{name}}
#' Author       : {{author}}
#' Date         : {{date}}
#' Purpose      : description
#' Files created:
#'  - `data/tables/{{name}}.rds`
#'  - `results/tables/{{name}}.docx/html` (optional)
#' Edits        :
#'  - {{date}}: Created file.

# File info ----------------------------------------------------------------------

info <- get_info({{ id }})

# Packages -----------------------------------------------------------------------

library(dplyr)

# Generate figure ----------------------------------------------------------------

tab <- NULL # Replace NULL with your table code

# Save figure --------------------------------------------------------------------

lbstproj::save_table(tab, name = "{{name}}")
lbstproj::export_table(tab, name = "{{name}}", ext = "docx")
