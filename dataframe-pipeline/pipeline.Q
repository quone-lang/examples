#' Dataframe pipeline example.
#'
#' Exercises every normatively-typed v0.0.1 dataframe verb:
#' filter, mutate, summarize, group_by, arrange, select.

students <- dataframe { name = ["Alice", "Bob", "Carol", "Dan"], dept = ["math", "cs", "math", "cs"], score = [92.0, 78.0, 85.0, 64.0] }

passing <- students |> filter (score > 70.0) |> mutate { pct = score / 100.0 } |> arrange (desc score)

by_dept <- students |> group_by { dept } |> summarize { avg = mean score } |> arrange (desc avg)
