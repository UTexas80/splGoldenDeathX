################################################################################
## Step 04.9.00 Buy and Hold Strategy                 # https://is.gd/9fss5m ###
################################################################################

################################################################################
## Step 04.9.00 remove objects to allow re-runs                              ###
################################################################################
suppressWarnings(try(rm(list=c("account.buyHold",
                              "portfolio.buyHold"),pos=.blotter)))
## -- remove residuals from previous runs. ----------------------------------###
rm.strat("buyHold")
rm("account.buyHold",pos=.blotter)
rm("portfolio.buyHold",pos=.blotter)
################################################################################
##  Step 1.02 Algorithmic Trading Strategy Setup                             ###
## -----------------------------------------------------------------------------
## Assign names to the portfolio, account and strategy as follows:
## -----------------------------------------------------------------------------
strategy.st  <- "buyHold"
portfolio.st <- "buyHold"
account.st   <- "buyHold"
# ------------------------------------------------------------------------------
# If there are any other portfolios or account book with these names
# remove them using rm.strat function
# ------------------------------------------------------------------------------
rm.strat(strategy.st)
rm.strat(account.st)
rm.strat(portfolio.st)
################################################################################
## Step 04.9.01 Initialize Portfolio, Account and Orders                     ###
################################################################################
## -----------------------------------------------------------------------------
# To start, we initialize account and portfolio where:  ---------------------###
# Porfolio: stores which stocks to be traded            ---------------------###
# Account: stores which money transactions              ---------------------###
## portfolio, account and orders initialization.        ---------------------###
# ------------------------------------------------------------------------------
initPortf(name = "buyHold",                      # Portfolio Initialization  ###
          symbols = symbols,
          initDate = init_date,
          currency = 'AUD')
# ------------------------------------------------------------------------------
initAcct(name = "buyHold",                       # Account Initialization    ###
        portfolios="buyHold",
        initDate=init_date,
        currency = 'AUD',
        initEq = init_equity)
# ------------------------------------------------------------------------------
initOrders(portfolio="buyHold",                  # Order Initialization      ###
           symbols = symbols,
           initDate =  init_date)
# ------------------------------------------------------------------------------
buyHold_strategy <- strategy("buyHold")        # Strategy Initialization     ###
################################################################################
## Step 04.9.02 get the price and timing data                                ###
################################################################################
FirstDate <- first(time(SPL.AX))                # Enter order on the first date#
BuyDate <- FirstDate
equity = getEndEq("buyHold", FirstDate)
FirstPrice <- as.numeric(Cl(SPL.AX[BuyDate,4]))
# ------------------------------------------------------------------------------
UnitSize = as.numeric(trunc(equity/FirstPrice))
# ------------------------------------------------------------------------------
LastDate <- last(time(SPL.AX))                  # Exit order on the Last Date ##
LastPrice <- as.numeric(Cl(SPL.AX[LastDate,4]))
################################################################################
## Step 04.9.03 add buy / sell transactions                                  ###
################################################################################
addTxn(Portfolio = "buyHold",                    # buy transaction           ###
       Symbol = "SPL.AX", 
       TxnDate = BuyDate, 
       TxnQty = UnitSize,
       TxnPrice = FirstPrice,
       TxnFees = 0)
# ------------------------------------------------------------------------------
addTxn(Portfolio = "buyHold",                    # sell transaction          ###
       Symbol = "SPL.AX", 
       TxnDate = LastDate, 
       TxnQty = -UnitSize,
       TxnPrice = LastPrice,
       TxnFees = 0)
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
            minpos   <-0)
