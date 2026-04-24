#' Typed CSV decoder example.

type alias Students <-
    dataframe
        { name : Vector Character
        , class : Vector Character
        , score : Vector Double
        }

students_decoder : Csv.DataframeDecoder Students
students_decoder <-
    Csv.dataframe
        |> Csv.column "name" character
        |> Csv.column "class" character
        |> Csv.column "score" double

students <-
    read_csv students_decoder "students.csv"
        |> expect

summary <-
    students
        |> group_by { class }
        |> summarize { avg_score = mean score }
