################################################################################
# 1.0 Setup
################################################################################
strategy.st <- portfolio.st <- account.st <- gXsma
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
gXsma_mktdata_ind <-  applyIndicators(               # apply indicators
    strategy                = strategy.st,
    mktdata                 = SPL.AX)
################################################################################
# 4.0	Signals
################################################################################
add.signal(strategy.st,
    name                    = "sigFormula",
    arguments               = list(
         columns            = c("SMA.020","SMA.050","SMA.100", "SMA.200"),
         formula            = "(SMA.020 > SMA.050 & 
                                SMA.050 > SMA.100 & 
                                SMA.100 > SMA.200)",
         label              = "trigger",
         cross              = TRUE),
    label                   = "gXsma_open")
# ------------------------------------------------------------------------------
add.signal(strategy.st,
    name                    = "sigFormula",
    arguments               = list
         (columns           = c("SMA.020","SMA.050","SMA.100", "SMA.200"),
         formula            = "(SMA.020 < SMA.050 | 
                                SMA.050 < SMA.100 | 
                                SMA.100 < SMA.200)",
         label              = "trigger",
         cross              = TRUE),
    label                   = "gXsma_close")
# ------------------------------------------------------------------------------
gXsma_mktdata_sig  <- applySignals(
    strategy                = strategy.st,
    mktdata                 = gXsma_mktdata_ind)
################################################################################
# 5.0	Rules
################################################################################
 add.rule(strategy.st,
    name                    = "ruleSignal",
    arguments               = list(
        sigcol              = "gXsma_open",
        sigval              = TRUE,
        orderqty            = 1000,
        orderside           = "long",
        ordertype           = "market",
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
        sigcol              = "gXsma_close",
        sigval              = TRUE,
        orderqty            = "all",
        orderside           = "long",
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
    timestamp               <- initDate, 
    maxpos                  <- 100,
    minpos                  <- 0)
################################################################################
# 7.0	Strategy
################################################################################
# browser()
t1 <- Sys.time()
gXsma_strategy <- applyStrategy(strategy.st, portfolio.st, mktdata, symbols)
t2 <- Sys.time()
print(t2 - t1)
# ------------------------------------------------------------------------------
# cwd             <- getwd()
gXsma_results   <- here::here("dashboard/rds", "gXsma_results.RData")
# ------------------------------------------------------------------------------
# if(file.exists(gXsma_results)) {
#   base::load(gXsma_results)
# } else {
#     gXsma_strategy <- applyStrategy(strategy.st, portfolio.st)

#     if(checkBlotterUpdate(portfolio.st, account.st, verbose = TRUE)) {

#       save(
#         list = "gXsma_strategy", 
#         file = here::here("dashboard/rds/", paste0(gXsma, "_", "results.RData")))

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
updatePortf(portfolio.st)
dateRange  <- time(getPortfolio(portfolio.st)$summary)[-1]
updateAcct(account.st, dateRange)
updateEndEq(account.st)
save.strategy(strategy.st)
# ------------------------------------------------------------------------------
gXsma_pts <- blotter::perTradeStats(portfolio.st, symbols)
# ------------------------------------------------------------------------------
gXsma_stats <- data.table(tradeStats(portfolio.st, use = "trades", inclZeroDays = FALSE))
gXsma_stats[, 4:ncol(gXsma_stats)] <- round(gXsma_stats[, 4:ncol(gXsma_stats)], 2)
gXsma_stats <- gXsma_stats[, data.table(t(.SD), keep.rownames = TRUE)]
################################################################################
# 8.0	Trend - create dashboard dataset
################################################################################
gXsma_trend <- data.table(gXsma_pts)
gXsma_trend[, `:=`(tradeDays, lapply(paste0(gXsma_pts[, 1], "/", gXsma_pts[, 2]), 
  function(x) length(SPL.AX[, 6][x])+1))]
gXsma_trend[, calendarDays := as.numeric(duration/86400)]
# ------------------------------------------------------------------------------
gXsma_trend[, c("catName","indicator"):=list("GoldenX", "EMA")]
gXsma_trend[, grp := .GRP, by=Start] 
gXsma_trend[, subcatName := paste0(catName, paste0(sprintf("%03d", grp)))]
# ------------------------------------------------------------------------------
gXsma_trend[, `:=`(tradeDays, lapply(paste0(gXsma_pts[, 1], "/", gXsma_pts[, 2]), 
  function(x) length(SPL.AX[, 6][x])+1))][
, calendarDays := as.numeric(duration/86400)][
, c("catName","indicator"):=list("GoldenX", "SMA")][
, grp := .GRP, by=Start][ 
, subcatName := paste0(catName, paste0(sprintf("%03d", grp)))]
# ------------------------------------------------------------------------------
# unlist a column in a data.table                           https://is.gd/ZuntI3
# ------------------------------------------------------------------------------
gXsma_trend[rep(gXsma_trend[,.I], lengths(tradeDays))][, tradeDays := unlist(gXsma_trend$tradeDays)][]
gXsma_trend$tradeDays <- unlist(gXsma_trend$tradeDays)
