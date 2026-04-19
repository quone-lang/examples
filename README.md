# Quone examples

Sample [Quone](https://github.com/quone-lang/compiler) programs that
demonstrate the v0.0.1 surface. They double as documentation and as
fixtures for the compiler test suite.

Quone source files use the uppercase `.Q` extension
([LANGUAGE.md section 3.1](https://github.com/quone-lang/compiler/blob/main/docs/LANGUAGE.md)),
mirroring R's `.R`.

| Example                                        | What it shows                                                                                  |
| ---------------------------------------------- | ---------------------------------------------------------------------------------------------- |
| [`hello.Q`](hello.Q)                           | smallest possible script                                                                       |
| [`scores/`](scores/)                           | literals, vectors, `map`, annotated function definitions                                       |
| [`dataframe-pipeline/`](dataframe-pipeline/)   | every normatively-typed dataframe verb (`filter`, `mutate`, `summarize`, `group_by`, `arrange`) |
| [`decoders/`](decoders/)                       | typed CSV decoder pattern using foreign imports against `readr`                                |
| [`stats-package/`](stats-package/)             | multi-module package with `Stats.Transform`, `Stats.Summary`, `Data.Loader`                    |

## Compile from R (recommended)

The [quone-lang/quone](https://github.com/quone-lang/quone) R
package wraps the compiler and is the smoothest path:

```r
# install.packages("pak")
pak::pak("quone-lang/quone")
quone::install_compiler()

quone::build("examples/scores/scores.Q")
quone::run("examples/scores/scores.Q")

quone::document("examples/stats-package")   # build + roxygenise()
quone::install("examples/stats-package")    # then install into R
```

## Compile from the CLI

```sh
# Single script
quonec build examples/scores/scores.Q
Rscript examples/scores/scores.R

# Multi-module package
quonec build --package examples/stats-package
R -e "roxygen2::roxygenise('examples/stats-package/build')"
```

The package build produces `stats-package/build/` containing:

- `DESCRIPTION` (with `Imports:` inferred from foreign imports,
  dataframe-verb usage, record-update usage, and the
  `[dependencies]` table in `quone.toml`)
- `NAMESPACE` (one `export(name)` line per `@export`-tagged binding;
  carries the roxygen2 sentinel so subsequent `roxygenise()` calls
  refresh it)
- `R/<module>.R` (one per `.Q` file, kebab-cased per
  [LANGUAGE.md section 14.6](https://github.com/quone-lang/compiler/blob/main/docs/LANGUAGE.md))

## Sibling repos

- **[quone-lang/compiler](https://github.com/quone-lang/compiler)** --
  the `quonec` compiler.
- **[quone-lang/quone](https://github.com/quone-lang/quone)** -- R
  companion package.
- **[quone-lang/website](https://github.com/quone-lang/website)** --
  source for [quone-lang.org](https://quone-lang.org).
