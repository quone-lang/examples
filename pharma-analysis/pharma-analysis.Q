#' End-to-end clinical-trial analysis in Quone.
#'
#' Reads two ADaM-style CSVs from the script's working directory:
#'
#'   - `adsl.csv` -- one row per subject (demographics + treatment arm)
#'   - `adae.csv` -- one row per adverse event (subject_id, term, severity,
#'                   treatment-emergent flag)
#'
#' Then runs the pipeline a clinical statistician would write by hand:
#'
#'   1. Derive per-subject variables on ADSL (BMI, age band, BMI category)
#'   2. Filter ADAE to treatment-emergent events
#'   3. Aggregate ADAE to one row per subject (event count, mean severity)
#'   4. Aggregate ADSL to one row per treatment arm (n, mean age, mean BMI)
#'   5. Left-join the per-subject AE counts back onto the derived ADSL
#'      and write a per-subject report (`per_subject_report.csv`)
#'   6. Write the per-arm demographic summary (`per_arm_demog.csv`)
#'
#' Compile + run with the R companion package:
#'
#'     quone::run("examples/pharma-analysis/pharma-analysis.Q")
#'
#' or with the CLI:
#'
#'     quonec build examples/pharma-analysis/pharma-analysis.Q
#'     cd examples/pharma-analysis && Rscript pharma-analysis.R


#' Load a CSV into a typed dataframe. The schema declared here is the
#' union of every column referenced by this script. v0.0.1 has no
#' row-polymorphic dataframe types
#' (LANGUAGE.md section 7.6), so a single `read_csv` import is reused
#' for both ADSL and ADAE.
import readr.read_csv : Character -> dataframe { subject_id : Vector Character, arm : Vector Character, age : Vector Double, weight_kg : Vector Double, height_cm : Vector Double, event_term : Vector Character, severity : Vector Double, treatment_emergent : Vector Double }


#' Persist any dataframe to disk. Typed `a -> a` to side-step v0.0.1's
#' closed-record rule for the same reason described above.
import readr.write_csv : Character -> a -> a


#' Vectorised ternary so derived columns stay one-pass over the data.
#' R's native `if` is scalar; `dplyr::if_else` is the column-wise
#' equivalent and is what `dplyr::mutate` expects.
import dplyr.if_else : Logical -> Character -> Character -> Character


#' BMI in kg/m^2 from weight (kg) and height (cm).
bmi : Double -> Double -> Double
bmi weight_kg height_cm <-
    weight_kg / (height_cm / 100.0) ^ 2.0


#' Map an age in years to a clinical age band.
age_band : Double -> Character
age_band age <-
    if_else (age < 18.0) "<18" (if_else (age < 65.0) "18-64" ">=65")


#' Map a BMI to the WHO weight category.
bmi_category : Double -> Character
bmi_category b <-
    if_else (b < 18.5) "Underweight" (if_else (b < 25.0) "Normal" (if_else (b < 30.0) "Overweight" "Obese"))


# ---------------------------------------------------------------------
# Read inputs
# ---------------------------------------------------------------------


subjects <- read_csv "adsl.csv"

events <- read_csv "adae.csv"


# ---------------------------------------------------------------------
# Per-subject derivations on ADSL
# ---------------------------------------------------------------------


derived_subjects <-
    subjects |> mutate { bmi = bmi weight_kg height_cm
                       , bmi_class = bmi_category (bmi weight_kg height_cm)
                       , age_class = age_band age
                       , over_65 = age >= 65.0
                       }


# ---------------------------------------------------------------------
# ADAE: drop pre-treatment events, then aggregate per subject
# ---------------------------------------------------------------------


treatment_emergent <-
    events |> filter (treatment_emergent == 1.0)


per_subject_ae <-
    treatment_emergent |> arrange { subject_id }
        |> group_by { subject_id }
        |> summarize { n_events = length severity
                     , mean_severity = mean severity
                     }


# ---------------------------------------------------------------------
# Per-arm demographic summary
# ---------------------------------------------------------------------


per_arm_demog <-
    derived_subjects |> arrange { arm }
        |> group_by { arm }
        |> summarize { n_subjects = length subject_id
                     , mean_age = mean age
                     , mean_bmi = mean bmi
                     }


# ---------------------------------------------------------------------
# Deliverables
# ---------------------------------------------------------------------


#' Per-subject report: ADSL + per-subject AE counts.
#' Subjects with no treatment-emergent events appear with NA event counts
#' (left-join semantics).
report <-
    derived_subjects |> arrange { subject_id }
        |> left_join per_subject_ae
        |> write_csv "per_subject_report.csv"


main <-
    per_arm_demog |> write_csv "per_arm_demog.csv"
