################################################################################
# 1.0 Setup
################################################################################
strategy.st <- portfolio.st <- account.st <- gxSMA
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
mktdata_ind_gxSMA <-  applyIndicators(               # apply indicators
    strategy                = strategy.st,
    mktdata                 = SPL.AX)
# mktdata_ind_gxSMA[is.na(
#    mktdata_ind_gxSMA)]     = 0
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
    label                   = "goldenX_SMA_open")
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
    label                   = "goldenX_SMA_close")
# ------------------------------------------------------------------------------
# applySignals(strategy.st, mktdata)
# applySignals(strategy.st, mktdata_ind_gxSMA)
# applySignals(
#    strategy                = strategy.st,
#    mktdata                 = SPL.AX)
mktdata_sig_gxSMA <- applySignals(
    strategy                = strategy.st,
    mktdata                 = mktdata_ind_gxSMA)
# mktdata_sig_gxSMA[is.na(
#    mktdata_sig_gxSMA)]     = 0
################################################################################
# 5.0	Rules
################################################################################
 add.rule(strategy.st,
    name                    = "ruleSignal",
    arguments               = list(
        sigcol              = "goldenX_SMA_open",
        sigval              = TRUE,
        orderqty            = 1000,
        ordertype           = "market",
        orderside           = "long",
        pricemethod         = "market",
        TxnFees             = 0,
        osFUN               = osMaxPos),
        type                = "enter",
        path.dep            = TRUE)
# ------------------------------------------------------------------------------
add.rule(strategy.st,
    name                    = "ruleSignal",
    arguments               = list(
        sigcol              = "goldenX_SMA_close",
        sigval              = TRUE,
        orderqty            = "all",
        ordertype           = "market",
        orderside           = "long",
        pricemethod         = "market",
        TxnFees             = 0),
        type                = "exit",
        path.dep            = TRUE)
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

cwd             <- getwd()
gxSMA_results   <- here::here("dashboard/rds", "gxSMA_results.RData")

if(file.exists(gxSMA_results)) {
  base::load(gxSMA_results)
} else {
    gxSMA_strategy <- applyStrategy(strategy.st, portfolio.st)

    if(checkBlotterUpdate(portfolio.st, account.st, verbose = TRUE)) {

      save(
        list = "gxSMA_strategy", 
        file = here::here("dashboard/rds/", paste0(gxSMA, "_", "results.RData")))

    setwd("./dashboard/rds")
    save.strategy(strategy.st)
#   save.strategy(paste0(strategy.st, "_", "strategy"))
    setwd(cwd)

    }
  }

t2 <- Sys.time()
print(t2 - t1)
################################################################################
# 9.0	Evaluation - update P&L and generate transactional history
################################################################################
updatePortf(portfolio.st)
dateRange  <- time(getPortfolio(portfolio.st)$summary)[-1]
updateAcct(account.st, dateRange)
updateEndEq(account.st)

gxSMA_pts <- blotter::perTradeStats(portfolio.st, symbols)

gxSMA_stats <- data.table(tradeStats(portfolio.st, use = "trades", inclZeroDays = FALSE))
gxSMA_stats[, 4:ncol(gxSMA_stats)] <- round(gxSMA_stats[, 4:ncol(gxSMA_stats)], 2)
gxSMA_stats <- gxSMA_stats[, data.table(t(.SD), keep.rownames = TRUE)]
################################################################################
# 8.0	Trend - create dashboard dataset
################################################################################
gxSMA_trend <- data.table(gxSMA_pts)
gxSMA_trend[, `:=`(tradeDays, lapply(paste0(gxSMA_pts[, 1], "/", gxSMA_pts[, 2]), 
  function(x) length(SPL.AX[, 6][x])+1))]
gxSMA_trend[, calendarDays := as.numeric(duration/86400)]

gxSMA_trend[, c("catName","indicator"):=list("GoldenX", "EMA")]
gxSMA_trend[, grp := .GRP, by=Start] 
gxSMA_trend[, subcatName := paste0(catName, paste0(sprintf("%03d", grp)))]

gxSMA_trend[, `:=`(tradeDays, lapply(paste0(gxSMA_pts[, 1], "/", gxSMA_pts[, 2]), 
  function(x) length(SPL.AX[, 6][x])+1))][
, calendarDays := as.numeric(duration/86400)][
, c("catName","indicator"):=list("GoldenX", "SMA")][
, grp := .GRP, by=Start][ 
, subcatName := paste0(catName, paste0(sprintf("%03d", grp)))]

# unlist a column in a data.table                           https://is.gd/ZuntI3
gxSMA_trend[rep(gxSMA_trend[,.I], lengths(tradeDays))][, tradeDays := unlist(gxSMA_trend$tradeDays)][]
gxSMA_trend$tradeDays <- unlist(gxSMA_trend$tradeDays)
