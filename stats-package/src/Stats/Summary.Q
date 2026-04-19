#' Aggregate-level summaries.
module Stats.Summary exporting (mean_score)

import Stats.Transform.normalize


#' Mean score for a vector, normalised against a cap.
#' @export
mean_score : Vector Double -> Double
mean_score scores <- mean (map (normalize 100.0) scores)
