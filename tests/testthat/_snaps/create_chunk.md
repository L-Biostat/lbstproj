# create_chunk() prints the chunk when print = TRUE

    Code
      create_chunk(id = 1, print = TRUE, pad = FALSE)
    Output
      ```{r fig-fig1 }
      #| fig-cap: !expr 'caption_list[["fig1"]]'
      
      knitr::include_graphics(here("results/figures/fig1.png"))
      ```

