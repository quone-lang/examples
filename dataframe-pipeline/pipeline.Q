#' Dataframe pipeline example.
#'
#' Exercises core initial-release dataframe verbs:
#' filter, mutate, summarize, group_by, arrange, select.

students <-
    dataframe
        { name = ["Alice", "Bob", "Carol", "Dan"]
        , dept = ["math", "cs", "math", "cs"]
        , score = [92, 78, 85, 64]
        }

passing <-
    students
        |> filter (score > 70)
        |> mutate { pct = score / 100 }
        |> arrange (desc score)

by_dept <-
    students
        |> group_by { dept }
        |> summarize { avg = mean score }
        |> arrange (desc avg)