################################################################################
## Step 04.9.05: GoldenX_EMA vs buy-and-hold   https://tinyurl.com/us96c8p   ###
################################################################################
## Compute Trade Statistics------------------------------https://is.gd/SBHCcH---
rets_bh  <- PortfReturns(Account="buyHold")
returns  <- cbind(rets,rets_bh)
colnames(returns) <- c("GoldenX_EMA","BuyHold")
# ------------------------------------------------------------------------------
charts.PerformanceSummary(
    returns, geometric=FALSE, 
    wealth.index=TRUE, 
    main = "GoldenX-EMA vs. BuyHold")
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
################################################################################
## Step 04.06: Generate Performance Reports    https://tinyurl.com/us96c8p   ###
################################################################################
## Compute Trade Statistics------------------------------https://is.gd/SBHCcH---
# pts <- perTradeStats("buyHold", "SPL.AX")
tstats <- tradeStats("buyHold", "SPL.AX")
# trade related 
tab.trades <- cbind(
          c(
            "Trades",
            "Win Percent",
            "Loss Percent",
            "W/L Ratio"), 
          c(tstats[,"Num.Trades"],
            tstats[,c("Percent.Positive","Percent.Negative")], 
            tstats[,"Percent.Positive"]/
            tstats[,"Percent.Negative"]))
# profit related 
tab.profit <- cbind(
          c("Net Profit",
            "Gross Profits",
            "Gross Losses",
            "Profit Factor"),
          c(tstats[,c("Net.Trading.PL",
                      "Gross.Profits",
                      "Gross.Losses", 
                      "Profit.Factor")]))
# averages 
tab.wins <- cbind(
          c("Avg Trade",
            "Avg Win",
            "Avg Loss",
            "Avg W/L Ratio"),
          c(tstats[,c("Avg.Trade.PL",
                      "Avg.Win.Trade",
                      "Avg.Losing.Trade", 
                      "Avg.WinLoss.Ratio")]))
trade.stats.tab <- data.table(tab.trades,tab.profit,tab.wins)
################################################################################
## Step 04.07: Generate Performance Analytics  https://tinyurl.com/us96c8p   ###
################################################################################
rets       <- PortfReturns("buyHold")
rownames(rets) <- NULL
# Compute performance statistics -----------------------------------------------
tab.perf <- table.Arbitrary(rets, 
  metrics=c("Return.cumulative", 
            "Return.annualized",
            "SharpeRatio.annualized",
            "CalmarRatio"),
  metricsNames=c(
            "Cumulative Return",
            "Annualized Return",
            "Annualized Sharpe Ratio",
            "Calmar Ratio"))
# Compute risk statistics ------------------------------------------------------
tab.risk <- table.Arbitrary(rets,
  metrics=c("StdDev.annualized", 
            "maxDrawdown", 
            "VaR", 
            "ES"),
  metricsNames=c(
            "Annualized StdDev", 
            "Max DrawDown", 
            "Value-at-Risk", 
            "Conditional VaR"))
performance.stats.tab <- data.table(
  rownames(tab.perf),tab.perf[,1], 
  rownames(tab.risk),tab.risk[,1])
# chart the trading positions: -------------------------------------------------
chart.Posn("buyHold", Symbol = "SPL.AX")
#  trading statistics
# out <- perTradeStats("buyHold", "SPL.AX")
# t(out)
################################################################################
## Step 04.08: Apply and Save Strategy                                       ###
################################################################################
cwd          <- getwd()
buyHold  <- here::here("dashboard/rds", "buyHold_results.RData")
if( file.exists(buyHold)) {
  load(buyHold)
} else {
  buyHold_results   <- applyStrategy(buyHold_strategy, portfolios = "buyHold")
  updatePortf("buyHold")
  updateAcct("buyHold")
  updateEndEq("buyHold")
#  if(checkBlotterUpdate("buyHold", "buyHold", verbose = TRUE)) {
    save(list = "buyHold_results", file = here::here("dashboard/rds", "buyHold"))
    setwd("./dashboard/rds/")
    save.strategy("buyHold_strategy")
    setwd(cwd)
#  }
}
################################################################################
## Step 04.99: VERSION HISTORY                                               ###
################################################################################
a04.version = "1.0.0"
a04.ModDate = as.Date("2019-12-01")
################################################################################
# 2019.12.01 - v.1.0.0
#  1st release
################################################################################
