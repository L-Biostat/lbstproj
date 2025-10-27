#' Name         : {{name}}
#' Author       : {{author}}
#' Date         : {{date}}
#' Purpose      : description
#' Files created: `results/figures/{{name}}.png/pdf`
#' Edits        :
#'  - {{date}}: Created file.

# File info ---------------------------------------------------------------

info <- get_info({{ id }})

# Packages ----------------------------------------------------------------

library(dplyr)
library(ggplot2)

# Load data ---------------------------------------------------------------

data <- NULL # Load processed data here

# Generate figure ---------------------------------------------------------

fig <- NULL # Replace NULL with your figure code, e.g. ggplot(data) + ...

# Save figure -------------------------------------------------------------

lbstproj::export_figure(fig, name = "{{name}}", ext = "png")
