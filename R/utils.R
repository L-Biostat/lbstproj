get_author <- function() {
  author <- desc::desc_get_author(role = "cre")
  # If family name is missing, return the whole name
  if (is.null(author$family)) {
    return(author$given)
  } else {
    return(paste(author$given, author$family))
  }
}
