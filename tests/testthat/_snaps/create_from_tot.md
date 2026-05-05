# cli_report_program()

    Code
      cli_report_program(type = "tables", n_tot = 3, n_disk = 2, matched = c(
        "tab_a.R", "tab_b.R"), new = "tab_c.R", extra = "tab_old.R", dry_run = TRUE)
    Message
      
      -- Tables 
      i 3 in TOT, 2 on disk, 2 matched.
      i Would generate 1 missing program in 'R/tables':
      * 'R/tables/tab_c.R'
      ! Dry run only: no files were generated. Run `create_from_tot(dry_run = FALSE)` to generate files.
      ! 1 extra program on disk (not in TOT): tab_old.R

---

    Code
      cli_report_program(type = "tables", n_tot = 0, n_disk = 0, matched = character(),
      new = character(), extra = character(), dry_run = TRUE)
    Message
      
      -- Tables 
      i 0 in TOT, 0 on disk, 0 matched.
      i None declared in TOT - nothing to do.

---

    Code
      cli_report_program(type = "figures", n_tot = 2, n_disk = 1, matched = "fig_a.R",
        new = "fig_b.R", extra = character(), dry_run = FALSE)
    Message
      
      -- Figures 
      i 2 in TOT, 1 on disk, 1 matched.
      i Generating 1 missing program in 'R/figures':
      * 'R/figures/fig_b.R'

