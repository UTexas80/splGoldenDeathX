################################################################################
## Step 99.01 Statistics                                                     ###
################################################################################
FinancialInstrument::currency(c("AUD", "USD"))           # Set the currency  ###
FinancialInstrument::getInstrument("AUD","USD")
# ------------------------------------------------------------------------------
FinancialInstrument::stock(c("SPL.AX"), currency ="AUD") # Define the stocks ###
FinancialInstrument::getInstrument("SPL.AX")
exchange_rate("USDAUD")
saveInstruments("MyInstruments.RData", dir=here::here("SPL-Dashboard/rdata/"))
# ------------------------------------------------------------------------------
saveRDS(dt_bb20_disp,              file  = here::here("rds/", "dt_bb20_disp.rds"))
saveRDS(dt_bb20_disp,              file  = here::here("SPL-Dashboard/rds/", "dt_bb20_disp.rds"))
# ------------------------------------------------------------------------------
saveRDS(xts_bb20_disp,             file  = here::here("rds/", "xts_bb20_disp.rds"))
saveRDS(xts_bb20_disp,             file  = here::here("SPL-Dashboard/rds/", "xts_bb20_disp.rds"))
saveRDS(xts_bb20_disp,             file  = here::here("SPL-Dashboard/", "xts_bb20_disp.rds"))
# ------------------------------------------------------------------------------
saveRDS(getPortfolio("dXema"),     file  = here::here("rds/", "dXema.rds"))
saveRDS(getPortfolio("dXema"),     file  = here::here("SPL-Dashboard/rds/", "dXema.rds"))
# ------------------------------------------------------------------------------
saveRDS(getPortfolio("dXsma"),     file  = here::here("rds/", "dXsma.rds"))
saveRDS(getPortfolio("dXsma"),     file  = here::here("SPL-Dashboard/rds/", "dXsma.rds"))
# ------------------------------------------------------------------------------
saveRDS(getPortfolio("gXema"),     file  = here::here("rds/", "gXema.rds"))
saveRDS(getPortfolio("gXema"),     file  = here::here("SPL-Dashboard/rds/", "gXema.rds"))
# ------------------------------------------------------------------------------
saveRDS(getPortfolio("gXsma"),     file  = here::here("rds/", "gXsma.rds"))
saveRDS(getPortfolio("gXsma"),     file  = here::here("SPL-Dashboard/rds/", "gXsma.rds"))
# ------------------------------------------------------------------------------
saveRDS(getPortfolio("nXema"),     file  = here::here("rds/", "nXema.rds"))
saveRDS(getPortfolio("nXema"),     file  = here::here("SPL-Dashboard/rds/", "nXema.rds"))
# ------------------------------------------------------------------------------
saveRDS(getPortfolio("nXsma"),     file  = here::here("rds/", "nXsma.rds"))
saveRDS(getPortfolio("nXsma"),     file  = here::here("SPL-Dashboard/rds/", "nXsma.rds"))
# ------------------------------------------------------------------------------
saveRDS(dXema_trade_stats,         file  = here::here("rds/", "dXema_trade_stats.rds"))
saveRDS(dXema_trade_stats,         file  = here::here("rds/", "dXema_trade_stats.rds"))
# ------------------------------------------------------------------------------
saveRDS(dXsma_trade_stats,         file  = here::here("rds/", "dXsma_trade_stats.rds"))
# ------------------------------------------------------------------------------
saveRDS(dXema_trade_stats,         file  = here::here("SPL-Dashboard/rds/", "dXema_trade_stats.rds"))
saveRDS(dXema_trade_stats,         file  = here::here("SPL-Dashboard/rds/", "dXema_trade_stats.rds"))
# ------------------------------------------------------------------------------
saveRDS(dXsma_trade_stats,         file  = here::here("SPL-Dashboard/rds/", "dXsma_trade_stats.rds"))
# ------------------------------------------------------------------------------
saveRDS(gXema_trade_stats,         file  = here::here("rds/", "gXema_trade_stats.rds"))
saveRDS(gXsma_trade_stats,         file  = here::here("rds/", "gXsma_trade_stats.rds"))
# ------------------------------------------------------------------------------
saveRDS(gXema_trade_stats,         file  = here::here("SPL-Dashboard/rds/", "gXema_trade_stats.rds"))
saveRDS(gXsma_trade_stats,         file  = here::here("SPL-Dashboard/rds/", "gXsma_trade_stats.rds"))
# ------------------------------------------------------------------------------
saveRDS(dt_trade_stats,            file  = here::here("rds/", "dt_trade_stats.rds"))
saveRDS(dt_trade_stats,            file  = here::here("SPL-Dashboard/rds/", "dt_trade_stats.rds"))
################################################################################
## Step 99.02 Save .rda files                                                ###
################################################################################
save(SPL.AX, file  = here::here("SPL.AX/", "SPL.AX.rda"))
save(SPL.AX, file  = here::here("SPL-Dashboard/SPL.AX/", "SPL.AX.rda"))
################################################################################
## Step 99.02 Save .rds files                                                ###
################################################################################
save(SPL.AX, file  = here::here("SPL.AX/", "SPL.AX.rda"))
save(SPL.AX, file  = here::here("SPL-Dashboard/SPL.AX/", "SPL.AX.rda"))
# ------------------------------------------------------------------------------
saveRDS(SPL.AX,                    file  = here::here("rds/", "SPL.AX.rds"))
saveRDS(SPL.AX,                    file  = here::here("SPL-Dashboard/rds/", "SPL.AX.rds"))
# ------------------------------------------------------------------------------
saveRDS(a,                         file  = here::here("SPL-Dashboard/rds/", "trendReturns.rds"))
saveRDS(calendarDays,              file  = here::here("rds/", "calendarDays.rds"))
saveRDS(calendarDays,              file  = here::here("SPL-Dashboard/rds/", "calendarDays.rds"))
saveRDS(dtEMA,                     file  = here::here("SPL-Dashboard/rds/", "dtEMA.rds"))
saveRDS(goldenEMA,                 file  = here::here("SPL-Dashboard/rds/", "golden.rds"))
# ------------------------------------------------------------------------------
saveRDS(goldenEMA,                 file  = here::here("rds/", "golden.rds"))
# ------------------------------------------------------------------------------
saveRDS(spl_month_close,           file  = here::here("SPL-Dashboard/rds/", "spl_month_close.rds"))
saveRDS(SPL.AX.yearly,             file  = here::here("SPL-Dashboard/rds/", "spl_yearly.rds"))
# ------------------------------------------------------------------------------
saveRDS(tradeDays,                 file  = here::here("rds/", "tradeDays.rds"))
saveRDS(tradeDays,                 file  = here::here("SPL-Dashboard/rds/", "tradeDays.rds"))
# ------------------------------------------------------------------------------
saveRDS(trend,                     file  = here::here("rds/", "trend.rds"))
# ------------------------------------------------------------------------------
saveRDS(trend,                     file  = here::here("SPL-Dashboard/", "trend.rds"))
saveRDS(trend,                     file  = here::here("SPL-Dashboard/rds/", "trend.rds"))
# ------------------------------------------------------------------------------
saveRDS(trendClose,                file   = here::here("SPL-Dashboard/rds/", "trendClose.rds"))
saveRDS(trendDrawEMA,              file  = here::here("rds/", "trendDraw.rds"))
saveRDS(trendDrawEMA,              file  = here::here("SPL-Dashboard/rds/", "trendDraw.rds"))
# ------------------------------------------------------------------------------
saveRDS(trendReturns,              file  = here::here("rds/", "trendReturns.rds"))
saveRDS(trendReturns,              file  = here::here("SPL-Dashboard/rds/", "trendReturns.rds"))
# ------------------------------------------------------------------------------
saveRDS(trendReturnsAnnualized,    file  = here::here("rds/", "trendReturnsAnnualized.rds"))
saveRDS(trendReturnsAnnualized,    file  = here::here("SPL-Dashboard/rds/", "trendReturnsAnnualized.rds"))
# ------------------------------------------------------------------------------
saveRDS(trendReturnsDaily,         file  = here::here("rds/", "trendReturnsDaily.rds"))
saveRDS(trendReturnsDaily,         file  = here::here("SPL-Dashboard/rds/", "trendReturnsDaily.rds"))
# ------------------------------------------------------------------------------
saveRDS(trendReturnsEMAlong,       file  = here::here("rds/", "trendReturnsEMAlong.rds"))
saveRDS(trendReturnsEMAlong,       file  = here::here("SPL-Dashboard/rds/", "trendReturnsEMAlong.rds"))
# ------------------------------------------------------------------------------
saveRDS(trendReturnsSMA,           file  = here::here("rds/", "trendReturnsSMA.rds"))
saveRDS(trendReturnsSMA,           file  = here::here("SPL-Dashboard/rds/", "trendReturnsSMA.rds"))
# ------------------------------------------------------------------------------
saveRDS(trendReturnsSMAlong,       file  = here::here("rds/", "trendReturnsSMAlong.rds"))
saveRDS(trendReturnsSMAlong,       file  = here::here("SPL-Dashboard/rds/", "trendReturnsSMAlong.rds"))
# ------------------------------------------------------------------------------
saveRDS(trendSummaryEMA,           file  = here::here("SPL-Dashboard/rds/", "trendSummaryEMA.rds"))
# ------------------------------------------------------------------------------
saveRDS(trendSummaryGroup,         file  = here::here("rds/", "trendSummaryGroup.rds"))
saveRDS(trendSummaryGroup,         file  = here::here("SPL-Dashboard/rds/", "trendSummaryGroup.rds"))
# ------------------------------------------------------------------------------
saveRDS(emaPct,                    file  = here::here("rds/", "emaPct.rds"))
saveRDS(emaPct,                    file  = here::here("SPL-Dashboard/rds/", "emaPct.rds"))
# ------------------------------------------------------------------------------
saveRDS(smaPct,                    file  = here::here("rds/", "smaPct.rds"))
saveRDS(smaPct,                    file  = here::here("SPL-Dashboard/rds/", "smaPct.rds"))
# ------------------------------------------------------------------------------
# saveRDS(buyHold_results,         file        = here::here("SPL-Dashboard/rds", "buyHold_results.rds"))
# saveRDS(results,                 file        = here::here("SPL-Dashboard/rds", "goldenX_EMA_results.rds"))
# ------------------------------------------------------------------------------
# saveRDS(viz.BoxplotN,            file        = here::here("SPL-Dashboard/rds/", "viz.BoxplotN.rds"))
saveRDS(xtsEMA[complete.cases(xtsEMA), ], file = here::here("rds/", "xtsEMA.rds"))
saveRDS(xtsEMA[complete.cases(xtsEMA), ], file = here::here("SPL-Dashboard/rds/", "xtsEMA.rds"))
################################################################################
## Step 99.03 Copy .RData strategy files                                     ###
################################################################################
file.copy(here::here("basic_strat.RData"),here::here("SPL-Dashboard/rdata/", "basic_strat.RData"))
# file.copy(here::here("buyhold_strat.RData"),here::here("SPL-Dashboard/rdata/", "buyhold_strat.RData"))
file.copy(here::here("gXema.RData"),here::here("SPL-Dashboard/rdata/", "gXema.RData"))
################################################################################
## Step 99.04 Remove original .RData strategy files from the route           ###
################################################################################
# file.remove(here::here("basic_strat.RData"))
# file.remove(here::here("buyhold_strat.RData"))
################################################################################
## Step 99.99: VERSION HISTORY                                               ###
################################################################################
a99.version         <- "1.0.0"
a99.ModDate         <- as.Date("2019-01-01")
# ------------------------------------------------------------------------------
# 2019.06.09 - v.1.0.0
# 1st release
