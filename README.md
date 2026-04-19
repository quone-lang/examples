# Quone examples

Sample Quone programs that demonstrate the v0.0.1 surface.

| Example                  | What it shows                                                  |
| ------------------------ | -------------------------------------------------------------- |
| `hello.Q`                | smallest possible script                                       |
| `scores/`                | literals, vectors, `map`, annotated function definitions       |
| `dataframe-pipeline/`    | every normatively-typed dataframe verb (`filter`, `mutate`, `summarize`, `group_by`, `arrange`) |
| `decoders/`              | typed CSV decoder pattern using foreign imports against `readr` |
| `stats-package/`         | multi-module package with `Stats.Transform`, `Stats.Summary`, `Data.Loader` |

Quone source files use the uppercase `.Q` extension (LANGUAGE.md
section 3.1), mirroring R's `.R`.

## Compile a script

```sh
cd /Users/armcn/dev/quone-lang/compiler
cabal run quonec -- build ../examples/scores/scores.Q
Rscript ../examples/scores/scores.R
```

## Compile the multi-module package

```sh
cd /Users/armcn/dev/quone-lang/compiler
cabal run quonec -- build --package ../examples/stats-package
```

This produces `stats-package/build/` containing:

- `DESCRIPTION` (with `Imports:` inferred from foreign imports + verb / record-update usage + `quone.toml` `[dependencies]`)
- `NAMESPACE` (with one `export(name)` line per `@export`-tagged binding)
- `R/<module>.R` (one per `.Q` file, kebab-cased per LANGUAGE.md section 14.6)

To finalise the package's `man/` entries, run:

```sh
R -e "roxygen2::roxygenise('../examples/stats-package/build')"
```
