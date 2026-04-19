#' Score normalisation example.
#'
#' Demonstrates literals, vectors, function calls, and the higher-order
#' map function over Vector Double.

scores : Vector Double
scores <- [92.0, 88.5, 71.0, 64.0]

normalize : Double -> Double -> Double
normalize max_score raw <- raw / max_score

normalised <- map (normalize 100.0) scores

average <- mean normalised
