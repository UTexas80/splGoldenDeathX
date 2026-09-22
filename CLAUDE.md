# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this project is

An R/ProjectTemplate project ("SPL Golden Crossing Dashboard") that backtests Golden Cross / Death Cross / No Cross
moving-average trading strategies (EMA and SMA, at 20/50/100/200-day windows) against Starpharma (SPL.AX) price
data using `quantstrat`/`blotter`, then presents the results in a `flexdashboard` + Shiny dashboard. See
`README.md` for the full strategy rules (entry/exit conditions, 10,000-share position sizing, USD/no-fee
assumptions) — read it before changing any strategy logic in `munge/02-*` or `munge/03-*`.

## Running the project

This is a [ProjectTemplate](http://projecttemplate.net/) project, not a package — there is no build step in the
usual sense. The entire pipeline (data load → munge → strategy backtests → dashboard) runs by executing the root
script:

```r
# from an R console with the working directory set to the repo root
source("splGoldenDeathX.r")
# equivalent to:
library("ProjectTemplate")
load.project()
```

`renv` manages package versions (`renv.lock`, R 4.4.0). Restore the environment before running anything:

```r
renv::restore()
```

`.Rprofile` sets `renv.config.install.suggests = FALSE` (to skip `rJava`-dependent suggests like `xlsx`) and
activates a project `.venv` via `reticulate` if present.

### Execution order (`munge/`)

`load.project()` runs everything in `data/` first (loading `data/dT.xlsx` and `data/trend.xlsx` into `data.table`
objects such as `dT.entry`, `dT.trend`, `dT.strategy`, `dT.ind`, `dT.indMetrics`, `dT.sig`, `dT.position`,
`dT.point`, `dT.formula`, `dT.trade` — see `config/global.dcf` for data-loading options), then runs every script
in `munge/` **in filename order**:

1. `00-A.R`, `00-B.R` — key the `dT.*` tables, build derived tables (`dt_ma`, `trend_name`, `trend_ind`, ...).
2. `01-Performance.R` — performance summary calcs.
3. `02-TrendDeathX.r` / `02-TrendGoldenX.r` / `02-TrendNeitherX.r` — identify Death/Golden/No-Cross trend windows.
4. `03-dXema.r`, `03-dXsma.r`, `03-gXema.r`, `03-gXsma.r`, `03-nXema.r`, `03-nXsma.r`, `03-TA.R` — per-strategy
   (Death/Golden/No-Cross × EMA/SMA) indicator and technical-analysis construction.
5. `05-algorithmicTrading.r`, `05-algorithmicTradingBuyHold.r` — `quantstrat` strategy definitions, order/rule
   setup, and the buy-and-hold benchmark.
6. `10-TheWholeShabang.r` — runs the full backtest.
7. `99-Reporting.R`, `99-SaveRDS.R` — build trade stats/summaries and persist results as `.rds`/`.RData` into
   `rds/`, `rdata/`, and mirrored copies under `SPL-Dashboard/rds/` and `SPL-Dashboard/rdata/` (the dashboard reads
   from the `SPL-Dashboard/` copies via `resource_files` in the Rmd).
8. `99-Z.R` — resolves a working Pandoc install (checks `Sys.which("pandoc")`, falls back to Homebrew/Chocolatey/
   Program Files paths, sets `RSTUDIO_PANDOC`), then launches the dashboard with
   `rmarkdown::run("./SPL-Dashboard/FlexDashboard.Rmd")`. This is a `runtime: shiny` document, so it must be run
   with `rmarkdown::run()`, not `rmarkdown::render()`.

Because everything is munged sequentially and later scripts depend on data.tables/xts objects created by earlier
ones, a script under `munge/` cannot be sourced standalone — always go through `load.project()` (or at minimum
source every prior-numbered script first) when testing a change.

### Running the dashboard directly

Once `.rds`/`.RData` artifacts exist in `SPL-Dashboard/rds/` and `SPL-Dashboard/rdata/` (produced by the munge
pipeline), the dashboard alone can be re-launched without rerunning the full backtest:

```r
rmarkdown::run("SPL-Dashboard/FlexDashboard.Rmd")
```

Deployment to shinyapps.io (`rsconnect::deployApp(...)`) is scripted but commented out at the bottom of
`munge/99-Z.R`.

## Tests

There is no `testthat` suite. `tests/` (per ProjectTemplate convention, driven by `ProjectTemplate::test.project()`)
currently holds ad hoc R/Rmd scripts (`1.R`, `99-A.R`, `TheWholeShabang.r`, etc.) rather than real unit tests —
treat them as scratch/validation scripts, not a CI gate.

## Architecture

- **`data/`** — raw inputs: `dT.xlsx` (multi-table strategy/trend/indicator definitions loaded into `dT.*`
  data.tables) and `trend.xlsx`, plus `data/metadata/*.csv` (ProjectTemplate data-dictionary metadata, not app
  data).
- **`munge/`** — the entire strategy pipeline (see execution order above). This is where almost all real logic
  lives; `data/` and `munge/` together are effectively "the app."
- **`QuantStrat/`** — exploratory/diagnostic `quantstrat` scripts (Luxor example strategy, walk-forward analysis
  in `WFA.R`, buy/hold variants). Not part of the automated `load.project()` pipeline; run individually for
  strategy R&D.
- **`src/`** — standalone analysis `.rmd` notebooks (CAPM, Fama-French, Monte Carlo, Sharpe/Sortino ratios,
  volatility, portfolio growth, etc.), each starting with its own `library('ProjectTemplate'); load.project()`
  call. Independent of the main dashboard.
- **`SPL-Dashboard/`** — the `flexdashboard`/Shiny app (`FlexDashboard.Rmd`) and its own copies of the `.rds`/
  `.rdata` artifacts it reads via `resource_files`. Two sections: **1.0 Performance** (price history, returns,
  candlestick chart) and **2.0 Trends** (Trend Summary, Golden Cross, Death Cross, No Cross sub-tabs, each with
  its own visual boxes, price/transaction/position/P&L chart, results table, and return/trade-day distribution
  plots — see `README.md` for the exact field list per table).
- **`rds/`, `rdata/`** (repo root) — canonical persisted backtest outputs, produced by `munge/99-SaveRDS.R`.
- **`reports/`, `graphs/`, `logs/`, `diagnostics/`, `profiling/`, `history/`, `cache/`** — generated/output
  directories, not source.
- **`config/global.dcf`** — ProjectTemplate config: declares the full library allowlist loaded by
  `load.project()` (quantstrat/blotter/FinancialInstrument/TTR/quantmod for the strategy engine; shiny/
  flexdashboard/shinydashboard/plotly/dygraphs/DT for the UI; data.table/tibble/dplyr-adjacent tooling), sets
  `tables_type: data_table` (so ProjectTemplate-loaded data frames are `data.table`s, not `data.frame`s), and
  turns on `logging`/`munging`/`recursive_loading`.

## Conventions specific to this codebase

- Strategy/trend naming follows a `<indicator><Cross><MAtype>` pattern seen throughout `munge/`, `rds/`, and
  `SPL-Dashboard/rds/`: `d`=DeathX, `g`=GoldenX, `n`=NoX, combined with `ema`/`sma` (e.g. `dXema`, `gXsma`,
  `nXema`). Trade-stats companions use a `..._trade_stats.rds` suffix.
- `data.table` (not `dplyr`) is the primary tabular idiom in `munge/`; joins are done with `data.table` chaining
  (`dT.a[dT.b, allow.cartesian = TRUE]`) and `setkey`/`setorder`, not `merge()` or `left_join()`.
- Root-level `.RData`/`.rds` files, `.Rhistory`, and `renv/`-tracked state are working artifacts of R sessions in
  this repo, not hand-authored — expect the git status to routinely show these as modified after any R session
  that runs the pipeline.
