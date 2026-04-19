#' Load a CSV of scores into a typed dataframe.
#' @export
load_scores <- function(path) { readr::read_csv(path) }