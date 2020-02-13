################################################################################
# 0.0  Initialization
################################################################################
library(quantstrat)
library(quantmod)
# ------------------------------------------------------------------------------
initdate = "1999-01-01"
from = "2003-01-01"
to = "2015-12-31"
# ------------------------------------------------------------------------------
currency ("USD")
stock("SPL.AX", currency = "AUD")
Sys.setenv (TZ = "UTC")
# ------------------------------------------------------------------------------
getSymbols(
  Symbols = symbols,
  from = from,
  to = to,
  src = "yahoo",
  adjust = TRUE,
  index.class = "POSIXct",c("POSIXt","POSIXct"))
# ------------------------------------------------------------------------------  
curr <- 'AUD'
tradesize <- 100000
initeq <- 100000  
################################################################################
# 1.0 Setup
################################################################################
strategy.st <- portfolio.st <- account.st <- dXsma
rm.strat(strategy.st)
rm.strat(account.st)
rm.strat(portfolio.st)
################################################################################
# 2.0	Initialization
################################################################################
initPortf(name              = portfolio.st,         # Portfolio Initialization
    symbols                 = symbols,
    currency                = curr,
    initDate                = initdate,
    initEq                  = initeq)
# ------------------------------------------------------------------------------
initAcct(name               = account.st,           # Account Initialization
    portfolios              = portfolio.st,
    currency                = curr,
    initDate                = initdate,
    initEq                  = initeq)
# ------------------------------------------------------------------------------
initOrders(portfolio        = portfolio.st,         # Order Initialization
    symbols                 = symbols,
    initDate                = initdate)
# ------------------------------------------------------------------------------
strategy(strategy.st, store = TRUE)                 # Strategy initialization
################################################################################
# 3.0	Indicators
################################################################################
add.indicator(strategy.st,                          # 20-day SMA indicator
    name                    = "SMA", 
    arguments               = list(
      x                     = quote(mktdata[,4]), 
      n                     = 20), 
    label                   = "020")
# ------------------------------------------------------------------------------
add.indicator(strategy.st,                          # 50-day SMA indicator
    name                    = "SMA", 
    arguments               = list(
      x                     = quote(mktdata[,4]), 
      n                     = 50), 
    label                   = "050")
# ------------------------------------------------------------------------------
add.indicator(strategy.st,                          # 100-day SMA indicator
    name                    = "SMA", 
    arguments               = list(
      x                     = quote(mktdata[,4]), 
      n                     = 100), 
    label                   = "100")
# ------------------------------------------------------------------------------
add.indicator(strategy.st,                          # 200-day SMA indicator
    name                    = "SMA", 
    arguments               = list(
      x                     = quote(mktdata[,4]), 
      n                     = 200), 
    label                   = "200")
# ------------------------------------------------------------------------------
# dXsma_mktdata_ind <-  applyIndicators(               # apply indicators
#     strategy                = strategy.st,
#     mktdata                 = SPL.AX)
################################################################################
# 4.0	Signals
################################################################################
add.signal(strategy.st,
    name                    = "sigFormula",
    arguments               = list(
        columns            = c("SMA.020","SMA.050","SMA.100", "SMA.200"),
        formula            = "(SMA.020 < SMA.050 &
                               SMA.050 < SMA.100 &
                               SMA.100 < SMA.200)",
         label              = "trigger",
         cross              = TRUE),
    label                   = "dXsma_shortEntry")
# ------------------------------------------------------------------------------
add.signal(strategy.st,
    name                    = "sigFormula",
    arguments               = list
        (columns           = c("SMA.020","SMA.050","SMA.100", "SMA.200"),
        formula            = "(SMA.020 > SMA.050 |
                               SMA.050 > SMA.100 |
                               SMA.100 > SMA.200) & 
                               index.xts(mktdata) > '2002-12-02'",
         label              = "trigger",
         cross              = TRUE),
    label                   = "dXsma_shortExit")
# ------------------------------------------------------------------------------
# dXsma_mktdata_sig  <- applySignals(
#     strategy                = strategy.st,
#     mktdata                 = dXsma_mktdata_ind)
################################################################################
# 5.0	Rules
################################################################################
 add.rule(strategy.st,
    name                    = "ruleSignal",
    arguments               = list(
        sigcol              = "dXsma_shortEntry",
        sigval              = TRUE,
        orderqty            = 1000,
        ordertype           = "market",
        orderside           = "short",
        prefer              = "Open",
        pricemethod         = "market",
        TxnFees             = 0,
        osFUN               = osMaxPos),
    type                    = "enter",
    path.dep                = TRUE)
# ------------------------------------------------------------------------------
add.rule(strategy.st,
    name                    = "ruleSignal",
    arguments               = list(
        sigcol              = "dXsma_shortExit",
        sigval              = TRUE,
        orderqty            = "all",
        ordertype           = "market",
        orderside           = "short",
        prefer              = "Open",
        pricemethod         = "market",
        TxnFees             = 0),
    type                    = "exit",
    path.dep                = TRUE)
################################################################################
# 6.0	Position Limits
################################################################################
#addPosLimit(portfolio.st, symbols, 
#    timestamp               <- initdate, 
#    maxpos                  <- 100,
#    minpos                  <- 0)
################################################################################
# 7.0	Strategy
################################################################################
# browser()
t1      <- Sys.time()
applyStrategy(strategy.st, portfolio.st)
t2      <- Sys.time()
print(t2 - t1)
# ------------------------------------------------------------------------------
updatePortf(portfolio.st)
daterange <- time(getPortfolio(portfolio.st)$summary)[-1]
updateAcct(account.st, daterange)
updateEndEq(account.st)
# ------------------------------------------------------------------------------
tradeStats(Portfolios = portfolio.st)
