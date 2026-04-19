#' Normalise a raw score against a maximum.
#' 
#' @param max_score The maximum possible score.
#' @param raw The raw value.
#' @export
normalize <- function(max_score, raw) { (raw / max_score) }

#' Root-mean-squared error helper, returns a single Double.
#' @export
rmse <- function(predictions) { sqrt(mean(predictions)) }