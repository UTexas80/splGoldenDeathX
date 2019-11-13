################################################################################
## Step 1.00.a: Trend Returns                                                ###
################################################################################
# a<-t(data.table((as.single(lapply(lapply(xtsPrice,  na.omit, xtsPrice[1,]), tail, 1))-as.single(lapply(lapply(xtsPrice,  na.omit, xtsPrice[1,]), head, 1))) / as.single(lapply(lapply(xtsPrice,  na.omit, xtsPrice[1,]), head, 1))))
trendReturns <- t(data.table((as.single(lapply(lapply(xtsPrice, na.omit, 
  xtsPrice[1, ]), tail, 1)) - as.single(lapply(lapply(xtsPrice, 
  na.omit, xtsPrice[1, ]), head, 1)))/as.single(lapply(lapply(xtsPrice, 
  na.omit, xtsPrice[1, ]), head, 1))))
# ------------------------------------------------------------------------------  
colnames(trendReturns) <- dimnames(xtsPrice)[[2]]
rownames(trendReturns) <- 1
# ------------------------------------------------------------------------------  
trendReturnsEMAlong <- data.table(melt(trendReturns)[,-1])
names(trendReturnsEMAlong)[c(1:2)] <- c("trend", "returns")
# ------------------------------------------------------------------------------  
trendReturnsSMA <- t(data.table((as.single(lapply(lapply(xtsPriceSMA, na.omit, 
  xtsPriceSMA[1, ]), tail, 1)) - as.single(lapply(lapply(xtsPriceSMA, 
  na.omit, xtsPriceSMA[1, ]), head, 1)))/as.single(lapply(lapply(xtsPriceSMA, 
  na.omit, xtsPriceSMA[1, ]), head, 1))))
# ------------------------------------------------------------------------------  
colnames(trendReturnsSMA) <- dimnames(xtsPriceSMA)[[2]]
rownames(trendReturnsSMA) <- 1
# ------------------------------------------------------------------------------  
trendReturnsSMAlong <- data.table(melt(trendReturnsSMA)[,-1])
names(trendReturnsSMAlong)[c(1:2)] <- c("trend", "returns")
################################################################################
## Step 1.01: Monthly Returns                                                ###
################################################################################
SPL.AX.monthly <- SPL.AX[endpoints(SPL.AX, on = "months")]
spl_month_close <- SPL.AX.monthly[, 4]
# ------------------------------------------------------------------------------
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
# 1.02.a      viz Yearly Returns
plot_ly(SPL.AX.yearly, x = ~date, y = ~yearly.returns, type = "bar", 
  name = "Returns by Year")
################################################################################
## Step 1.03: Falkulate the Cumulative Percentage Return (IDT)               ###
################################################################################
cumPctRet <- percent(1 + (as.numeric(xts::last(SPL.AX[, 4])) - 
  as.numeric(xts::first(SPL.AX[, 4])))/as.numeric(xts::first(SPL.AX[, 
  4])))
yrRet <- na.omit(allReturns(SPL.AX[, 4])[, 5])


dtTrend <- dtSPL[dtGoldenX, nomatch = 0]
################################################################################
## Step 1.04: Falkulate calendar & trade days                                ###
## save .rds
################################################################################
calendarDays <- end(SPL.AX) - start(SPL.AX)
tradeDays <- ndays(SPL.AX)
################################################################################
## Step 00.99: VERSION HISTORY                                               ###
################################################################################
a00.version <- "1.0.0"
a00.ModDate <- as.Date("2019-01-01")
# ------------------------------------------------------------------------------
# 2019.06.19 - v.1.0.0
#  1st release
