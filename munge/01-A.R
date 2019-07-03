# Example processing script.

tRet<-periodReturn(SPL.AX,period='yearly')
SPL.AX.yearly<-data.table(date=index(tRet), coredata(tRet))
saveRDS(SPL.AX.yearly, file="spl_yearly.rds")

SPL.AX.monthly <- SPL.AX[endpoints(SPL.AX, on ="months")]
spl_month_close <- data.table(SPL.AX.monthly[,4])
saveRDS(spl_month_close, file="spl_month_close.rds")

viz_bar_returns_by_month <- charts.PerformanceSummary(
    ROC(SPL.AX.monthly[,4], n = 1, type = "discrete"),
    main = "SPL Performance Summary"
)
saveRDS(viz_bar_returns_by_month, file="viz_bar_returns_by_month.rds")

viz_bar_returns_by_yr <- plot_ly(SPL.AX.yearly, x = ~date, y = ~yearly.returns, type = 'bar', name = 'Returns by Year')
saveRDS(viz_bar_returns_by_yr, file="viz_bar_returns_by_yr.rds")

# VERSION HISTORY
a01.version = "1.0.0"
a01.ModDate = as.Date("2019-06-09")

# 2019.06.19 - v.1.0.0
#  1st release