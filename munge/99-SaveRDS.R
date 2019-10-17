################################################################################
## Step 99.00 Save .rds files                                                ###
################################################################################
saveRDS(a, file                                = "./rds/trendReturns.rds")
saveRDS(calendarDays, file                     = "./rds/calendarDays.rds")
saveRDS(dtEMA, file                            = "./rds/dtEMA.rds")
saveRDS(goldenEMA,file                         = "./rds/golden.rds")
# ------------------------------------------------------------------------------
saveRDS(spl_month_close, file                  = "./rds/spl_month_close.rds")
saveRDS(SPL.AX.yearly, file                    = "./rds/spl_yearly.rds")
saveRDS(tradeDays, file                        = "./rds/tradeDays.rds")
# ------------------------------------------------------------------------------
saveRDS(trend, file                            = "./rds/trend.rds")
saveRDS(trendClose, file                       = "./rds/trendClose.rds")
saveRDS(trendDrawEMA, file                     = "./rds/trendDraw.rds")
saveRDS(trendReturns, file                     = "./rds/trendReturns.rds")
saveRDS(trendReturnsAnnualized, file           = "./rds/trendReturnsAnnualized.rds")
saveRDS(trendReturnsDaily, file                = "./rds/trendReturnsDaily.rds")
saveRDS(trendSummaryEMA, file                  = "./rds/trendSummaryEMA.rds")
saveRDS(trendTest, file                        = "./rds/trendTest.rds")
# ------------------------------------------------------------------------------
saveRDS(viz.BoxplotN, file                     = "./rds/viz.BoxplotN.rds")
saveRDS(xtsEMA[complete.cases(xtsEMA), ], file = "./rds/xtsEMA.rds")
################################################################################
## Step 00.99: VERSION HISTORY                                               ###
################################################################################
a99.version <- "1.0.0"
a98.ModDate <- as.Date("2019-01-01")
# ------------------------------------------------------------------------------
# 2019.06.09 - v.1.0.0
# 1st release
