#' Name         : {{name}}.R
#' Author       : {{author}}
#' Date         : {{date}}
#' Purpose      :
#' Files created:
#'  - `results/figures/{{name}}.png/pdf`
#' Edits        :
#'  - {{date}}: Created file.

# File info ---------------------------------------------------------------

info <- get_info(name = "{{name}}")

# Packages ----------------------------------------------------------------

library(dplyr)
library(ggplot2)

# Load data ---------------------------------------------------------------

data <- NULL # Load processed data here

# Generate figure ---------------------------------------------------------

fig <- NULL # Replace NULL with your figure code, e.g. ggplot(data) + ...

# Save figure -------------------------------------------------------------

save_figure(fig, name = "{{name}}")
