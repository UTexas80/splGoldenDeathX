################################################################################
# 1.0 Setup
################################################################################
# browser()
from = "2003-01-01"
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
    initDate                = initDate,
    initEq                  = initEq)
# ------------------------------------------------------------------------------
initAcct(name               = account.st,           # Account Initialization
    portfolios              = portfolio.st,
    currency                = curr,
    initDate                = initDate,
    initEq                  = initEq)
# ------------------------------------------------------------------------------
initOrders(portfolio        = portfolio.st,         # Order Initialization
    symbols                 = symbols,
    initDate                = initDate)
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

dXsma_mktdata_ind <-  applyIndicators(              # apply indicators
    strategy                = strategy.st,
    mktdata                 = SPL.AX)
################################################################################
# 4.0	Signals
################################################################################
add.signal(strategy.st,
    name                    = "sigFormula",
    arguments               = list(
        columns             = c("SMA.020","SMA.050","SMA.100", "SMA.200"),
        formula             = "(SMA.020 < SMA.050 &
                                SMA.050 < SMA.100 &
                                SMA.100 < SMA.200)",
         label              = "trigger",
         cross              = TRUE),
    label                   = "dXsma_shortEntry")
# ------------------------------------------------------------------------------
add.signal(strategy.st,
    name                    = "sigFormula",
    arguments               = list
        (columns            = c("SMA.020","SMA.050","SMA.100", "SMA.200"),
        formula             = "(SMA.020 > SMA.050  |
                                SMA.050 > SMA.100  |
                                SMA.100 > SMA.200) &
                               index.xts(mktdata)  > '2002-12-02'",
         label              = "trigger",
         cross              = TRUE),
    label                   = "dXsma_shortExit")
# ------------------------------------------------------------------------------
dXsma_mktdata_sig  <- applySignals(
    strategy                = strategy.st,
    mktdata                 = dXsma_mktdata_ind)
applySignals(strategy.st, mktdata)
################################################################################
# 5.0	Rules
################################################################################
add.rule(strategy.st,
    name                    = "ruleSignal",
    arguments               = list(
        sigcol              = "dXsma_shortEntry",
        sigval              = TRUE,
        orderqty            = -1000,
        orderside           = "short",
        ordertype           = "market",
        prefer              = "Open",
        pricemethod         = "market",
        TxnFees             = 0),
  #      osFUN               = osMaxPos),
    type                    = "enter",
    path.dep                = TRUE)
# ------------------------------------------------------------------------------
add.rule(strategy.st,
    name                    = "ruleSignal",
    arguments               = list(
        sigcol              = "dXsma_shortExit",
        sigval              = TRUE,
        orderqty            = "all",
        orderside           = "short",
        ordertype           = "market",
        prefer              = "Open",
        pricemethod         = "market",
        TxnFees             = 0),
    type                    = "exit",
    path.dep                = TRUE)
################################################################################
# 6.0	Position Limits
################################################################################
addPosLimit(portfolio.st, symbols, 
    timestamp               <- from, 
    maxpos                  <- 100,
    minpos                  <- 0)
################################################################################
# 7.0	Strategy
################################################################################
# browser()
t1      <- Sys.time()
results <- applyStrategy(strategy.st, portfolio.st, mktdata, symbols)
t2      <- Sys.time()
print(t2 - t1)
# ------------------------------------------------------------------------------
# cwd             <- getwd()
# dXsma_results   <- here::here("dashboard/rds", "dXsma_results.RData")
# # ------------------------------------------------------------------------------
# if(file.exists(dXsma_results)) {
#   base::load(dXsma_results)
# } else {
#     dXsma_strategy <- applyStrategy(strategy.st, portfolio.st)

#     if(checkBlotterUpdate(portfolio.st, account.st, verbose = TRUE)) {

#       save(
#         list = "dXsma_strategy", 
#         file = here::here("dashboard/rds/", paste0(dXsma, "_", "results.RData")))

#     setwd("./dashboard/rds")
#     save.strategy(strategy.st)
# #   save.strategy(paste0(strategy.st, "_", "strategy"))
#     setwd(cwd)

#     }
#   }
# ------------------------------------------------------------------------------
# t2 <- Sys.time()
# print(t2 - t1)
################################################################################
# 9.0	Evaluation - update P&L and generate transactional history
################################################################################
# Set up analytics. Update portfolio, account and equity
updatePortf(portfolio.st)
dateRange  <- time(getPortfolio(portfolio.st)$summary)[-1]
#updateAcct(account.st, dateRange)
updateAcct(account.st)
updateEndEq(account.st)
save.strategy(strategy.st)
# ------------------------------------------------------------------------------
dXsma_pts <- blotter::perTradeStats(portfolio.st, symbols)
# ------------------------------------------------------------------------------
dXsma_stats <- data.table(tradeStats(portfolio.st, use = "trades", inclZeroDays = FALSE))
dXsma_stats[, 4:ncol(dXsma_stats)] <- round(dXsma_stats[, 4:ncol(dXsma_stats)], 2)
dXsma_stats <- dXsma_stats[, data.table(t(.SD), keep.rownames = TRUE)]
################################################################################
# 8.0	Trend - create dashboard dataset
################################################################################
dXsma_trend <- data.table(dXsma_pts)
dXsma_trend[, `:=`(tradeDays, lapply(paste0(dXsma_pts[, 1], "/", dXsma_pts[, 2]), 
  function(x) length(SPL.AX[, 6][x])+1))]
dXsma_trend[, calendarDays := as.numeric(duration/86400)]
# ------------------------------------------------------------------------------
dXsma_trend[, c("catName","indicator"):=list("DeathX", "EMA")]
dXsma_trend[, grp := .GRP, by=Start] 
dXsma_trend[, subcatName := paste0(catName, paste0(sprintf("%03d", grp)))]
# ------------------------------------------------------------------------------
dXsma_trend[, `:=`(tradeDays, lapply(paste0(dXsma_pts[, 1], "/", dXsma_pts[, 2]), 
  function(x) length(SPL.AX[, 6][x])+1))][
, calendarDays := as.numeric(duration/86400)][
, c("catName","indicator"):=list("DeathX", "SMA")][
, grp := .GRP, by=Start][ 
, subcatName := paste0(catName, paste0(sprintf("%03d", grp)))]
# ------------------------------------------------------------------------------
# unlist a column in a data.table                           https://is.gd/ZuntI3
# ------------------------------------------------------------------------------
dXsma_trend[rep(dXsma_trend[,.I], lengths(tradeDays))][, tradeDays := unlist(dXsma_trend$tradeDays)][]
dXsma_trend$tradeDays <- unlist(dXsma_trend$tradeDays)
