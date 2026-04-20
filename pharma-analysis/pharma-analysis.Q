import readr.read_csv :
    Character
        -> dataframe
            { subject_id : Vector Character
            , arm : Vector Character
            , age : Vector Double
            , weight_kg : Vector Double
            , height_cm : Vector Double
            , event_term : Vector Character
            , severity : Vector Double
            , treatment_emergent : Vector Double
            }

import readr.write_csv : Character -> a -> a

import dplyr.if_else : Logical -> Character -> Character -> Character


bmi : Double -> Double -> Double
bmi weight_kg height_cm <-
    weight_kg / (height_cm / 100.0) ^ 2.0


age_band : Double -> Character
age_band age <-
    if_else (age < 18.0) "<18" (if_else (age < 65.0) "18-64" ">=65")


bmi_category : Double -> Character
bmi_category b <-
    let
        over25 <- if_else (b < 30.0) "Overweight" "Obese"
        over18 <- if_else (b < 25.0) "Normal" over25
    in
        if_else (b < 18.5) "Underweight" over18


subjects <- read_csv "adsl.csv"

events <- read_csv "adae.csv"


derived_subjects <-
    subjects |> mutate { bmi = bmi weight_kg height_cm
                       , bmi_class = bmi_category (bmi weight_kg height_cm)
                       , age_class = age_band age
                       , over_65 = age >= 65.0
                       }


treatment_emergent <-
    events |> filter (treatment_emergent == 1.0)


per_subject_ae <-
    treatment_emergent |> arrange { subject_id }
        |> group_by { subject_id }
        |> summarize { n_events = length severity
                     , mean_severity = mean severity
                     }


per_arm_demog <-
    derived_subjects |> arrange { arm }
        |> group_by { arm }
        |> summarize { n_subjects = length subject_id
                     , mean_age = mean age
                     , mean_bmi = mean bmi
                     }


report <-
    derived_subjects |> arrange { subject_id }
        |> left_join per_subject_ae
        |> write_csv "per_subject_report.csv"


main <-
    per_arm_demog |> write_csv "per_arm_demog.csv"
