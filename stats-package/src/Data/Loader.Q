#' Data loading helpers.
module Data.Loader exporting (load_scores)

import readr.read_csv : Character -> dataframe { name : Vector Character }


#' Load a CSV of scores into a typed dataframe.
#' @export
load_scores : Character -> dataframe { name : Vector Character }
load_scores path <- read_csv path
