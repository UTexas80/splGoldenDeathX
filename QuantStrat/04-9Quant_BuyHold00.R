################################################################################
## 1.01 Import Data
################################################################################
getSymbols(Symbols = symbols, 
           src = "yahoo", 
           from = start_date, 
           to = end_date, 
           adjust = adjustment)
# ------------Replace missing values (NA)       https://tinyurl.com/y5etxh8x ###
SPL.AX <-
        SPL.AX %>%
        na.omit()
################################################################################
## Step 04.9.00 remove objects to allow re-runs                              ###
################################################################################
suppressWarnings(try(rm(list=c("account.buyHold",
                              "portfolio.buyHold"),
                        pos=.blotter)))
## -- remove residuals from previous runs. ----------------------------------###
rm.strat("buyHold")
rm.strat("buyHold")
################################################################################
## Step 04.9.01 initialize portfolio and account                             ###
################################################################################
initPortf(name       <- "buyHold",                   # Portfolio Initialization     ###
          symbols    <- symbols,
          initDate   <- init_date)
# ------------------------------------------------------------------------------
initAcct(name        <- "buyHold",                    # Account Initialization       ###
         portfolios  <-"buyHold",
         initDate    <-init_date,
         initEq      <-init_equity)
################################################################################
## Step 04.9.02: place an entry order                                        ###
################################################################################
addPosLimit("buyHold", "SPL.AX", timestamp=initDate, maxpos=100, minpos=0)

StartDate            <-"2002-01-02"
equity               <- getEndEq("buyHold", start_date)
ClosePrice           <- as.numeric(Cl(SPL.AX[1,4]))
UnitSize             <- as.numeric(trunc(equity/ClosePrice))
addTxn("buyHold", 
      Symbol         <-'SPL.AX',
      TxnDate        <-StartDate,
      TxnPrice       <-ClosePrice,
      TxnQty         <- UnitSize,
      TxnFees        <-0)
################################################################################
## Step 04.9.03: place an exit order                                         ###
################################################################################
LastDate             <- last(time(SPL.AX))
LastPrice            <- as.numeric(Cl(SPL.AX[LastDate,]))
addTxn("buyHold", 
      Symbol         <-'SPL.AX',
      TxnDate        <-LastDate,
      TxnPrice       <-LastPrice,
      TxnQty         <- -UnitSize ,
      TxnFees        <-0) 
################################################################################
## Step 04.9.04: update portfolio and account                                ###
################################################################################
updatePortf(Portfolio<-"buyHold")
updateAcct(name      <-"buyHold")
updateEndEq(Account  <-"buyHold")
addPosLimit("buyHold", 
            "SPL.AX", 
            timestamp<-initDate,
            maxpos   <-100,
             minpos  <-0)
################################################################################
## Step 04.9.05: Apply and Save Strategy                                     ###
################################################################################
cwd          <- getwd()
# buyHold  <- here::here("dashboard/rds/", "buyHold_results.RData")
if( file.exists(buyHold)) {
  load(buyHold)
} else {
  results   <- applyStrategy(buyHold, portfolios = "buyHold")
  updatePortf("buyHold")
  updateAcct("buyHold")
  updateEndEq("buyHold")
  if(checkBlotterUpdate("buyHold", "buyHold", verbose = TRUE)) {
    save(list = "results", file = here::here("dashboard/rds/", "buyHold"))
    setwd("./dashboard/rds/")
    save.strategy("buyHold")
    setwd(cwd)
  }
}
################################################################################
## Step 04.9.06: GoldenX_EMA vs buy-and-hold   https://tinyurl.com/us96c8p   ###
################################################################################
## Compute Trade Statistics------------------------------https://is.gd/SBHCcH---
rets.bh <- PortfReturns(Account="buyHold")
returns <- cbind(rets,rets.bh)
colnames(returns) <- c("GoldenX_EMA","BuyHold")
# ------------------------------------------------------------------------------
charts.PerformanceSummary(returns, geometric=FALSE, wealth.index=TRUE)
# -Return and risk comparision--------------------------------------------------
table.AnnualizedReturns(returns)
chart.RiskReturnScatter(returns, 
      Rf = 0, 
      add.sharpe = c(1, 2), 
      xlim=c(0,0.25), 
      main = "Return versus Risk", 
      colorset = c("red","blue"))
# -Return stats and relative 
chart.RelativePerformance(returns[,1],returns[,2], 
      colorset = c("red","blue"), 
      lwd = 2, legend.loc = "topleft")
# pts <- perTradeStats("goldenX_EMA_portfolio", "SPL.AX")
# tstats <- tradeStats("goldenX_EMA_portfolio", "SPL.AX")
# # trade related 
# tab.trades <- cbind(
#           c(
#             "Trades",
#             "Win Percent",
#             "Loss Percent",
#             "W/L Ratio"), 
#           c(tstats[,"Num.Trades"],
#             tstats[,c("Percent.Positive","Percent.Negative")], 
#             tstats[,"Percent.Positive"]/
#             tstats[,"Percent.Negative"]))
# # profit related 
# tab.profit <- cbind(
#           c("Net Profit",
#             "Gross Profits",
#             "Gross Losses",
#             "Profit Factor"),
#           c(tstats[,c("Net.Trading.PL",
#                       "Gross.Profits",
#                       "Gross.Losses", 
#                       "Profit.Factor")]))
# # averages 
# tab.wins <- cbind(
#           c("Avg Trade",
#             "Avg Win",
#             "Avg Loss",
#             "Avg W/L Ratio"),
#           c(tstats[,c("Avg.Trade.PL",
#                       "Avg.Win.Trade",
#                       "Avg.Losing.Trade", 
#                       "Avg.WinLoss.Ratio")]))
# trade.stats.tab <- data.table(tab.trades,tab.profit,tab.wins)
# ################################################################################
# ## Step 04.09: Generate Performance Analytics  https://tinyurl.com/us96c8p   ###
# ################################################################################
# rets <- PortfReturns(Account=b.strategy)
# rownames(rets) <- NULL
# # Compute performance statistics -----------------------------------------------
# tab.perf <- table.Arbitrary(rets, 
#   metrics=c("Return.cumulative", 
#             "Return.annualized",
#             "SharpeRatio.annualized",
#             "CalmarRatio"),
#   metricsNames=c(
#             "Cumulative Return",
#             "Annualized Return",
#             "Annualized Sharpe Ratio",
#             "Calmar Ratio"))
# # Compute risk statistics ------------------------------------------------------
# tab.risk <- table.Arbitrary(rets,
#   metrics=c("StdDev.annualized", 
#             "maxDrawdown", 
#             "VaR", 
#             "ES"),
#   metricsNames=c(
#             "Annualized StdDev", 
#             "Max DrawDown", 
#             "Value-at-Risk", 
#             "Conditional VaR"))
# performance.stats.tab <- data.table(
#   rownames(tab.perf),tab.perf[,1], 
#   rownames(tab.risk),tab.risk[,1])            
################################################################################
## Step 04.99: VERSION HISTORY                                               ###
################################################################################
a04.version = "1.0.0"
a04.ModDate = as.Date("2019-12-03")
################################################################################
# 2019.12.03 - v.1.0.0
#  1st release
################################################################################
