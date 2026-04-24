# Pharma analysis

A realistic clinical-trial analysis written in Quone. It mirrors the
shape of work a statistical programmer does daily on
[ADaM](https://www.cdisc.org/standards/foundational/adam) datasets.

## Inputs

Two CSVs in this directory, each one row per record:

| File         | Grain          | Columns                                                       |
| ------------ | -------------- | ------------------------------------------------------------- |
| `adsl.csv`   | one per subject | `subject_id`, `arm`, `age`, `weight_kg`, `height_cm`         |
| `adae.csv`   | one per event  | `subject_id`, `event_term`, `severity`, `treatment_emergent` |

## Pipeline

The Quone source ([`pharma-analysis.Q`](pharma-analysis.Q)) walks through
six stages a clinical statistician would write by hand:

1. **Read** the two CSVs through a typed `readr::read_csv` foreign import.
2. **Derive** per-subject variables on ADSL: `bmi`, `bmi_class`,
   `age_class`, `over_65` (via `mutate` and three small helper
   functions).
3. **Filter** ADAE down to treatment-emergent events.
4. **Aggregate** ADAE to one row per subject (`n_events`,
   `mean_severity`).
5. **Aggregate** ADSL to one row per treatment arm (`n_subjects`,
   `mean_age`, `mean_bmi`).
6. **Left-join** the per-subject AE counts onto derived ADSL and write
   `per_subject_report.csv`; also write the per-arm demographic summary
   to `per_arm_demog.csv`.

Each transformation is one composed pipeline; only the final
deliverables touch disk.

## Quone features demonstrated

- foreign R imports (`readr.read_csv`, `readr.write_csv`,
  `dplyr.if_else`)
- annotated top-level functions and the standard prelude (`length`,
  `mean`)
- vectorized conditional via `dplyr::if_else`
- typed dataframe verbs -- `filter`, `mutate`, `summarize`, `group_by`,
  `arrange` -- composed through `|>`
- `left_join` to combine derived subject data with per-subject event summaries

## Run it

```sh
# From the repo root, with the `quonec` CLI on PATH:
quonec compile examples/pharma-analysis/pharma-analysis.Q
cd examples/pharma-analysis && Rscript pharma-analysis.R
```

Or, equivalently, through the
[R companion package](https://github.com/quone-lang/quone):

```r
quone::compile("examples/pharma-analysis/pharma-analysis.Q")
```

Either path produces:

- `per_arm_demog.csv` -- two rows (one per treatment arm) with subject
  counts and mean age + BMI.
- `per_subject_report.csv` -- six rows (one per subject) with derived
  variables and a left-joined event count. `S003` only had a
  pre-treatment event, so its `n_events` and `mean_severity` are `NA`.

## Generated R

[`pharma-analysis.R`](pharma-analysis.R) is the `quonec compile` output,
hand-rewrapped to 80 columns for readability. The semantics are
unchanged from what the compiler emits: qualified `dplyr::` / `readr::`
calls, R's native pipe, no Quone runtime. It is the kind of file an R
reviewer can read top-to-bottom without surprise -- the design goal in
[LANGUAGE.md section 1.2](https://github.com/quone-lang/compiler/blob/main/docs/LANGUAGE.md#12-design-principles),
principle 7.
