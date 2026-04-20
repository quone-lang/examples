#' BMI in kg/m^2 from weight (kg) and height (cm).
bmi <- function(weight_kg, height_cm) { (weight_kg / ((height_cm / 100.0) ^ 2.0)) }

#' Map an age in years to a clinical age band.
age_band <- function(age) { dplyr::if_else((age < 18.0), "<18", dplyr::if_else((age < 65.0), "18-64", ">=65")) }

#' Map a BMI to the WHO weight category.
bmi_category <- function(b) { dplyr::if_else((b < 18.5), "Underweight", dplyr::if_else((b < 25.0), "Normal", dplyr::if_else((b < 30.0), "Overweight", "Obese"))) }

subjects <- readr::read_csv("adsl.csv")

events <- readr::read_csv("adae.csv")

derived_subjects <- subjects |> dplyr::mutate(bmi = bmi(weight_kg, height_cm), bmi_class = bmi_category(bmi(weight_kg, height_cm)), age_class = age_band(age), over_65 = (age >= 65.0))

treatment_emergent <- events |> dplyr::filter((treatment_emergent == 1.0))

per_subject_ae <- treatment_emergent |> dplyr::arrange(subject_id = subject_id) |> dplyr::group_by(subject_id = subject_id) |> dplyr::summarize(n_events = length(severity), mean_severity = mean(severity))

per_arm_demog <- derived_subjects |> dplyr::arrange(arm = arm) |> dplyr::group_by(arm = arm) |> dplyr::summarize(n_subjects = length(subject_id), mean_age = mean(age), mean_bmi = mean(bmi))

#' Per-subject report: ADSL + per-subject AE counts.
#' Subjects with no treatment-emergent events appear with NA event counts
#' (left-join semantics).
report <- derived_subjects |> dplyr::arrange(subject_id = subject_id) |> dplyr::left_join(per_subject_ae) |> readr::write_csv("per_subject_report.csv")

main <- per_arm_demog |> readr::write_csv("per_arm_demog.csv")