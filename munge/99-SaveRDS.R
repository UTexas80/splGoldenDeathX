################################################################################
## Step 99.01 Statistics                                                     ###
################################################################################
saveRDS(dXema_trade_stats,         file  = here::here("dashboard/rds/", "dXema_trade_stats.rds"))
saveRDS(dXsma_trade_stats,         file  = here::here("dashboard/rds/", "dXsma_trade_stats.rds"))
# ------------------------------------------------------------------------------
saveRDS(gXema_trade_stats,         file  = here::here("dashboard/rds/", "gXema_trade_stats.rds"))
saveRDS(gXsma_trade_stats,         file  = here::here("dashboard/rds/", "gXsma_trade_stats.rds"))
# ------------------------------------------------------------------------------
saveRDS(dt_trade_stats,            file  = here::here("dashboard/rds/", "dt_trade_stats.rds"))
################################################################################
## Step 99.02 Save .rds files                                                ###
################################################################################
saveRDS(a,                         file  = here::here("dashboard/rds/", "trendReturns.rds"))
saveRDS(calendarDays,              file  = here::here("dashboard/rds/", "calendarDays.rds"))
saveRDS(dtEMA,                     file  = here::here("dashboard/rds/", "dtEMA.rds"))
saveRDS(goldenEMA,                 file  = here::here("dashboard/rds/", "golden.rds"))
# ------------------------------------------------------------------------------
saveRDS(spl_month_close,           file  = here::here("dashboard/rds/", "spl_month_close.rds"))
saveRDS(SPL.AX.yearly,             file  = here::here("dashboard/rds/", "spl_yearly.rds"))
saveRDS(tradeDays,                 file  = here::here("dashboard/rds/", "tradeDays.rds"))
# ------------------------------------------------------------------------------
saveRDS(trend,                     file  = here::here("dashboard/rds/", "trend.rds"))
# saveRDS(trendClose,              file   = here::here("dashboard/rds/", "trendClose.rds"))
saveRDS(trendDrawEMA,              file  = here::here("dashboard/rds/", "trendDraw.rds"))
saveRDS(trendReturns,              file  = here::here("dashboard/rds/", "trendReturns.rds"))
saveRDS(trendReturnsAnnualized,    file  = here::here("dashboard/rds/", "trendReturnsAnnualized.rds"))
saveRDS(trendReturnsDaily,         file  = here::here("dashboard/rds/", "trendReturnsDaily.rds"))
saveRDS(trendReturnsEMAlong,       file  = here::here("dashboard/rds/", "trendReturnsEMAlong.rds"))
saveRDS(trendReturnsSMA,           file  = here::here("dashboard/rds/", "trendReturnsSMA.rds"))
saveRDS(trendReturnsSMAlong,       file  = here::here("dashboard/rds/", "trendReturnsSMAlong.rds"))
saveRDS(trendSummaryEMA,           file  = here::here("dashboard/rds/", "trendSummaryEMA.rds"))
saveRDS(trendSummaryGroup,         file  = here::here("dashboard/rds/", "trendSummaryGroup.rds"))
saveRDS(emaPct,                    file  = here::here("dashboard/rds/", "emaPct.rds"))
saveRDS(smaPct,                    file  = here::here("dashboard/rds/", "smaPct.rds"))
# ------------------------------------------------------------------------------
# saveRDS(buyHold_results,         file        = here::here("dashboard/rds", "buyHold_results.rds"))
# saveRDS(results,                 file        = here::here("dashboard/rds", "goldenX_EMA_results.rds"))
# ------------------------------------------------------------------------------
# saveRDS(viz.BoxplotN,            file        = here::here("dashboard/rds/", "viz.BoxplotN.rds"))
saveRDS(xtsEMA[complete.cases(xtsEMA), ], file = here::here("dashboard/rds/", "xtsEMA.rds"))
################################################################################
## Step 99.03 Copy .RData strategy files                                     ###
################################################################################
file.copy(here::here("basic_strat.RData"),here::here("dashboard/rdata/", "basic_strat.RData"))
file.copy(here::here("buyhold_strat.RData"),here::here("dashboard/rdata/", "buyhold_strat.RData"))
################################################################################
## Step 99.04 Remove original .RData strategy files from the route           ###
################################################################################
file.remove(here::here("basic_strat.RData"))
file.remove(here::here("buyhold_strat.RData"))
################################################################################
## Step 99.99: VERSION HISTORY                                               ###
################################################################################
a99.version         <- "1.0.0"
a99.ModDate         <- as.Date("2019-01-01")
# ------------------------------------------------------------------------------
# 2019.06.09 - v.1.0.0
# 1st release
