#' Name         : {{name}}
#' Author       : {{author}}
#' Date         : {{date}}
#' Purpose      : description
#' Files created: `data/processed/{{name}}.rds`
#' Edits        :
#'  - {{date}}: Created file.

# Packages -----------------------------------------------------------------------

library(tidyverse)

# Generate data ------------------------------------------------------------------

df <- NULL # Replace NULL with your data generation code

# Save data ----------------------------------------------------------------------

lbstproj::save_data(df, name = "{{ name }}")
