#' Score normalisation primitives.
module Stats.Transform exporting (normalize, rmse)


#' Normalise a raw score against a maximum.
#'
#' @param max_score The maximum possible score.
#' @param raw The raw value.
#' @export
normalize : Double -> Double -> Double
normalize max_score raw <- raw / max_score


#' Root-mean-squared error helper, returns a single Double.
#' @export
rmse : Vector Double -> Double
rmse predictions <- sqrt (mean predictions)
