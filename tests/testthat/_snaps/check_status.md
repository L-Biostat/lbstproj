# check_status('figure') output matches snapshot

    Code
      check_status("figure")
    Output
      # Figures
      
      ID | Name | In TOT | In R | In Results
      --------------------------------------
      1  | fig1 |   v    |  v   |     v     

# check_status('table') output matches snapshot

    Code
      check_status("table")
    Output
      # Tables
      
      ID | Name | In TOT | In R | In Results | In Data
      ------------------------------------------------
      2  | tab1 |   v    |  v   |     v      |    v   

# items on disk but absent from TOT appear with missing ID

    Code
      check_status("figure")
    Output
      # Figures
      
      ID | Name      | In TOT | In R | In Results
      -------------------------------------------
      1  | fig1      |   v    |  -   |     -     
      ?  | fig-extra |   -    |  v   |     -     

