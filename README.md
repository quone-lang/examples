# Quone Examples

These examples target the initial Quone release described in
`compiler/docs/LANGUAGE2.md`.

The examples focus on the first supported workflow:

- read CSV data through typed decoders
- transform dataframes with dplyr-style verbs
- make missingness explicit with `Maybe`
- use grouped summaries and typed joins
- call existing R functions through foreign imports

## Examples

| Directory | What it shows |
| --- | --- |
| `hello.Q` | smallest possible Quone script |
| `scores/` | vectors, functions, math/stat helpers |
| `dataframe-pipeline/` | filter, mutate, summarize, group_by, arrange |
| `decoders/` | typed CSV decoder shape |
| `pharma-analysis/` | larger typed dataframe workflow |

## Compile

From R:

```r
quone::check("examples/scores/scores.Q")
quone::compile("examples/scores/scores.Q")
```

From the CLI:

```sh
quonec check examples/scores/scores.Q
quonec compile examples/scores/scores.Q
```

Examples should be compiled or checked as part of release validation.

