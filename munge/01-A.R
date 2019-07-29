# Example processing script.

SPL.AX.monthly <- SPL.AX[endpoints(SPL.AX, on ="months")]
spl_month_close <- SPL.AX.monthly[,4]
saveRDS(spl_month_close, file="./rds/spl_month_close.rds")

tRet<-periodReturn(SPL.AX,period='yearly')
SPL.AX.yearly<-data.table(date=index(tRet), coredata(tRet))
saveRDS(SPL.AX.yearly, file="./rds/spl_yearly.rds")

charts.PerformanceSummary(
    ROC(SPL.AX.monthly[,4], n = 1, type = "discrete"),
    main = "SPL Performance Summary"
)

plot_ly(SPL.AX.yearly, x = ~date, y = ~yearly.returns, type = 'bar', name = 'Returns by Year')

################################################################################
## Step 1: Falkulate the Cumulative Percentage Return (IDT) ###
################################################################################
cumPctRet<-percent(1+(as.numeric(xts::last(SPL.AX[,4]))-as.numeric(xts::first(SPL.AX[,4]))) / as.numeric(xts::first(SPL.AX[,4])))
yrRet <- na.omit(allReturns(SPL.AX[,4])[,5])


calendarDays <- end(SPL.AX)-start(SPL.AX)
saveRDS(calendarDays, file="./rds/calendarDays.rds")

tradeDays <- ndays(SPL.AX)
saveRDS(tradeDays, file="./rds/tradeDays.rds")


# VERSION HISTORY
a01.version = "1.0.0"
a01.ModDate = as.Date("2019-06-09")

# 2019.06.19 - v.1.0.0
#  1st release