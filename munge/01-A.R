
################################################################################
## Step 1.00.a: Trend Returns                                                ###
################################################################################
# a<-t(data.table((as.single(lapply(lapply(xtsPrice,  na.omit, xtsPrice[1,]), tail, 1))-as.single(lapply(lapply(xtsPrice,  na.omit, xtsPrice[1,]), head, 1))) / as.single(lapply(lapply(xtsPrice,  na.omit, xtsPrice[1,]), head, 1))))

trendReturns <- t(data.table((as.single(lapply(lapply(
  xtsPrice, na.omit,
  xtsPrice[1, ]
), tail, 1)) - as.single(lapply(lapply(
  xtsPrice,
  na.omit, xtsPrice[1, ]
), head, 1))) / as.single(lapply(lapply(
  xtsPrice,
  na.omit, xtsPrice[1, ]
), head, 1))))

colnames(trendReturns) <- dimnames(xtsPrice)[[2]]
rownames(trendReturns) <- 1
################################################################################
## Steop 1.00.b Save a table of trend returns .rds file                      ###
################################################################################
saveRDS(a, file = "./rds/trendReturns.rds")
################################################################################
## Step 1.01: Monthly Returns                                                ###
################################################################################
SPL.AX.monthly <- SPL.AX[endpoints(SPL.AX, on = "months")]
spl_month_close <- SPL.AX.monthly[, 4]
saveRDS(spl_month_close, file = "./rds/spl_month_close.rds")
# 1.01.a      viz Performance Summary by Month
charts.PerformanceSummary(
  ROC(SPL.AX.monthly[, 4], n = 1, type = "discrete"),
  main = "SPL Performance Summary by Month"
)
################################################################################
## Step 1.02: Yearly Returns                                                 ###
################################################################################
tRet <- periodReturn(SPL.AX, period = "yearly")
SPL.AX.yearly <- data.table(date = index(tRet), coredata(tRet))
saveRDS(SPL.AX.yearly, file = "./rds/spl_yearly.rds")
# 1.02.a      viz Yearly Returns
plot_ly(SPL.AX.yearly, x = ~date, y = ~yearly.returns, type = "bar", name = "Returns by Year")
################################################################################
## Step 1.03: Falkulate the Cumulative Percentage Return (IDT)               ###
################################################################################
cumPctRet <- percent(1 + (as.numeric(xts::last(SPL.AX[, 4])) - as.numeric(xts::first(SPL.AX[, 4]))) / as.numeric(xts::first(SPL.AX[, 4])))
yrRet <- na.omit(allReturns(SPL.AX[, 4])[, 5])
################################################################################
## Step 1.04: Falkulate calendar & trade days                                ###
## save .rds
################################################################################
calendarDays <- end(SPL.AX) - start(SPL.AX)
saveRDS(calendarDays, file = "./rds/calendarDays.rds")

tradeDays <- ndays(SPL.AX)
saveRDS(tradeDays, file = "./rds/tradeDays.rds")

# VERSION HISTORY
a01.version <- "1.0.0"
a01.ModDate <- as.Date("2019-06-09")

# 2019.06.19 - v.1.0.0
#  1st release