#' CSV decoder example.
#'
#' Demonstrates the section 11 decoder pattern using foreign-import
#' bindings against R's `readr` package. The Csv/Script wrappers
#' described in LANGUAGE.md section 11 are layered on top of these
#' raw imports in the planned standard environment.

import readr.read_csv : Character -> dataframe { name : Vector Character }

import readr.write_csv : dataframe { name : Vector Character } -> Character -> dataframe { name : Vector Character }


#' Load student scores from a CSV file.
#' @export
load_scores : Character -> dataframe { name : Vector Character }
load_scores path <- read_csv path


#' Write a typed dataframe back to disk.
#' @export
save : dataframe { name : Vector Character } -> Character -> dataframe { name : Vector Character }
save df path <- write_csv df path
