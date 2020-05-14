
################################################################################
## Step 99.00 trend                                                         ###
################################################################################
l                   <- list(dXema_trend, dXsma_trend, gXema_trend, gXsma_trend)
trend               <- rbindlist(l)
names(trend)[c(1:2,13,27,29)] <- c("startDate",  "endDate", "return", "startOpen",  "endOpen")
trend               <- trend[, c(23,22, 25,1, 27, 2, 29, 9:10, 13, 20:21, 28)]
# ------------------------------------------------------------------------------
trendReturns <- data.table(t(trend[, c(2,9)]))     # https://tinyurl.com/tmmubbh
trendReturns <- setnames(trendReturns, as.character(trendReturns[1,]))[-1,] %>%
                mutate_if(is.character,as.numeric)
################################################################################
## Step 99.01 Save .rds files                                                ###
################################################################################
saveRDS(a,                         file        = here::here("dashboard/rds/", "trendReturns.rds"))
saveRDS(calendarDays,              file        = here::here("dashboard/rds/", "calendarDays.rds"))
saveRDS(dtEMA,                     file        = here::here("dashboard/rds/", "dtEMA.rds"))
saveRDS(goldenEMA,                 file        = here::here("dashboard/rds/", "golden.rds"))
# ------------------------------------------------------------------------------
saveRDS(spl_month_close,           file        = here::here("dashboard/rds/", "spl_month_close.rds"))
saveRDS(SPL.AX.yearly,             file        = here::here("dashboard/rds/", "spl_yearly.rds"))
saveRDS(tradeDays,                 file        = here::here("dashboard/rds/", "tradeDays.rds"))
# ------------------------------------------------------------------------------
saveRDS(trend,                     file        = here::here("dashboard/rds/", "trend.rds"))
# saveRDS(trendClose,                file        = here::here("dashboard/rds/", "trendClose.rds"))
saveRDS(trendDrawEMA,              file        = here::here("dashboard/rds/", "trendDraw.rds"))
saveRDS(trendReturns,              file        = here::here("dashboard/rds/", "trendReturns.rds"))
# saveRDS(trendReturnsAnnualized,    file        = here::here("dashboard/rds/", "trendReturnsAnnualized.rds"))
# saveRDS(trendReturnsDaily,         file        = here::here("dashboard/rds/", "trendReturnsDaily.rds"))
saveRDS(trendReturnsEMAlong,       file        = here::here("dashboard/rds/", "trendReturnsEMAlong.rds"))
saveRDS(trendReturnsSMA,           file        = here::here("dashboard/rds/", "trendReturnsSMA.rds"))
saveRDS(trendReturnsSMAlong,       file        = here::here("dashboard/rds/", "trendReturnsSMAlong.rds"))
saveRDS(trendSummaryEMA,           file        = here::here("dashboard/rds/", "trendSummaryEMA.rds"))
# saveRDS(trendSummaryGroup,         file        = here::here("dashboard/rds/", "trendSummaryGroup.rds"))
# saveRDS(trendEMA,                  file        = here::here("dashboard/rds/", "trendEMA.rds"))
# saveRDS(trendSMA,                  file        = here::here("dashboard/rds/", "trendSMA.rds"))
# ------------------------------------------------------------------------------
# saveRDS(buyHold_results,           file        = here::here("dashboard/rds", "buyHold_results.rds"))
# saveRDS(results,                   file        = here::here("dashboard/rds", "goldenX_EMA_results.rds"))
# ------------------------------------------------------------------------------
# saveRDS(viz.BoxplotN,              file        = here::here("dashboard/rds/", "viz.BoxplotN.rds"))
# saveRDS(xtsEMA[complete.cases(xtsEMA), ], file = here::here("dashboard/rds/", "xtsEMA.rds"))
################################################################################
## Step 99.02 Copy .RData strategy files                                     ###
################################################################################
file.copy(here::here("basic_strat.RData"),here::here("dashboard/rdata/", "basic_strat.RData"))
file.copy(here::here("buyhold_strat.RData"),here::here("dashboard/rdata/", "buyhold_strat.RData"))
################################################################################
## Step 99.03 Remove original .RData strategy files from the route           ###
################################################################################
file.remove(here::here("basic_strat.RData"))
file.remove(here::here("buyhold_strat.RData"))
################################################################################
## Step 00.99: VERSION HISTORY                                               ###
################################################################################
a99.version         <- "1.0.0"
a98.ModDate         <- as.Date("2019-01-01")
# ------------------------------------------------------------------------------
# 2019.06.09 - v.1.0.0
# 1st release
