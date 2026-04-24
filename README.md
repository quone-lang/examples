# Quone Examples

These examples show Quone's first supported workflow: write typed data
transformation code, compile it to readable R, and run the R output.

## Start Here

Use the pharma analysis as the canonical proof example:

[`pharma-analysis/`](pharma-analysis/)

It demonstrates a realistic end-to-end workflow:

- read CSV data
- derive subject-level variables
- filter and summarize event data
- left-join summaries back to subjects
- write generated R and final CSV outputs

The example is small enough to inspect, but realistic enough to show why static
checks matter for R-style data transformation work.

## Other Examples

| Directory | What it shows |
| --- | --- |
| `hello.Q` | smallest possible Quone script |
| `scores/` | vectors, functions, math/stat helpers |
| `dataframe-pipeline/` | filter, mutate, summarize, group_by, arrange |
| `decoders/` | typed CSV decoder shape |
| `pharma-analysis/` | full CSV-to-report workflow |

## Compile

From R:

```r
quone::check("examples/pharma-analysis/pharma-analysis.Q")
quone::compile("examples/pharma-analysis/pharma-analysis.Q")
```

From the CLI:

```sh
quonec check examples/pharma-analysis/pharma-analysis.Q
quonec compile examples/pharma-analysis/pharma-analysis.Q
```

Generated `.R` files are intentionally readable and should be reviewed as part
of each example.

