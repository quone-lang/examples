#' Mean score for a vector, normalised against a cap.
#' @export
mean_score <- function(scores) { mean(map(normalize(100.0), scores)) }